-- 01_chaves_nulas | prodes_mapbiomas
WITH l AS (
  SELECT COUNT(*) AS registros,
         COUNTIF(CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) IS NULL OR TRIM(CAST(CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) AS STRING)) = '') AS chave_vazia
  FROM `basedosdados.br_inpe_prodes.municipio_bioma`
  WHERE ano IN (2023)
), r AS (
  SELECT COUNT(*) AS registros,
         COUNTIF(CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) IS NULL OR TRIM(CAST(CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) AS STRING)) = '') AS chave_vazia
  FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe`
  WHERE ano IN (2023)
)
SELECT 'left' AS lado, registros, chave_vazia FROM l
UNION ALL
SELECT 'right', registros, chave_vazia FROM r;
