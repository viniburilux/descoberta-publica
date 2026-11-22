SELECT ano, tipo_eleicao, cargo, situacao, COUNT(*) AS n
FROM `basedosdados.br_tse_eleicoes.candidatos`
WHERE ano = 2020
  AND cargo = 'Prefeito'
GROUP BY ano, tipo_eleicao, cargo, situacao
ORDER BY tipo_eleicao, situacao