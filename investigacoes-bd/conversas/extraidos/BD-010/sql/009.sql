SELECT
  id_tabela,
  nome_coluna,
  valor
FROM `basedosdados.br_sfb_sicar.dicionario`
WHERE nome_coluna IN ('data_criacao', 'data_atualizacao')
ORDER BY id_tabela, nome_coluna, valor