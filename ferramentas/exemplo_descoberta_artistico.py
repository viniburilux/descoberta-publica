#!/usr/bin/env python3
"""Exemplo reproducible: concentração de inexigibilidades "artistico" por município.

Lê SOMENTE os arquivos do pacote (dados/, ferramentas/, derivados/) e imprime um
ranking no stdout. Não grava nada em disco além de temporários.

Uso:
    python3 ferramentas/exemplo_descoberta_artistico.py [--top 15] [--ano 2025]

Pré-requisitos: duckdb, pandas, pyarrow.

Leitura recomendada do resultado: contagem é PISTA, não conclusão. Antes de
qualificar qualquer número aqui como "história", verifique docs/LIMITACOES.md —
em especial que valor_homologado não é valor pago e que a classificação é
heurística com erros conhecidos (ex.: cursos de teatro entram como "artistico").
"""
from __future__ import annotations

import argparse
import glob
import os
import shutil
import sys
import tempfile
import zipfile

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def carregar_base(tmp: str):
    """Extrai os parquets de dados/ para tmp e devolve (lista_de_paths, uf_por_path)."""
    caminhos = []
    for zp in sorted(glob.glob(os.path.join(RAIZ, "dados", "PNCP_UF_*.zip"))):
        uf = os.path.basename(zp).split("_")[-1].replace(".zip", "")
        with zipfile.ZipFile(zp) as z:
            for name in z.namelist():
                if not name.endswith(".parquet"):
                    continue
                ano = name.split("ano_publicacao=")[1].split("/")[0]
                dest = os.path.join(tmp, f"{uf}_{ano}.parquet")
                with open(dest, "wb") as f:
                    f.write(z.read(name))
                caminhos.append((dest, uf, int(ano)))
    return caminhos


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--top", type=int, default=15)
    parser.add_argument("--ano", type=int, default=2025)
    parser.add_argument("--categoria", default="artistico")
    args = parser.parse_args(argv)

    try:
        import duckdb
        import pandas as pd
    except ImportError as exc:
        print(f"[erro] dependência ausente: {exc}. Instale duckdb, pandas e pyarrow.", file=sys.stderr)
        return 2

    sidecar = os.path.join(RAIZ, "derivados", "sidecar_categorias_v63.csv")
    ferramentas_zip = os.path.join(RAIZ, "ferramentas", "PNCP_FERRAMENTAS.zip")
    for p in (sidecar, ferramentas_zip):
        if not os.path.isfile(p):
            print(f"[erro] arquivo necessário ausente: {p}", file=sys.stderr)
            return 2

    tmp = tempfile.mkdtemp(prefix="descoberta_")
    try:
        caminhos = carregar_base(tmp)
        con = duckdb.connect()

        # Reconstruir colunas de partição (uf/ano) sem depender de layout Hive fora do zip.
        frames = []
        for dest, uf, ano in caminhos:
            df = pd.read_parquet(dest)
            df["uf_part"], df["ano_part"] = uf, ano
            frames.append(df)
        base = pd.concat(frames, ignore_index=True)
        con.register("base", base)

        con.execute(f"CREATE VIEW sc AS SELECT * FROM read_csv_auto({sidecar!r})")
        dim_path = os.path.join(tmp, "dim.parquet")
        with zipfile.ZipFile(ferramentas_zip) as zf:
            with open(dim_path, "wb") as f:
                f.write(zf.read("dim_municipios.parquet"))
        con.execute(f"CREATE VIEW dim AS SELECT * FROM read_parquet({dim_path!r})")

        n_base = con.execute("SELECT count(*) FROM base").fetchone()[0]
        cobertura = con.execute(
            "SELECT count(*) FROM base b JOIN sc s ON b.numero_controle = s.numero_controle"
        ).fetchone()[0]

        ranking = con.execute(
            f"""
            SELECT b.municipio_pncp AS municipio, b.uf_part AS uf, d.pop_2025,
                   count(*) AS registros,
                   round(sum(b.valor_homologado) / 1e6, 2) AS homologado_mi
            FROM base b
            JOIN sc s ON b.numero_controle = s.numero_controle
            LEFT JOIN dim d ON b.cod_ibge = d.cod_ibge
            WHERE s.categoria = ? AND b.ano_part = ?
            GROUP BY 1, 2, 3
            ORDER BY registros DESC
            LIMIT ?
            """,
            [args.categoria, args.ano, args.top],
        ).df()

        mensal = con.execute(
            f"""
            SELECT substr(b.publicacao, 1, 7) AS mes, count(*) AS registros
            FROM base b JOIN sc s ON b.numero_controle = s.numero_controle
            WHERE s.categoria = ? AND b.ano_part = ?
              AND b.municipio_pncp = (
                SELECT municipio_pncp FROM base b2 JOIN sc s2 ON b2.numero_controle = s2.numero_controle
                WHERE s2.categoria = ? AND b2.ano_part = ?
                GROUP BY 1 ORDER BY count(*) DESC LIMIT 1)
            GROUP BY 1 ORDER BY 1
            """,
            [args.categoria, args.ano, args.categoria, args.ano],
        ).df()

        print(f"# Exemplo de descoberta — categoria '{args.categoria}', ano {args.ano}")
        print(f"# Base: {n_base:,} linhas | join com sidecar cobre {cobertura:,} ({cobertura/n_base:.1%})")
        print("\n## Ranking por município (top {})".format(args.top))
        print(ranking.to_string(index=False))
        print(f"\n## Distribuição mensal no 1º colocado ({mensal['registros'].sum()} registros)")
        print(mensal.to_string(index=False))
        print(
            "\n## Avisos obrigatórios (docs/LIMITACOES.md)\n"
            "- Contagem é pista de investigação, não conclusão nem acusação.\n"
            "- valor_homologado NÃO é valor pago; nulos são excluídos da soma.\n"
            "- A classificação 'artistico' é heurística: inclui cursos e serviços culturais,\n"
            "  não apenas shows. Um pico pode ser política cultural declarada, não anomalia.\n"
            "- 2026 é parcial (lacuna 22–31/08); não compare com 2025 como anos completos."
        )
        return 0
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())
