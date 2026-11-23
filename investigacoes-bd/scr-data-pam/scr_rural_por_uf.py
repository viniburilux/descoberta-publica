#!/usr/bin/env python3
"""Baixa o SCR.data do Banco Central (um ZIP por ano) e resume o credito rural por UF.

Uso: python3 scr_rural_por_uf.py 2024 [saida.csv]

Fonte oficial: https://dadosabertos.bcb.gov.br/dataset/scr_data
ZIP anual:    https://www.bcb.gov.br/pda/desig/scrdata_{ANO}.zip  (CSV mensal dentro)
Sem dependencias externas. O ZIP (~170 MB) vai para um arquivo temporario e e apagado.
Nao somamos numero_de_operacoes: o BCB usa -1 como valor sigiloso em celulas pequenas.
Saida: UMA linha por data_base x uf x submodalidade, so da modalidade rural.
Nao grava CPF nem dado individual: o SCR.data ja e agregado.
"""
import csv, io, os, sys, tempfile, urllib.request, zipfile, datetime
from collections import defaultdict

ano = sys.argv[1] if len(sys.argv) > 1 else "2024"
saida = sys.argv[2] if len(sys.argv) > 2 else f"scr_rural_uf_{ano}.csv"
url = f"https://www.bcb.gov.br/pda/desig/scrdata_{ano}.zip"
MODALIDADE_RURAL = "Financiamentos rurais"  # nome comeca assim em 2024; confirmar em outros anos

def num(x):
    return float(x.replace(".", "").replace(",", ".")) if x else 0.0

tmp = tempfile.NamedTemporaryFile(suffix=".zip", delete=False)
tmp.close()
try:
    urllib.request.urlretrieve(url, tmp.name)
    baixado_em = datetime.date.today().isoformat()
    ag = defaultdict(lambda: [0.0, 0.0, 0.0, 0.0])
    with zipfile.ZipFile(tmp.name) as z:
        for nome in sorted(n for n in z.namelist() if n.endswith(".csv")):
            with z.open(nome) as f:
                rd = csv.DictReader(io.TextIOWrapper(f, encoding="utf-8-sig"), delimiter=";")
                for w in rd:
                    if not w["modalidade"].strip().startswith(MODALIDADE_RURAL):
                        continue
                    k = (w["data_base"], w["uf"], w["submodalidade"].strip())
                    a = ag[k]
                    a[0] += num(w["carteira_ativa"])
                    a[1] += num(w["carteira_inadimplencia"])
                    a[2] += num(w["vencido_acima_de_90_dias"])
                    a[3] += num(w["ativo_problematico"])
finally:
    os.unlink(tmp.name)

with open(saida, "w", newline="", encoding="utf-8") as o:
    wr = csv.writer(o)
    wr.writerow(["data_base", "uf", "submodalidade",
                 "carteira_ativa", "carteira_inadimplencia", "vencido_acima_de_90_dias",
                 "ativo_problematico", "baixado_em", "fonte"])
    for (d, uf, sub), a in sorted(ag.items()):
        wr.writerow([d, uf, sub, f"{a[0]:.2f}", f"{a[1]:.2f}", f"{a[2]:.2f}", f"{a[3]:.2f}", baixado_em, url])
print(f"{len(ag)} linhas em {saida} (baixado em {baixado_em})")
