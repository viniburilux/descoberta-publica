SELECT
  data_referencia,
  COUNT(*) AS registros,
  COUNTIF(REGEXP_CONTAINS(documento, r'^[0-9]{11}$')) AS documentos_cpf_11,
  COUNTIF(REGEXP_CONTAINS(documento, r'^[0-9]{14}$')) AS documentos_cnpj_14,
  COUNTIF(REGEXP_CONTAINS(documento, r'\*')) AS documentos_mascarados,
  COUNTIF(REGEXP_CONTAINS(cpf_representante_legal, r'^[0-9]{11}$')) AS representantes_cpf_11,
  COUNTIF(REGEXP_CONTAINS(cpf_representante_legal, r'\*')) AS representantes_mascarados
FROM `basedosdados.br_rf_cnpj.socios`
WHERE data_referencia IN ('2021-11-01','2026-11-01')
GROUP BY data_referencia
ORDER BY data_referencia