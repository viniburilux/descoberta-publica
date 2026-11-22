SELECT
  ano_emissao,
  SUBSTR(UPPER(REPLACE(TRIM(id_car), '-', '')), 1, 2) AS uf_prefixo,
  COUNT(*) AS registros,
  COUNT(DISTINCT REPLACE(UPPER(TRIM(id_car)), '-', '')) AS ids_distintos
FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
WHERE ano_emissao BETWEEN 2019 AND 2026
  AND id_car IS NOT NULL
  AND TRIM(id_car) != ''
GROUP BY ano_emissao, uf_prefixo
ORDER BY ano_emissao, uf_prefixo