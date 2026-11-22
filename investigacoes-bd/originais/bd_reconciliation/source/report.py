#!/usr/bin/env python3
"""report.py - Relatorio diagnostico padronizado + regresso contra o corpus.

Le uma config de relacionamento e os resultados originais registrados
(inputs/recorded/<id>.json), recomputa as metricas de cobertura a partir das
contagens brutas e verifica que batem com os numeros de destaque registrados na
investigacao original. Gera outputs/runs/<data>/<id>_diagnostico.md.

A regresso aqui e sobre a LOGICA DE METRICA: as porcentagens de destaque sao
recomputadas das contagens registradas, nunca copiadas. Se uma contagem
registrada estiver errada ou o denominador mudar, o check falha.

Uso:
  python3 report.py --config configs/relationships/rais_cnae.json \
      --recorded inputs/recorded/rais_cnae.json --out outputs/runs/
"""
import argparse
import json
import os
from datetime import date


def pct(num, den):
    return (100.0 * num / den) if den else 0.0


def fmt_pct(x):
    return f"{x:.2f}".replace(".", ",") + "%"


def fmt_int(n):
    return f"{n:,}".replace(",", ".")


def check(rotulo, calculado, registrado, tolerancia_pp=0.01):
    ok = abs(calculado - registrado) <= tolerancia_pp
    return {"check": rotulo, "calculado": round(calculado, 4),
            "registrado": registrado, "ok": ok}


def avaliar(cfg, rec):
    """Recomputa metricas por relacionamento. Retorna (linhas_md, checks)."""
    rid = cfg["id"]
    L, C = [], []
    if rid == "sicor_car":
        for a in rec["cobertura_final"]:
            cov = pct(a["registros_com_snapshot"], a["registros"])
            C.append(check(f"cobertura_registros_{a['ano']}", cov, a["destaque_pct"], 0.01))
            L.append(f"| {a['ano']} | {fmt_int(a['registros'])} | {fmt_int(a['registros_com_snapshot'])} | {fmt_int(a['registros_sem_snapshot'])} | {fmt_pct(cov)} |")
        res = rec["residuos"]
        L.append(f"\nResiduo: {fmt_int(res['ids_nao_encontrados'])} ids sem correspondencia, "
                 f"{res['ids_em_municipio_com_outros_car']} em municipios com outros CARs, "
                 f"{res['ids_em_municipio_sem_car']} em municipio sem CAR.")
    elif rid == "prodes_mapbiomas":
        cov = pct(rec["chaves_com_mapbiomas"], rec["chaves_prodes"])
        C.append(check("cobertura_chaves", cov, rec["destaque_pct"], 0.01))
        L.append(f"| chaves PRODES | {fmt_int(rec['chaves_prodes'])} |")
        L.append(f"| com MapBiomas | {fmt_int(rec['chaves_com_mapbiomas'])} |")
        L.append(f"| sem MapBiomas | {fmt_int(rec['chaves_sem_mapbiomas'])} |")
        L.append(f"| cobertura | {fmt_pct(cov)} |")
    elif rid == "rais_cnae":
        cov_s = pct(rec["subclasses_com_correspondencia"], rec["subclasses_distintas_rais"])
        cov_r = pct(rec["registros_com_correspondencia"], rec["registros_rais"])
        C.append(check("cobertura_subclasses", cov_s, rec["destaque_subclasses_pct"], 0.01))
        C.append(check("cobertura_registros", cov_r, rec["destaque_registros_pct"], 0.01))
        L.append(f"| subclasses RAIS | {fmt_int(rec['subclasses_distintas_rais'])} |")
        L.append(f"| com correspondencia | {fmt_int(rec['subclasses_com_correspondencia'])} |")
        L.append(f"| cobertura subclasses | {fmt_pct(cov_s)} |")
        L.append(f"| registros RAIS | {fmt_int(rec['registros_rais'])} |")
        L.append(f"| registros com CNAE | {fmt_int(rec['registros_com_correspondencia'])} |")
        L.append(f"| cobertura registros | {fmt_pct(cov_r)} |")
        for d in rec["sem_correspondencia_detalhe"]:
            L.append(f"| sem correspondencia: {d['subclasse']} | {fmt_int(d['registros'])} registros |")
    elif rid == "ibama_autos_embargos":
        termos_preenchidos = rec["embargos_registros"] - rec["embargos_id_nulo"]
        cov_termos = pct(rec["embargos_com_auto_correspondente"], termos_preenchidos)
        cov_total = pct(rec["embargos_com_auto_correspondente"], rec["embargos_registros"])
        C.append(check("cobertura_termos_preenchidos", cov_termos, rec["destaque_termos_pct"], 0.01))
        C.append(check("cobertura_todos_registros", cov_total, rec["destaque_total_pct"], 0.01))
        L.append(f"| embargos (registros) | {fmt_int(rec['embargos_registros'])} |")
        L.append(f"| com id_auto nulo | {fmt_int(rec['embargos_id_nulo'])} |")
        L.append(f"| com auto correspondente | {fmt_int(rec['embargos_com_auto_correspondente'])} |")
        L.append(f"| cobertura sobre termos preenchidos | {fmt_pct(cov_termos)} |")
        L.append(f"| cobertura sobre todos os registros | {fmt_pct(cov_total)} |")
        L.append(f"| autos com ao menos um embargo | {fmt_int(rec['autos_com_pelo_menos_um_embargo'])} |")
    else:
        raise ValueError(f"sem avaliador para {rid}")
    return L, C


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", required=True)
    ap.add_argument("--recorded", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    cfg = json.load(open(args.config, encoding="utf-8"))
    rec = json.load(open(args.recorded, encoding="utf-8"))

    linhas, checks = avaliar(cfg, rec)
    hoje = date.today().isoformat()
    outdir = os.path.join(args.out, hoje)
    os.makedirs(outdir, exist_ok=True)

    md = []
    md.append(f"# Diagnostico de relacionamento: {cfg['titulo']}")
    md.append(f"\n- Relacionamento: `{cfg['id']}`")
    md.append(f"- Bases: `{cfg['left']['table']}` x `{cfg['right']['table']}`")
    md.append(f"- Chaves: {cfg['left']['key']} = {cfg['right']['key']}")
    md.append(f"- Fonte dos numeros: execucao original registrada ({rec.get('fonte','corpus')})")
    md.append(f"- Gerado em: {hoje} por report.py (metricas recomputadas das contagens)")
    md.append("\n## Resultados\n")
    md.extend(linhas)
    md.append("\n## Regresso (metrica recomputada vs destaque registrado)\n")
    md.append("| Check | Calculado | Registrado | OK |")
    md.append("|---|---:|---:|:--:|")
    for c in checks:
        md.append(f"| {c['check']} | {c['calculado']} | {c['registrado']} | {'SIM' if c['ok'] else 'NAO'} |")
    md.append("\n## Problemas conhecidos\n")
    for p in cfg.get("problemas_conhecidos", []):
        md.append(f"- {p}")
    md.append(f"\nStatus de validacao: **{cfg['status_validacao']}** "
              "(numeros da execucao original; nova execucao via executor BD pendente).")

    path = os.path.join(outdir, f"{cfg['id']}_diagnostico.md")
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(md) + "\n")

    falhas = [c for c in checks if not c["ok"]]
    print(f"{cfg['id']}: {len(checks) - len(falhas)}/{len(checks)} checks OK -> {path}")
    if falhas:
        for c in falhas:
            print(f"  FALHOU: {c['check']} calc={c['calculado']} reg={c['registrado']}")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
