-- 04_cobertura | ibama_autos_embargos | transformacao adotada: literal
WITH l AS (
  SELECT ano, id_auto AS __k
  FROM `basedosdados.br_ibama_fiscalizacao.auto_infracao`
  WHERE ano >= 1977
  AND id_auto IS NOT NULL AND TRIM(CAST(id_auto AS STRING)) != ''
), r AS (
  SELECT DISTINCT id_auto AS __k
  FROM `basedosdados.br_ibama_fiscalizacao.area_embargada`
  
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
