SELECT
  COUNT(*) AS emendas_numericas,
  COUNTIF(m.id_municipio IS NOT NULL) AS municipios_ne_joinados,
  SUM(COALESCE(e.valor_pago,0)) AS valor_pago_ne
FROM `basedosdados.br_cgu_emendas_parlamentares.microdados` e
LEFT JOIN `basedosdados.br_bd_diretorios_brasil.municipio` m
  ON e.id_municipio_gasto = m.id_municipio
 AND m.nome_regiao = 'Nordeste'
WHERE e.ano_emenda BETWEEN 2018 AND 2025
  AND REGEXP_CONTAINS(e.id_municipio_gasto, r'^[0-9]+$')