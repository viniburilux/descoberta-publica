SELECT cargo, tipo_eleicao, situacao, COUNT(*) AS n
FROM `basedosdados.br_tse_eleicoes.candidatos`
WHERE ano = 2020
GROUP BY cargo, tipo_eleicao, situacao
ORDER BY n DESC
LIMIT 30