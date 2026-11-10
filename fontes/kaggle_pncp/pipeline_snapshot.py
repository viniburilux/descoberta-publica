# PNCP Kaggle source-separated pipeline. Canonical v6.3 functions, unchanged.
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Categorizador QPI v6.2 (FINAL) - esquema antigo (9 categorias BA, fidelidade ~91% nos rotulados)
+ categorias nacionais derivadas do corpus (agua, transporte).
Regras base = v3; extensao = agua/transporte; qualificacao restrita a forma profissional;
guarda de credenciamento nao bloqueia EDITAL inicial (ato), bloqueia referencia procedural."""
import re, unicodedata

def norm(t):
    if not t: return ""
    return unicodedata.normalize("NFKD", t).encode("ascii","ignore").decode().upper()

R = {
 "artistico": re.compile(r"\b(SHOW|BANDA|CANTOR(A)?|ARTISTA(S)?|ARTISTIC[OA]|APRESENTACAO|FORRO(UEIRO)?|PAGODE|SERTANEJ[OA]|DJ\b|MUSICO(S)?|MUSICAL|FESTEJO(S)?|TRIO ELETRICO|SAMBA\b|ESPETACULO|TEATRO|PALCO\b|CARNAVAL|SAO JOAO|FESTA JUNINA|ARRAIA|QUADRILHA|AXE\b|MICARETA|MARCHINHA|SERENATA|SERESTA)"),
 "agua": re.compile(r"\b(AGUA POTAVEL|CARRO PIPA|ABASTECIMENTO DE AGUA|DESSALINIZADOR|ENTREGA DE AGUA)"),
 "locacao": re.compile(r"\b(LOCACAO|ALUGUEL|ALUGUER|LOCADOR(A)?\b|LOCATARI[OA])\b"),
 "consultoria": re.compile(r"\b(CONSULTORIA|ASSESSORIA|ASSESSORAMENTO|ADVOCA\w*|CONTABIL|CONTABEIS|AUDITORIA)\b"),
 "capacitacao": re.compile(r"\b(CAPACITACAO|CURSO(S)?\b|TREINAMENTO|QUALIFICACAO (E HABILITACAO )?PROFISSIONAL|HABILITACAO PROFISSIONAL|OFICINA(S)?\b|WORKSHOP|APERFEICOAMENTO|CONGRESSO|INSCRICAO|ENCONTRO (NACIONAL|ESTADUAL|REGIONAL)|MARCHA\b)"),
 "saude": re.compile(r"\b(SAUDE|MEDIC[OA]|HOSPITAL(AR)?|ODONTOLOG|EXAME(S)?|PSICOLOG|FISIOTERAP|ENFERMAG|AMBULANCIA|INTERNACAO\b|LABORATORI[OA]|CLINIC[OA]|NUTRICIONISTA|DENTISTA|FARMAC[EU]TIC|CIRURGI[AO])"),
 "manutencao": re.compile(r"\b(MANUTENCAO|REPARO(S)?\b|CONSERVACAO|REFORMA(S)?\b)"),
 "aquisicao": re.compile(r"\b(AQUISICAO|COMPRA|FORNECIMENTO|ASSINATURA)\b"),
 "transporte": re.compile(r"\b(TRANSPORTE(S)?\b|PASSAGENS (AEREAS|RODOVIARIAS)|PASSAGEM (AEREA|RODOVIARIA))"),
}
PRIORIDADE = ["artistico","agua","locacao","consultoria","capacitacao","saude","manutencao","aquisicao","transporte"]

CRED = re.compile(r"\b(CREDENCIAMENTO|CREDENCIAD[OA]|CHAMAMENTO PUBLICO)\b")
CRED_PROC = re.compile(r"(CONFORME|PROVENIENTE|PROCESSO|REFERENTE|DECORRENTE)[^\n]{0,45}$")

def categoriza(objeto):
    t = norm(objeto)
    if not t.strip(): return "outros"
    for cat in PRIORIDADE:
        if R[cat].search(t): return cat
    m = CRED.search(t)
    if m:
        if m.start() < 70 and not CRED_PROC.search(t[:m.start()]):
            return "credenciamento"
        # ato de credenciamento mencionado mais adiante, sem categoria de dominio
        return "credenciamento"
    return "outros"

def sub_artistico(objeto):
    t = norm(objeto)
    if re.search(r"CARNAVAL|TRIO ELETRICO|AXE\b|ABADA|BLOCO(S)? DE|MICARETA|MARCHINHA", t): return "carnaval"
    if re.search(r"FORRO|SAO JOAO|SANFONA|JUNINA|ARRAIA|QUADRILHA", t): return "forro_sao_joao"
    return "outros_show"

def classificar(objeto, amparo=None):
    cat = categoriza(objeto)
    sub = sub_artistico(objeto) if cat == "artistico" else ""
    return cat, sub

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

"""Offline source-separated PNCP snapshot transformation. No network operations."""
import sys,json,hashlib,time,re,os
from pathlib import Path
from collections import Counter
import pyarrow as pa, pyarrow.parquet as pq, pyarrow.compute as pc
ROOT=Path(__file__).resolve().parent; SRC=ROOT/'dados'; OUT=SRC/'derivado_kaggle_v1';OUT.mkdir(exist_ok=True)
sys.path.insert(0,str(ROOT))

SOURCE_URL='https://www.kaggle.com/datasets/lucasrangelss/pncp-raw-trusted-part-1'
SOURCE_SHA='7d7062459c6c023cdf05b5c47be676fe64699d281c84b6af633b7889e48648d3'
# Broad patterns deliberately prefer over-redaction to leaking identifier-like strings.
PATTERNS=[('cpf_formatado',re.compile(r'(?<!\d)\d{3}\s*\.\s*\d{3}\s*\.\s*\d{3}\s*-\s*\d{2}(?!\d)')),
 ('cpf_11digitos',re.compile(r'(?<!\d)\d{11}(?!\d)')),
 ('email',re.compile(r'[A-Z0-9._%+\-]+@[A-Z0-9.\-]+\.[A-Z]{2,}',re.I)),
 ('telefone_formatado',re.compile(r'(?<!\d)(?:\+55\s*)?\(\d{2}\)\s*\d{4,5}[-\s]\d{4}(?!\d)')),
 ('telefone_contexto',re.compile(r'(?i)(?:telefone|celular|whatsapp|fone)\s*[:\-]?\s*(?:\+?55\s*)?(?:\(?\d{2}\)?[\s-]*)?\d{4,5}[\s-]?\d{4}(?!\d)')),
 ('rg_contexto',re.compile(r'(?i)\bRG\s*[:nº°.\-]*\s*\d[\d.\-]{5,14}'))]
def mask(s,counts):
 if not s:return ''
 for label,pat in PATTERNS:
  s,n=pat.subn('[DADO_PESSOAL_MASCARADO]',s);counts[label]+=n
 return s
COLS=['numero_controle_pncp','modalidade_id','modalidade_nome','objeto_compra','valor_total_estimado','valor_total_homologado','data_publicacao_pncp','data_atualizacao','orgao_cnpj','orgao_razao_social','orgao_esfera_id','unidade_uf_sigla','unidade_municipio_nome','unidade_codigo_ibge']
SCHEMA=pa.schema([(x,pa.string()) for x in ['numero_controle_pncp','modalidade_nome','objeto_compra','orgao_cnpj','orgao_razao_social','orgao_esfera_id','unidade_uf_sigla','unidade_municipio_nome','categoria','subcategoria','fonte_url','fonte_sha256','versao_classificador','validacao_classificador','politica_privacidade']]+[(x,pa.int64()) for x in ['modalidade_id','ano_publicacao','unidade_codigo_ibge']]+[(x,pa.float64()) for x in ['valor_total_estimado','valor_total_homologado']]+[(x,pa.timestamp('us',tz='UTC')) for x in ['data_publicacao_pncp','data_atualizacao']]+[('flag_valor_1000x',pa.bool_())])
def sha(p):
 h=hashlib.sha256()
 with open(p,'rb') as f:
  for b in iter(lambda:f.read(4*1024*1024),b''):h.update(b)
 return h.hexdigest()
def run(mod,year_filter=None):
 t=time.monotonic(); dest=OUT/f'mod{mod}'
 if year_filter:dest=dest/f'publicacao{year_filter}'
 dest.mkdir(exist_ok=True,parents=True)
 if (dest/'manifest.json').exists():print('ALREADY_DONE',mod,flush=True);return
 writers={};counts=Counter();cats=Counter();years=Counter();flags=0;total=0
 try:
  for batch in pq.ParquetFile(SRC/'trusted__pncp_contratacoes.parquet').iter_batches(batch_size=40000,columns=COLS):
   tab=pa.Table.from_batches([batch]);tab=tab.filter(pc.equal(tab['modalidade_id'],mod))
   if year_filter:tab=tab.filter(pc.equal(pc.year(tab['data_publicacao_pncp']),year_filter))
   if not len(tab):continue
   byyear={}
   for r in tab.to_pylist():
    obj=r['objeto_compra'] or '';municipio=r['unidade_municipio_nome'] or '';cat,sub=classificar63(obj,municipio);flag=valor_digitacao_1000x(obj,r['valor_total_estimado']);year=r['data_publicacao_pncp'].year
    r.update(objeto_compra=mask(obj,counts),orgao_razao_social=mask(r['orgao_razao_social'],counts),categoria=cat,subcategoria=sub,ano_publicacao=year,flag_valor_1000x=flag,fonte_url=SOURCE_URL,fonte_sha256=SOURCE_SHA,versao_classificador='v6.3',validacao_classificador='reaplicado, sem validacao independente por modalidade',politica_privacidade='minimizacao+regex_v1; nao anonimiza nomes; nao anonimiza nomes')
    byyear.setdefault(year,[]).append(r);total+=1;years[year]+=1;cats[cat]+=1;flags+=flag
   for year,rows in byyear.items():
    if year not in writers:writers[year]=pq.ParquetWriter(dest/f'ano{year}.parquet.tmp',SCHEMA,compression='zstd')
    writers[year].write_table(pa.Table.from_pylist(rows,schema=SCHEMA))
 finally:
  for w in writers.values():w.close()
 files=[]
 for year in sorted(writers):
  p=dest/f'ano{year}.parquet';os.replace(str(p)+'.tmp',p)
  assert pq.ParquetFile(p).metadata.num_rows==years[year]
  # Full readback of retained free-text fields and same-pattern residual scan.
  residual=Counter()
  for batch in pq.ParquetFile(p).iter_batches(columns=['objeto_compra','orgao_razao_social']):
   for r in batch.to_pylist():
    for v in r.values():
     for label,pat in PATTERNS:residual[label]+=len(pat.findall(v or ''))
  assert not sum(residual.values()),residual
  files.append(dict(path=str(p.relative_to(OUT)),rows=years[year],bytes=p.stat().st_size,sha256=sha(p),residual_patterns=dict(residual)))
 manifest=dict(source_url=SOURCE_URL,source_sha256=SOURCE_SHA,snapshot='2026-09-30',source_separate=True,base_original_untouched=True,api_windows_complete=False,publication_notice='Source terms apply; credit original publisher. No new data license asserted.',modality_id=mod,rows=total,by_year=dict(years),by_category=dict(cats),masked_occurrences=dict(counts),flag_valor_1000x=flags,classifier='canonical v6.3 unchanged; independent validation pending across modalities',privacy='Excluded usuario_nome, informacao_complementar, justificativa_presencial, process links and other nonessential source fields. Regex masks CPF-like strings, emails, phones, RG-context. Personal names and all indirect identifiers are NOT anonymized. Not certified anonymous; names and indirect identifiers may remain.',elapsed_seconds=round(time.monotonic()-t,2),files=files)
 (dest/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2))
 print(json.dumps(manifest,ensure_ascii=False),flush=True)
if __name__=='__main__':
 if '--year' in sys.argv:
  run(int(sys.argv[1]),int(sys.argv[sys.argv.index('--year')+1]))
 else:
  for mod in map(int,sys.argv[1:]):run(mod)
