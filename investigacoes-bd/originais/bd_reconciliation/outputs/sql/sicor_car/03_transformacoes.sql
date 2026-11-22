-- 03_transformacoes | sicor_car
SELECT 'literal' AS transformacao,
  COUNT(*) AS registros_left,
  COUNTIF(r.__k IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.__k IS NOT NULL, l.__k, NULL)) AS ids_correspondentes
FROM (SELECT TRIM(id_car) AS __k FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade` WHERE ano_emissao IN (2019, 2023, 2026)) l
LEFT JOIN (SELECT DISTINCT TRIM(id_imovel) AS __k FROM `basedosdados.br_sfb_sicar.area_imovel` ) r
USING (__k)
UNION ALL
SELECT 'normalizado' AS transformacao,
  COUNT(*) AS registros_left,
  COUNTIF(r.__k IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.__k IS NOT NULL, l.__k, NULL)) AS ids_correspondentes
FROM (SELECT REPLACE(UPPER(TRIM(id_car)), '-', '') AS __k FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade` WHERE ano_emissao IN (2019, 2023, 2026)) l
LEFT JOIN (SELECT DISTINCT REPLACE(UPPER(TRIM(id_imovel)), '-', '') AS __k FROM `basedosdados.br_sfb_sicar.area_imovel` ) r
USING (__k);
