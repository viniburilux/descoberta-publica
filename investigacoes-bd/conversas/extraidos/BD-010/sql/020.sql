SELECT id_imovel, data_extracao, condicao, tipo
FROM `basedosdados.br_sfb_sicar.app`
WHERE data_extracao = '2026-08-03'
  AND REPLACE(id_imovel, '-', '') = 'PA15061873F4B7241FA0D4F60B91CCE115953FD56'