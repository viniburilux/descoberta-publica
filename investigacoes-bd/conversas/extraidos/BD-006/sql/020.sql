SELECT
  ano_emissao,
  COUNT(*) AS registros,
  COUNTIF(id_car IS NOT NULL AND TRIM(id_car) != '') AS id_car_preenchido,
  COUNTIF(id_car IS NULL OR TRIM(id_car) = '') AS id_car_vazio,
  COUNT(DISTINCT NULLIF(TRIM(id_car), '')) AS ids_car_distintos
FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
WHERE ano_emissao BETWEEN 2013 AND 2026
GROUP BY ano_emissao
ORDER BY ano_emissao