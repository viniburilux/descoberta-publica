-- 04_cobertura | prodes_mapbiomas | transformacao adotada: literal
WITH l AS (
  SELECT ano, CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) AS __k
  FROM `basedosdados.br_inpe_prodes.municipio_bioma`
  WHERE ano IN (2023)
  AND CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) IS NOT NULL
), r AS (
  SELECT DISTINCT CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) AS __k
  FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe`
  WHERE ano IN (2023)
)
SELECT
  l.ano,
  COUNT(*) AS registros_left,
  COUNT(DISTINCT l.__k) AS ids_distintos_left,
  COUNTIF(r.__k IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.__k IS NOT NULL, l.__k, NULL)) AS ids_correspondentes,
  COUNTIF(r.__k IS NULL) AS registros_sem_correspondencia
FROM l LEFT JOIN r USING (__k)
GROUP BY l.ano ORDER BY l.ano;

