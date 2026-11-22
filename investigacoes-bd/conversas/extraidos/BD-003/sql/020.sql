SELECT
  COUNT(*) AS receitas,
  COUNTIF(cpf_cnpj_doador IS NOT NULL) AS doadores_preenchidos,
  COUNTIF(REGEXP_CONTAINS(cpf_cnpj_doador, r'^[0-9]{11}$')) AS cpfs_11_digitos,
  COUNTIF(REGEXP_CONTAINS(cpf_cnpj_doador, r'^[0-9]{14}$')) AS cnpjs_14_digitos,
  SUM(valor_receita) AS valor
FROM `basedosdados.br_tse_eleicoes.receitas_candidato`
WHERE ano = 2020
  AND id_municipio IN (SELECT id_municipio FROM `basedosdados.br_bd_diretorios_brasil.municipio` WHERE capital_uf = 1)
  AND cargo = 'prefeito'