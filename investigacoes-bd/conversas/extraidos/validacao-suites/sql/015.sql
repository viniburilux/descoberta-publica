-- 02_duplicidade | prodes_mapbiomas
WITH l AS (
  SELECT COUNT(*) AS registros, COUNT(DISTINCT CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING))) AS chaves_distintas
  FROM `basedosdados.br_inpe_prodes.municipio_bioma` WHERE ano IN (2023)
), r AS (
  SELECT COUNT(*) AS registros, COUNT(DISTINCT CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING))) AS chaves_distintas
  FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe` WHERE ano IN (2023)
)
SELECT 'left' AS lado, registros, chaves_distintas,
       registros - chaves_distintas AS chaves_repetidas FROM l
UNION ALL
SELECT 'right', registros, chaves_distintas,
       registros - chaves_distintas FROM r;