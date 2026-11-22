SELECT
  COUNT(*) AS total,
  COUNTIF(REGEXP_CONTAINS(cpf_cnpj_doador, r'^[0-9]{11}$')) AS cpf_11_digitos,
  COUNTIF(REGEXP_CONTAINS(cpf_cnpj_doador, r'^[0-9]{14}$')) AS cnpj_14_digitos,
  COUNTIF(cpf_cnpj_doador IS NULL) AS nulos
FROM `basedosdados.br_tse_eleicoes.receitas_candidato`
WHERE ano = 2020