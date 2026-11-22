-- 03_transformacoes | rais_cnae
SELECT 'literal' AS transformacao,
  COUNT(*) AS registros_left,
  COUNTIF(r.__k IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.__k IS NOT NULL, l.__k, NULL)) AS ids_correspondentes
FROM (SELECT cnae_2_subclasse AS __k FROM `basedosdados.br_me_rais.microdados_estabelecimentos` WHERE ano IN (2023)) l
LEFT JOIN (SELECT DISTINCT subclasse AS __k FROM `basedosdados.br_bd_diretorios_brasil.cnae_2` ) r
USING (__k);