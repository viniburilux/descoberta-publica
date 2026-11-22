SELECT
  SUM(COALESCE(valor_pago,0)) AS total_pago,
  COUNTIF(COALESCE(valor_pago,0) > 0) AS linhas_pago_positivo,
  COUNTIF(id_municipio_gasto IS NOT NULL) AS linhas_com_municipio,
  COUNT(*) AS linhas
FROM `basedosdados.br_cgu_emendas_parlamentares.microdados`
WHERE ano_emenda BETWEEN 2018 AND 2025