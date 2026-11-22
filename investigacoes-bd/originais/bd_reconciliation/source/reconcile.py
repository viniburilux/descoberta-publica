#!/usr/bin/env python3
"""reconcile.py - Gerador configuravel de SQL de diagnostico de relacionamentos.

Componente da linha bd_reconciliation (Lux-Lab). Recebe uma configuracao de
relacionamento (configs/relationships/*.json) e gera a suite de consultas
diagnosticas em BigQuery Standard SQL:

  01_chaves_nulas.sql        - registros com chave nula/vazia nos dois lados
  02_duplicidade.sql         - chaves distintas vs registros nos dois lados
  03_transformacoes.sql      - comparacao de transformacoes da chave (quando >1)
  04_cobertura.sql           - correspondencia por registros e por ids distintos
  05_residuos.sql            - classificacao dos nao correspondentes
  06_estrutura.sql           - checagens estruturais da chave (quando configurado)

O componente NAO executa as consultas: a execucao fica a cargo do executor
disponivel (ex.: assistente de dados da BD, conforme a investigacao original),
preservando o limite de custo zero. A saida e deterministica para uma mesma
config, o que permite regresso contra os resultados registrados no corpus.

Uso:
  python3 reconcile.py --config configs/relationships/sicor_car.json --out outputs/sql/sicor_car/
  python3 reconcile.py --config configs/relationships/rais_cnae.json --print
"""
import argparse
import json
import os
import sys


def load_config(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def filter_clause(filters):
    """Render simple filter dict into a WHERE fragment (values literal)."""
    parts = []
    for field, val in (filters or {}).items():
        if isinstance(val, list):
            parts.append(f"{field} IN ({', '.join(str(v) for v in val)})")
        elif isinstance(val, str) and val.startswith(">="):
            parts.append(f"{field} >= {val[2:]}")
        else:
            parts.append(f"{field} = {val}")
    return ("WHERE " + " AND ".join(parts)) if parts else ""


def key_expr(side, transform):
    return transform["expr"].replace("{key}", side["key"])


def sql_chaves_nulas(cfg):
    l, r = cfg["left"], cfg["right"]
    return f"""-- 01_chaves_nulas | {cfg['id']}
WITH l AS (
  SELECT COUNT(*) AS registros,
         COUNTIF({l['key']} IS NULL OR TRIM(CAST({l['key']} AS STRING)) = '') AS chave_vazia
  FROM `{l['table']}`
  {filter_clause(l.get('filters'))}
), r AS (
  SELECT COUNT(*) AS registros,
         COUNTIF({r['key']} IS NULL OR TRIM(CAST({r['key']} AS STRING)) = '') AS chave_vazia
  FROM `{r['table']}`
  {filter_clause(r.get('filters'))}
)
SELECT 'left' AS lado, registros, chave_vazia FROM l
UNION ALL
SELECT 'right', registros, chave_vazia FROM r;
"""


def sql_duplicidade(cfg):
    l, r = cfg["left"], cfg["right"]
    return f"""-- 02_duplicidade | {cfg['id']}
WITH l AS (
  SELECT COUNT(*) AS registros, COUNT(DISTINCT {l['key']}) AS chaves_distintas
  FROM `{l['table']}` {filter_clause(l.get('filters'))}
), r AS (
  SELECT COUNT(*) AS registros, COUNT(DISTINCT {r['key']}) AS chaves_distintas
  FROM `{r['table']}` {filter_clause(r.get('filters'))}
)
SELECT 'left' AS lado, registros, chaves_distintas,
       registros - chaves_distintas AS chaves_repetidas FROM l
UNION ALL
SELECT 'right', registros, chaves_distintas,
       registros - chaves_distintas FROM r;
"""


def sql_transformacoes(cfg):
    l, r = cfg["left"], cfg["right"]
    blocks = []
    for t in cfg.get("transforms", []):
        lk, rk = key_expr(l, t), key_expr(r, t)
        blocks.append(f"""SELECT '{t['name']}' AS transformacao,
  COUNT(*) AS registros_left,
  COUNTIF(r.__k IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.__k IS NOT NULL, l.__k, NULL)) AS ids_correspondentes
FROM (SELECT {lk} AS __k FROM `{l['table']}` {filter_clause(l.get('filters'))}) l
LEFT JOIN (SELECT DISTINCT {rk} AS __k FROM `{r['table']}` {filter_clause(r.get('filters'))}) r
USING (__k)""")
    return "-- 03_transformacoes | " + cfg["id"] + "\n" + "\nUNION ALL\n".join(blocks) + ";\n"


import re as _re


def nonempty_key_predicate(side):
    """Cobertura e medida sobre chaves preenchidas (denominador honesto).
    Chave simples: exclui nulos e strings vazias. Chave composta: exige nao-nulo."""
    k = side["key"]
    if _re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", k):
        return f"{k} IS NOT NULL AND TRIM(CAST({k} AS STRING)) != ''"
    return f"{k} IS NOT NULL"


def where_with_key(side):
    base = filter_clause(side.get("filters"))
    pred = nonempty_key_predicate(side)
    if base:
        return base + "\n  AND " + pred
    return "WHERE " + pred


def sql_cobertura(cfg):
    l, r = cfg["left"], cfg["right"]
    t = cfg["transforms"][-1]  # transformacao adotada e a ultima
    lk, rk = key_expr(l, t), key_expr(r, t)
    part = l.get("partition_field")
    cte_part = f"{part}," if part else ""
    part_sel = f"l.{part}," if part else ""
    group = f"GROUP BY l.{part} ORDER BY l.{part}" if part else ""
    return f"""-- 04_cobertura | {cfg['id']} | transformacao adotada: {t['name']}
WITH l AS (
  SELECT {cte_part} {lk} AS __k
  FROM `{l['table']}`
  {where_with_key(l)}
), r AS (
  SELECT DISTINCT {rk} AS __k
  FROM `{r['table']}`
  {filter_clause(r.get('filters'))}
)
SELECT
  {part_sel}
  COUNT(*) AS registros_left,
  COUNT(DISTINCT l.__k) AS ids_distintos_left,
  COUNTIF(r.__k IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.__k IS NOT NULL, l.__k, NULL)) AS ids_correspondentes,
  COUNTIF(r.__k IS NULL) AS registros_sem_correspondencia
FROM l LEFT JOIN r USING (__k)
{group};
"""


def sql_residuos(cfg):
    l, r = cfg["left"], cfg["right"]
    t = cfg["transforms"][-1]
    lk, rk = key_expr(l, t), key_expr(r, t)
    return f"""-- 05_residuos | {cfg['id']} | amostra e contagem dos nao correspondentes
WITH l AS (
  SELECT DISTINCT {lk} AS __k FROM `{l['table']}` {filter_clause(l.get('filters'))}
), r AS (
  SELECT DISTINCT {rk} AS __k FROM `{r['table']}` {filter_clause(r.get('filters'))}
)
SELECT COUNT(*) AS ids_left_sem_correspondencia
FROM l LEFT JOIN r USING (__k)
WHERE r.__k IS NULL;
"""


def sql_estrutura(cfg):
    sc = cfg.get("structural_checks")
    if not sc:
        return None
    l = cfg["left"]
    t = cfg["transforms"][-1]
    k = key_expr(l, t)
    emb = sc.get("campos_embutidos", {})
    emb_sel = ",\n  ".join(f"{expr.replace('{key}', k)} AS {name}" for name, expr in emb.items())
    emb_sel = (",\n  " + emb_sel) if emb_sel else ""
    return f"""-- 06_estrutura | {cfg['id']} | checagem estrutural da chave normalizada
SELECT
  LENGTH({k}) AS comprimento,
  COUNTIF(REGEXP_CONTAINS({k}, r'{sc['regex_formato']}')) AS formato_valido,
  COUNT(*) AS registros{emb_sel}
FROM `{l['table']}`
{filter_clause(l.get('filters'))}
GROUP BY comprimento{', ' + ', '.join(emb.keys()) if emb else ''}
ORDER BY registros DESC;
"""


SUITES = {
    "01_chaves_nulas": sql_chaves_nulas,
    "02_duplicidade": sql_duplicidade,
    "03_transformacoes": sql_transformacoes,
    "04_cobertura": sql_cobertura,
    "05_residuos": sql_residuos,
    "06_estrutura": sql_estrutura,
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", required=True)
    ap.add_argument("--out", help="diretorio de saida para os .sql")
    ap.add_argument("--print", action="store_true", dest="imprimir")
    args = ap.parse_args()

    cfg = load_config(args.config)
    gerados = {}
    for nome, fn in SUITES.items():
        sql = fn(cfg)
        if sql:
            gerados[nome] = sql

    if args.out:
        os.makedirs(args.out, exist_ok=True)
        for nome, sql in gerados.items():
            with open(os.path.join(args.out, f"{nome}.sql"), "w", encoding="utf-8") as f:
                f.write(sql)
        print(f"{len(gerados)} consultas geradas em {args.out}")
    if args.imprimir or not args.out:
        for nome, sql in gerados.items():
            print("=" * 70)
            print(sql)


if __name__ == "__main__":
    sys.exit(main())
