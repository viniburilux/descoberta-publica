-- 03_transformacoes | ibama_autos_embargos
SELECT 'literal' AS transformacao,
  COUNT(*) AS registros_left,
  COUNTIF(r.__k IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.__k IS NOT NULL, l.__k, NULL)) AS ids_correspondentes
FROM (SELECT id_auto AS __k FROM `basedosdados.br_ibama_fiscalizacao.auto_infracao` WHERE ano >= 1977) l
LEFT JOIN (SELECT DISTINCT id_auto AS __k FROM `basedosdados.br_ibama_fiscalizacao.area_embargada` ) r
USING (__k);