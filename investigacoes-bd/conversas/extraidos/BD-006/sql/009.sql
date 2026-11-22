WITH p AS (SELECT id_municipio, bioma, ano FROM `basedosdados.br_inpe_prodes.municipio_bioma` WHERE ano=2023), m AS (SELECT id_municipio, bioma, ano FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe` WHERE ano=2023), pk AS (SELECT id_municipio,bioma,ano,COUNT(*) n FROM p GROUP BY 1,2,3), mk AS (SELECT id_municipio,bioma,ano,COUNT(*) n FROM m GROUP BY 1,2,3), matched AS (SELECT p.* FROM pk p JOIN mk m USING(id_municipio,bioma,ano)), unmatched AS (SELECT p.* FROM pk p LEFT JOIN mk m USING(id_municipio,bioma,ano) WHERE m.id_municipio IS NULL), metrics AS (
SELECT 'prodes_registros' item, CAST(COUNT(*) AS STRING) valor FROM p
UNION ALL SELECT 'prodes_chaves_distintas', CAST(COUNT(*) AS STRING) FROM pk
UNION ALL SELECT 'mapbiomas_registros', CAST(COUNT(*) AS STRING) FROM m
UNION ALL SELECT 'mapbiomas_chaves_distintas', CAST(COUNT(*) AS STRING) FROM mk
UNION ALL SELECT 'prodes_chaves_duplicadas', CAST(COUNTIF(n>1) AS STRING) FROM pk
UNION ALL SELECT 'mapbiomas_chaves_duplicadas', CAST(COUNTIF(n>1) AS STRING) FROM mk
UNION ALL SELECT 'prodes_chaves_com_mapbiomas', CAST(COUNT(*) AS STRING) FROM matched
UNION ALL SELECT 'prodes_chaves_sem_mapbiomas', CAST(COUNT(*) AS STRING) FROM unmatched
UNION ALL SELECT 'proporcao_prodes_com_mapbiomas', CAST(SAFE_DIVIDE((SELECT COUNT(*) FROM matched),(SELECT COUNT(*) FROM pk)) AS STRING)
UNION ALL SELECT 'proporcao_prodes_sem_mapbiomas', CAST(SAFE_DIVIDE((SELECT COUNT(*) FROM unmatched),(SELECT COUNT(*) FROM pk)) AS STRING))
SELECT 1 ordem,'metrica' tipo,item,valor,CAST(NULL AS STRING) id_1,CAST(NULL AS STRING) id_2 FROM metrics
UNION ALL SELECT 2,'exemplo_correspondente','chave',CAST(ano AS STRING),id_municipio,bioma FROM matched QUALIFY ROW_NUMBER() OVER(ORDER BY id_municipio,bioma)<=5
UNION ALL SELECT 3,'exemplo_sem_correspondencia','chave',CAST(ano AS STRING),id_municipio,bioma FROM unmatched QUALIFY ROW_NUMBER() OVER(ORDER BY id_municipio,bioma)<=5
ORDER BY ordem,item,id_1