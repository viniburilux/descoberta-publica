WITH p AS (
  SELECT id_municipio, bioma, ano
  FROM `basedosdados.br_inpe_prodes.municipio_bioma`
  WHERE ano = 2023
), m AS (
  SELECT id_municipio, sigla_uf, bioma, ano, id_classe, area
  FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe`
  WHERE ano = 2023
), pk AS (
  SELECT id_municipio, bioma, ano, COUNT(*) AS n
  FROM p GROUP BY id_municipio, bioma, ano
), mk AS (
  SELECT id_municipio, bioma, ano, COUNT(*) AS n
  FROM m GROUP BY id_municipio, bioma, ano
), matched AS (
  SELECT p.id_municipio, p.bioma, p.ano
  FROM pk p INNER JOIN mk m USING (id_municipio, bioma, ano)
), unmatched AS (
  SELECT p.id_municipio, p.bioma, p.ano
  FROM pk p LEFT JOIN mk m USING (id_municipio, bioma, ano)
  WHERE m.id_municipio IS NULL
), metrics AS (
  SELECT 'prodes_registros' AS metrica, CAST(COUNT(*) AS STRING) AS valor FROM p
  UNION ALL SELECT 'prodes_chaves_distintas', CAST(COUNT(*) AS STRING) FROM pk
  UNION ALL SELECT 'mapbiomas_registros', CAST(COUNT(*) AS STRING) FROM m
  UNION ALL SELECT 'mapbiomas_chaves_distintas', CAST(COUNT(*) AS STRING) FROM mk
  UNION ALL SELECT 'prodes_chaves_nulas', CAST(COUNTIF(id_municipio IS NULL OR bioma IS NULL OR ano IS NULL) AS STRING) FROM pk
  UNION ALL SELECT 'mapbiomas_chaves_nulas', CAST(COUNTIF(id_municipio IS NULL OR bioma IS NULL OR ano IS NULL) AS STRING) FROM mk
  UNION ALL SELECT 'prodes_chaves_duplicadas', CAST(COUNTIF(n > 1) AS STRING) FROM pk
  UNION ALL SELECT 'mapbiomas_chaves_duplicadas', CAST(COUNTIF(n > 1) AS STRING) FROM mk
  UNION ALL SELECT 'prodes_chaves_com_mapbiomas', CAST(COUNT(*) AS STRING) FROM matched
  UNION ALL SELECT 'prodes_chaves_sem_mapbiomas', CAST(COUNT(*) AS STRING) FROM unmatched
  UNION ALL SELECT 'prodes_cobertura_com_mapbiomas', CAST(SAFE_DIVIDE(COUNT(*), (SELECT COUNT(*) FROM pk)) AS STRING) FROM matched
  UNION ALL SELECT 'prodes_cobertura_sem_mapbiomas', CAST(SAFE_DIVIDE(COUNT(*), (SELECT COUNT(*) FROM pk)) AS STRING) FROM unmatched
)
SELECT 'metrica' AS tipo, metrica AS item, valor, CAST(NULL AS STRING) AS id_municipio, CAST(NULL AS STRING) AS bioma
FROM metrics
UNION ALL
SELECT 'exemplo_correspondente', 'chave', CAST(ano AS STRING), id_municipio, bioma
FROM matched
UNION ALL
SELECT 'exemplo_sem_correspondencia', 'chave', CAST(ano AS STRING), id_municipio, bioma
FROM unmatched
ORDER BY tipo, item, id_municipio
LIMIT 60