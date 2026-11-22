WITH vencedores AS (
  SELECT DISTINCT r.id_municipio, r.sequencial_candidato
  FROM `basedosdados.br_tse_eleicoes.resultados_candidato` r
  INNER JOIN `basedosdados.br_bd_diretorios_brasil.municipio` m USING (id_municipio)
  WHERE r.ano = 2020
    AND r.tipo_eleicao = 'eleicao ordinaria'
    AND r.cargo = 'prefeito'
    AND r.resultado = 'eleito'
    AND m.capital_uf = 1
),
receitas AS (
  SELECT DISTINCT
    x.cpf_cnpj_doador,
    x.nome_doador,
    x.sequencial_candidato,
    x.id_municipio,
    x.valor_receita
  FROM `basedosdados.br_tse_eleicoes.receitas_candidato` x
  INNER JOIN vencedores v
    ON x.id_municipio = v.id_municipio
   AND x.sequencial_candidato = v.sequencial_candidato
  WHERE x.ano = 2020
)
SELECT
  COUNT(*) AS linhas_receita,
  COUNT(DISTINCT cpf_cnpj_doador) AS doadores_distintos,
  COUNT(DISTINCT IF(REGEXP_CONTAINS(cpf_cnpj_doador, r'^[0-9]{14}$'), cpf_cnpj_doador, NULL)) AS cnpjs_doadores_distintos,
  COUNT(DISTINCT IF(REGEXP_CONTAINS(cpf_cnpj_doador, r'^[0-9]{11}$'), cpf_cnpj_doador, NULL)) AS cpfs_doadores_distintos,
  SUM(valor_receita) AS valor_total_receitas
FROM receitas