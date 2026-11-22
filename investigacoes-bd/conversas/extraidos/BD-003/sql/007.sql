SELECT CAST(id_municipio_gasto AS STRING) AS id_municipio_gasto, sigla_uf_gasto, COUNT(*) AS n
FROM `basedosdados.br_cgu_emendas_parlamentares.microdados`
WHERE ano_emenda BETWEEN 2018 AND 2025
  AND id_municipio_gasto IS NOT NULL
GROUP BY 1,2
ORDER BY n DESC
LIMIT 20