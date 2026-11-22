WITH base AS (
  SELECT c.ano, c.id_contratacao_pncp, c.id_municipio, m.nome AS municipio, c.data_publicacao, c.nome_orgao, c.objeto_compra, c.valor_total_estimado, c.valor_total_homologado, c.link_sistema_origem,
    CASE
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'carnaval|s[aã]o jo[aã]o|festa junina|festividade|festejo|comemora[cç][aã]o|arrai[aá]|r[eé]veillon') THEN 'Festividades específicas'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'artista|cantor|cantora|banda|m[uú]sic[oa]|dupla|\bdj\b|servi[cç]o[s]? art[ií]stic|apresenta[cç][aã]o musical') THEN 'Artistas, bandas e atrações musicais'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'\bshow[s]?\b|espet[aá]culo|festival|programa[cç][aã]o cultural|evento cultural|evento festivo|produ[cç][aã]o de evento|organiza[cç][aã]o de evento|realiza[cç][aã]o de evento') THEN 'Shows, festivais e eventos'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'palco|sonoriza[cç][aã]o|ilumina[cç][aã]o|tenda|toldos?|estrutura para evento|estrutura de evento|loca[cç][aã]o de estrutura|trio el[eé]trico|gerador|banheiro[s]? qu[ií]mico') THEN 'Estrutura e apoio a eventos'
      ELSE NULL
    END AS categoria
  FROM `basedosdados.br_mgi_pncp.contratacao` c
  JOIN `basedosdados.br_bd_diretorios_brasil.municipio` m ON c.id_municipio = m.id_municipio
  WHERE c.ano BETWEEN 2021 AND 2026 AND m.sigla_uf = 'BA'
), pop_2025 AS (
  SELECT id_municipio, populacao FROM `basedosdados.br_ibge_populacao.municipio` WHERE ano = 2025 AND sigla_uf = 'BA'
), filtrada AS (SELECT * FROM base WHERE categoria IS NOT NULL),
anual AS (
  SELECT 'distribuicao_anual' tipo, CAST(ano AS STRING) dimensao, CAST(NULL AS STRING) municipio, CAST(NULL AS STRING) id_municipio, CAST(NULL AS INT64) populacao_2025, categoria, COUNT(*) quantidade, COUNTIF(valor_total_homologado IS NOT NULL) qtd_com_homologado, SUM(valor_total_homologado) valor_homologado, SUM(valor_total_estimado) valor_estimado, CAST(NULL AS FLOAT64) valor_por_habitante_2025, CAST(NULL AS STRING) id_contratacao_pncp, CAST(NULL AS DATE) data_publicacao, CAST(NULL AS STRING) nome_orgao, CAST(NULL AS STRING) objeto_compra, CAST(NULL AS STRING) link_sistema_origem
  FROM filtrada GROUP BY ano, categoria
), categorias AS (
  SELECT 'categoria' tipo, categoria dimensao, CAST(NULL AS STRING) municipio, CAST(NULL AS STRING) id_municipio, CAST(NULL AS INT64) populacao_2025, categoria, COUNT(*) quantidade, COUNTIF(valor_total_homologado IS NOT NULL) qtd_com_homologado, SUM(valor_total_homologado) valor_homologado, SUM(valor_total_estimado) valor_estimado, CAST(NULL AS FLOAT64) valor_por_habitante_2025, CAST(NULL AS STRING) id_contratacao_pncp, CAST(NULL AS DATE) data_publicacao, CAST(NULL AS STRING) nome_orgao, CAST(NULL AS STRING) objeto_compra, CAST(NULL AS STRING) link_sistema_origem
  FROM filtrada GROUP BY categoria
), municipios AS (
  SELECT 'municipio_total' tipo, CAST(ROW_NUMBER() OVER (ORDER BY SUM(valor_total_homologado) DESC NULLS LAST) AS STRING) dimensao, municipio, id_municipio, ANY_VALUE(p.populacao) populacao_2025, CAST(NULL AS STRING) categoria, COUNT(*) quantidade, COUNTIF(valor_total_homologado IS NOT NULL) qtd_com_homologado, SUM(valor_total_homologado) valor_homologado, SUM(valor_total_estimado) valor_estimado, CAST(NULL AS FLOAT64) valor_por_habitante_2025, CAST(NULL AS STRING) id_contratacao_pncp, CAST(NULL AS DATE) data_publicacao, CAST(NULL AS STRING) nome_orgao, CAST(NULL AS STRING) objeto_compra, CAST(NULL AS STRING) link_sistema_origem
  FROM filtrada f LEFT JOIN pop_2025 p USING (id_municipio) GROUP BY municipio, id_municipio QUALIFY ROW_NUMBER() OVER (ORDER BY SUM(valor_total_homologado) DESC NULLS LAST) <= 20
), municipios_2025 AS (
  SELECT 'municipio_2025' tipo, CAST(ROW_NUMBER() OVER (ORDER BY SUM(valor_total_homologado) DESC NULLS LAST) AS STRING) dimensao, municipio, id_municipio, ANY_VALUE(p.populacao) populacao_2025, CAST(NULL AS STRING) categoria, COUNT(*) quantidade, COUNTIF(valor_total_homologado IS NOT NULL) qtd_com_homologado, SUM(valor_total_homologado) valor_homologado, SUM(valor_total_estimado) valor_estimado, SAFE_DIVIDE(SUM(valor_total_homologado), ANY_VALUE(p.populacao)) valor_por_habitante_2025, CAST(NULL AS STRING) id_contratacao_pncp, CAST(NULL AS DATE) data_publicacao, CAST(NULL AS STRING) nome_orgao, CAST(NULL AS STRING) objeto_compra, CAST(NULL AS STRING) link_sistema_origem
  FROM filtrada f LEFT JOIN pop_2025 p USING (id_municipio) WHERE ano = 2025 GROUP BY municipio, id_municipio QUALIFY ROW_NUMBER() OVER (ORDER BY SUM(valor_total_homologado) DESC NULLS LAST) <= 20
), exemplos AS (
  SELECT 'exemplo' tipo, CAST(ROW_NUMBER() OVER (ORDER BY valor_total_homologado DESC NULLS LAST, data_publicacao DESC) AS STRING) dimensao, municipio, id_municipio, CAST(NULL AS INT64) populacao_2025, categoria, 1 quantidade, IF(valor_total_homologado IS NOT NULL, 1, 0) qtd_com_homologado, valor_total_homologado valor_homologado, valor_total_estimado valor_estimado, CAST(NULL AS FLOAT64) valor_por_habitante_2025, id_contratacao_pncp, data_publicacao, nome_orgao, objeto_compra, link_sistema_origem
  FROM filtrada QUALIFY ROW_NUMBER() OVER (ORDER BY valor_total_homologado DESC NULLS LAST, data_publicacao DESC) <= 15
)
SELECT * FROM anual UNION ALL SELECT * FROM categorias UNION ALL SELECT * FROM municipios UNION ALL SELECT * FROM municipios_2025 UNION ALL SELECT * FROM exemplos
ORDER BY tipo, SAFE_CAST(dimensao AS INT64), dimensao