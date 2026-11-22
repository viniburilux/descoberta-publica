-- 03_transformacoes | prodes_mapbiomas
SELECT 'literal' AS transformacao,
  COUNT(*) AS registros_left,
  COUNTIF(r.__k IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.__k IS NOT NULL, l.__k, NULL)) AS ids_correspondentes
FROM (SELECT CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) AS __k FROM `basedosdados.br_inpe_prodes.municipio_bioma` WHERE ano IN (2023)) l
LEFT JOIN (SELECT DISTINCT CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) AS __k FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe` WHERE ano IN (2023)) r
USING (__k);
