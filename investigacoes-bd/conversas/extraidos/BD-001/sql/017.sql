WITH b AS (
 SELECT c.ano,c.id_contratacao_pncp,c.id_municipio,m.nome municipio,c.data_publicacao,c.nome_orgao,c.objeto_compra,c.valor_total_estimado,c.valor_total_homologado,c.modalidade,c.link_sistema_origem,
 LOWER(REGEXP_REPLACE(COALESCE(c.objeto_compra,''),r'mata de são joão|mata de sao joao','')) texto
 FROM `basedosdados.br_mgi_pncp.contratacao` c JOIN `basedosdados.br_bd_diretorios_brasil.municipio` m ON c.id_municipio=m.id_municipio
 WHERE c.ano BETWEEN 2021 AND 2026 AND m.sigla_uf='BA'
), f AS (
 SELECT *, CASE WHEN REGEXP_CONTAINS(texto,r'\bcarnaval\b|\bsão joão\b|\bsao joao\b|\bfesta junina\b|\bfestividade|\bfestejo|\bfesta popular|\bfestas tradicionais|\barr[aá]i[aá]\b|\br[eé]veillon\b|\bartista\b|\bcantor\b|\bcantora\b|\bbanda\b|\bm[uú]sico\b|\bshow[s]?\b|\bespet[aá]culo\b|\bfestival\b|\bprodução de evento\b|\bproducao de evento\b|\borganização de evento\b|\borganizacao de evento\b|\bpalco\b|\bsonoriza[cç][aã]o\b|\btenda[s]?\b|\btrio el[eé]trico\b|\bbanheiro[s]? qu[ií]mico[s]?\b') THEN 1 ELSE 0 END is_theme
 FROM b
)
SELECT municipio,ano,id_contratacao_pncp,data_publicacao,nome_orgao,modalidade,valor_total_homologado,valor_total_estimado,SAFE_DIVIDE(valor_total_homologado,valor_total_estimado) ratio,objeto_compra,link_sistema_origem
FROM f WHERE is_theme=1 AND valor_total_homologado IS NOT NULL AND valor_total_estimado IS NOT NULL AND valor_total_estimado>0
ORDER BY ratio DESC LIMIT 30