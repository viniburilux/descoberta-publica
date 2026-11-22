-- 05_residuos | prodes_mapbiomas | amostra e contagem dos nao correspondentes
WITH l AS (
  SELECT DISTINCT CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) AS __k FROM `basedosdados.br_inpe_prodes.municipio_bioma` WHERE ano IN (2023)
), r AS (
  SELECT DISTINCT CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) AS __k FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe` WHERE ano IN (2023)
)
SELECT COUNT(*) AS ids_left_sem_correspondencia
FROM l LEFT JOIN r USING (__k)
WHERE r.__k IS NULL;