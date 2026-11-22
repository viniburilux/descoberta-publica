SELECT
  nome_coluna,
  valor
FROM `basedosdados.br_sfb_sicar.dicionario`
WHERE id_tabela = 'area_imovel'
  AND nome_coluna IN ('data_criacao', 'data_atualizacao')
ORDER BY nome_coluna, valor