#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Categorizador QPI v6.3 (camada montante) = v6.2 + 2 correcoes de observacao:
1) SAO JOAO/QUADRILHA so disparam artistico com contexto de festa (evita nome de
   cidade/bairro tipo "Barra de Sao Joao", "Sao Joao de Meriti" virar show).
2) nome do proprio municipio eh removido do texto antes de classificar.
3) flag valor_digitacao_1000x: valor_estimado ~1000x valor mencionado no objeto
   (ex.: objeto diz R$ 66.000,00, campo registra R$ 66.000.000) - provavel erro
   de digitacao na fonte; excluido dos somatorios, mantido no CSV com flag.
Mantem prioridades/categorias da v6.2."""
import re
from categorizar import norm, R, PRIORIDADE, CRED, CRED_PROC

R63 = dict(R)
R63["artistico"] = re.compile(r"\b(SHOW|BANDA|CANTOR(A)?|ARTISTA(S)?|ARTISTIC[OA]|APRESENTACAO|FORRO(UEIRO)?|PAGODE|SERTANEJ[OA]|DJ\b|MUSICO(S)?|MUSICAL|FESTEJO(S)?|TRIO ELETRICO|SAMBA\b|ESPETACULO|TEATRO|PALCO\b|CARNAVAL|FESTA JUNINA|ARRAIA|AXE\b|MICARETA|MARCHINHA|SERENATA|SERESTA)")
SJ_CTX = re.compile(r"(FEST\w*|ARRAIA\w*|ATRAC\w*|EVENTO\w*|COMEMORA\w*|TRADICIONAL|POLO\w*|CLIMA\s+DE)\s+(DE\s+|DO\s+|DA\s+|DAS\s+|DOS\s+|NO\s+|NA\s+)?SAO JOAO\b|SAO JOAO\s+(19|20)\d\d")

def _prep(objeto, municipio=None):
    t = norm(objeto)
    t = t.replace("GINASTICA ARTISTICA", "GINASTICA")
    if municipio:
        tm = norm(municipio)
        if len(tm) >= 4:
            t = t.replace(tm, " ")
    return t

def categoriza63(objeto, municipio=None):
    t = _prep(objeto, municipio)
    if not t.strip(): return "outros"
    if R63["artistico"].search(t) or SJ_CTX.search(t): return "artistico"
    for cat in PRIORIDADE[1:]:
        if R63[cat].search(t): return cat
    m = CRED.search(t)
    if m:
        if m.start() < 70 and not CRED_PROC.search(t[:m.start()]):
            return "credenciamento"
        return "credenciamento"
    return "outros"

def sub_artistico63(objeto, municipio=None):
    t = _prep(objeto, municipio)
    if re.search(r"CARNAVAL|TRIO ELETRICO|AXE\b|ABADA|BLOCO(S)? DE|MICARETA|MARCHINHA", t): return "carnaval"
    if re.search(r"FORRO|SANFONA|JUNINA|ARRAIA|QUADRILHA", t) or SJ_CTX.search(t): return "forro_sao_joao"
    return "outros_show"

def classificar63(objeto, municipio=None):
    cat = categoriza63(objeto, municipio)
    return cat, (sub_artistico63(objeto, municipio) if cat == "artistico" else "")

VAL = re.compile(r"R\$\s*([\d]{1,3}(?:\.\d{3})*,\d{2})")
def valor_digitacao_1000x(objeto, est):
    if not est: return False
    for m in VAL.finditer(objeto or ""):
        try: v = float(m.group(1).replace(".","").replace(",","."))
        except ValueError: continue
        if v > 0 and 900*v <= est <= 1100*v:
            return True
    return False
