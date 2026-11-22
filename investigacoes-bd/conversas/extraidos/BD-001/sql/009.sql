WITH base AS (
  SELECT c.ano, c.id_contratacao_pncp, c.id_municipio, m.nome AS municipio, c.data_publicacao, c.nome_orgao, c.objeto_compra, c.valor_total_estimado, c.valor_total_homologado, c.link_sistema_origem,
    CASE
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'\bcarnaval\b|\bsão joão\b|\bsao joao\b|\bfesta junina\b|\bfestas juninas\b|\bfestividade|\bfestejo|\bcomemoração de .*?(festa|evento|aniversário|aniversario)|\bcomemoracao de .*?(festa|evento|aniversario)|\barr[aá]i[aá]\b|\br[eé]veillon\b') THEN 'Festas populares e comemorações'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'\bartista\b|\bartistas\b|\bcantor\b|\bcantora\b|\bbanda\b|\bm[uú]sico\b|\bm[uú]sica\b|\bdupla\b|\bdj\b|\bservi[cç]o[s]? art[ií]stico|\bapresenta[cç][aã]o musical\b') THEN 'Artistas, bandas e músicos'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'\bshow\b|\bshows\b|\bespet[aá]culo\b|\bfestival\b|\bprodu[cç][aã]o de evento\b|\borganiza[cç][aã]o de evento\b|\brealiza[cç][aã]o de evento\b|\bevento cultural\b|\bevento festivo\b') THEN 'Shows, festivais e produção de eventos'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'\bpalco\b|\bsonoriza[cç][aã]o\b|\bsom para (evento|festa|show)\b|\bilumina[cç][aã]o c[eé]nica\b|\btenda[s]?\b|\btoldos?\b|\btrio el[eé]trico\b|\bbanheiro[s]? qu[ií]mico[s]?\b|\bgerador para (evento|festa|show)\b|\bestrutura (para|de) (evento|festa|show)\b|\bloc[aç][aã]o de estrutura') THEN 'Estrutura e apoio para eventos'
      ELSE NULL
    END AS categoria
  FROM `basedosdados.br_mgi_pncp.contratacao` c
  JOIN `basedosdados.br_bd_diretorios_brasil.municipio` m ON c.id_municipio = m.id_municipio
  WHERE c.ano BETWEEN 2021 AND 2026 AND m.sigla_uf = 'BA'
), pop AS (
  SELECT id_municipio, populacao FROM `basedosdados.br_ibge_populacao.municipio` WHERE ano = 2025 AND sigla_uf = 'BA'
), f AS (SELECT * FROM base WHERE categoria IS NOT NULL),
resumo AS (
  SELECT 'total' tipo, '2021-2026' dimensao, CAST(NULL AS STRING) municipio, CAST(NULL AS STRING) id_municipio, CAST(NULL AS INT64) populacao_2025, CAST(NULL AS STRING) categoria, COUNT(*) quantidade, COUNTIF(valor_total_homologado IS NOT NULL) qtd_com_homologado, SUM(valor_total_homologado) valor_homologado, SUM(valor_total_estimado) valor_estimado, CAST(NULL AS FLOAT64) valor_por_habitante, CAST(NULL AS STRING) id_contratacao_pncp, CAST(NULL AS DATE) data_publicacao, CAST(NULL AS STRING) nome_orgao, CAST(NULL AS STRING) objeto_compra, CAST(NULL AS STRING) link_sistema_origem FROM f
  UNION ALL SELECT 'ano', CAST(ano AS STRING), CAST(NULL AS STRING), CAST(NULL AS STRING), CAST(NULL AS INT64), categoria, COUNT(*), COUNTIF(valor_total_homologado IS NOT NULL), SUM(valor_total_homologado), SUM(valor_total_estimado), CAST(NULL AS FLOAT64), CAST(NULL AS STRING), CAST(NULL AS DATE), CAST(NULL AS STRING), CAST(NULL AS STRING), CAST(NULL AS STRING) FROM f GROUP BY ano, categoria
  UNION ALL SELECT 'categoria', categoria, CAST(NULL AS STRING), CAST(NULL AS STRING), CAST(NULL AS INT64), categoria, COUNT(*), COUNTIF(valor_total_homologado IS NOT NULL), SUM(valor_total_homologado), SUM(valor_total_estimado), CAST(NULL AS FLOAT64), CAST(NULL AS STRING), CAST(NULL AS DATE), CAST(NULL AS STRING), CAST(NULL AS STRING), CAST(NULL AS STRING) FROM f GROUP BY categoria
), mun AS (
  SELECT 'municipio_total' tipo, municipio dimensao, municipio, id_municipio, ANY_VALUE(p.populacao), CAST(NULL AS STRING), COUNT(*), COUNTIF(valor_total_homologado IS NOT NULL), SUM(valor_total_homologado), SUM(valor_total_estimado), CAST(NULL AS FLOAT64), CAST(NULL AS STRING), CAST(NULL AS DATE), CAST(NULL AS STRING), CAST(NULL AS STRING), CAST(NULL AS STRING)
  FROM f LEFT JOIN pop p USING(id_municipio) GROUP BY municipio,id_municipio
), mun25 AS (
  SELECT 'municipio_2025' tipo, municipio dimensao, municipio, id_municipio, ANY_VALUE(p.populacao), CAST(NULL AS STRING), COUNT(*), COUNTIF(valor_total_homologado IS NOT NULL), SUM(valor_total_homologado), SUM(valor_total_estimado), SAFE_DIVIDE(SUM(valor_total_homologado), ANY_VALUE(p.populacao)), CAST(NULL AS STRING), CAST(NULL AS DATE), CAST(NULL AS STRING), CAST(NULL AS STRING), CAST(NULL AS STRING)
  FROM f LEFT JOIN pop p USING(id_municipio) WHERE ano=2025 GROUP BY municipio,id_municipio
), ex AS (
  SELECT 'exemplo' tipo, id_contratacao_pncp dimensao, municipio, id_municipio, CAST(NULL AS INT64), categoria, 1, IF(valor_total_homologado IS NULL,0,1), valor_total_homologado, valor_total_estimado, CAST(NULL AS FLOAT64), id_contratacao_pncp, data_publicacao, nome_orgao, objeto_compra, link_sistema_origem
  FROM f QUALIFY ROW_NUMBER() OVER(ORDER BY valor_total_homologado DESC NULLS LAST, data_publicacao DESC) <= 20
)
SELECT * FROM resumo
UNION ALL SELECT * FROM (SELECT * FROM mun QUALIFY ROW_NUMBER() OVER(ORDER BY valor_homologado DESC NULLS LAST) <= 20)
UNION ALL SELECT * FROM (SELECT * FROM mun25 QUALIFY ROW_NUMBER() OVER(ORDER BY valor_homologado DESC NULLS LAST) <= 20)
UNION ALL SELECT * FROM ex
ORDER BY tipo, valor_homologado DESC NULLS LAST