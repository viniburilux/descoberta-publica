-- 06_estrutura | sicor_car | checagem estrutural da chave normalizada
SELECT
  LENGTH(REPLACE(UPPER(TRIM(id_car)), '-', '')) AS comprimento,
  COUNTIF(REGEXP_CONTAINS(REPLACE(UPPER(TRIM(id_car)), '-', ''), r'^[A-Za-z]{2}[0-9]{7}[A-Fa-f0-9]{32}$')) AS formato_valido,
  COUNT(*) AS registros,
  SUBSTR(REPLACE(UPPER(TRIM(id_car)), '-', ''), 1, 2) AS uf_prefixo,
  SUBSTR(REPLACE(UPPER(TRIM(id_car)), '-', ''), 3, 7) AS municipio_embutido
FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
WHERE ano_emissao IN (2019, 2023, 2026)
GROUP BY comprimento, uf_prefixo, municipio_embutido
ORDER BY registros DESC;