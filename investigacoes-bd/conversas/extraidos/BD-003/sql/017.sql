SELECT tipo_doador_orig, natureza_receita, COUNT(*) AS n, SUM(valor_receita) AS valor
FROM `basedosdados.br_tse_eleicoes.receitas_candidato`
WHERE ano = 2020
  AND id_municipio IN (SELECT id_municipio FROM `basedosdados.br_bd_diretorios_brasil.municipio` WHERE capital_uf = 1)
GROUP BY tipo_doador_orig, natureza_receita
ORDER BY n DESC
LIMIT 30