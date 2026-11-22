SELECT
  data_extracao,
  COUNT(*) AS registros,
  COUNT(DISTINCT id_imovel) AS imoveis_distintos,
  COUNT(DISTINCT sigla_uf) AS ufs
FROM `basedosdados.br_sfb_sicar.area_imovel`
WHERE data_extracao IS NOT NULL
GROUP BY data_extracao
ORDER BY data_extracao