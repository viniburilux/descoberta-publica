SELECT
  ano,
  bioma,
  nivel_1,
  nivel_2,
  SUM(area) AS area_hectares
FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe`
WHERE ano IN (2017, 2020, 2025)
  AND id_municipio = '2929057'
GROUP BY ano, bioma, nivel_1, nivel_2
ORDER BY ano, bioma, nivel_1, nivel_2