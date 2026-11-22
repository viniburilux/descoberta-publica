SELECT
  data_extracao,
  sigla_uf,
  COUNT(*) AS registros,
  COUNT(DISTINCT id_imovel) AS imoveis_distintos
FROM `basedosdados.br_sfb_sicar.area_imovel`
WHERE data_extracao IS NOT NULL
GROUP BY data_extracao, sigla_uf
ORDER BY data_extracao, sigla_uf