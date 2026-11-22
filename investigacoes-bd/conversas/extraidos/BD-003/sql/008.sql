SELECT
  COUNTIF(REGEXP_CONTAINS(id_municipio_gasto, r'^[0-9]+$')) AS numericos,
  COUNTIF(NOT REGEXP_CONTAINS(id_municipio_gasto, r'^[0-9]+$')) AS nao_numericos,
  MIN(LENGTH(id_municipio_gasto)) AS min_tamanho,
  MAX(LENGTH(id_municipio_gasto)) AS max_tamanho
FROM `basedosdados.br_cgu_emendas_parlamentares.microdados`
WHERE ano_emenda BETWEEN 2018 AND 2025
  AND id_municipio_gasto IS NOT NULL