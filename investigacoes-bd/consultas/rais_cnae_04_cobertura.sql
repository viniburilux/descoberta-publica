-- 04_cobertura | rais_cnae | transformacao adotada: literal
WITH l AS (
  SELECT ano, cnae_2_subclasse AS __k
  FROM `basedosdados.br_me_rais.microdados_estabelecimentos`
  WHERE ano IN (2023)
  AND cnae_2_subclasse IS NOT NULL AND TRIM(CAST(cnae_2_subclasse AS STRING)) != ''
), r AS (
  SELECT DISTINCT subclasse AS __k
  FROM `basedosdados.br_bd_diretorios_brasil.cnae_2`
  
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

