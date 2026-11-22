SELECT resultado, COUNT(*) AS n
FROM `basedosdados.br_tse_eleicoes.resultados_candidato`
WHERE ano = 2020 AND cargo = 'prefeito' AND tipo_eleicao = 'eleicao ordinaria'
GROUP BY resultado ORDER BY n DESC