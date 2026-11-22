-- 04_cobertura | sicor_car | transformacao adotada: normalizado
WITH l AS (
  SELECT ano_emissao, REPLACE(UPPER(TRIM(id_car)), '-', '') AS __k
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao IN (2019, 2023, 2026)
  AND id_car IS NOT NULL AND TRIM(CAST(id_car AS STRING)) != ''
), r AS (
  SELECT DISTINCT REPLACE(UPPER(TRIM(id_imovel)), '-', '') AS __k
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  
)
SELECT
  l.ano_emissao,
  COUNT(*) AS registros_left,
  COUNT(DISTINCT l.__k) AS ids_distintos_left,
  COUNTIF(r.__k IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.__k IS NOT NULL, l.__k, NULL)) AS ids_correspondentes,
  COUNTIF(r.__k IS NULL) AS registros_sem_correspondencia
FROM l LEFT JOIN r USING (__k)
GROUP BY l.ano_emissao ORDER BY l.ano_emissao;

