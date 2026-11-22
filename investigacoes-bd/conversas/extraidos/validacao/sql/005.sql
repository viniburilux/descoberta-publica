SELECT data_extracao, COUNT(*) AS registros
FROM `basedosdados.br_sfb_sicar.area_imovel`
GROUP BY data_extracao
ORDER BY data_extracao;