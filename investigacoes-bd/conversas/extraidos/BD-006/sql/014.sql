WITH car AS (SELECT id_imovel,id_municipio,sigla_uf FROM `basedosdados.br_sfb_sicar.area_imovel` WHERE data_extracao='2026-08-04'), s AS (SELECT id_car,id_referencia_bacen,numero_ordem FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade` WHERE ano_emissao=2026), ck AS (SELECT id_imovel,COUNT(*) n FROM car WHERE id_imovel IS NOT NULL GROUP BY 1), sk AS (SELECT id_car,COUNT(*) n FROM s WHERE id_car IS NOT NULL GROUP BY 1), matched AS (SELECT s.id_car,s.id_referencia_bacen,s.numero_ordem,c.id_municipio,c.sigla_uf FROM s JOIN car c ON s.id_car=c.id_imovel), unmatched AS (SELECT s.id_car,s.id_referencia_bacen,s.numero_ordem FROM s LEFT JOIN car c ON s.id_car=c.id_imovel WHERE c.id_imovel IS NULL), metrics AS (
SELECT 'car_registros_snapshot' item,CAST(COUNT(*) AS STRING) valor FROM car
UNION ALL SELECT 'sicor_registros_2026',CAST(COUNT(*) AS STRING) FROM s
UNION ALL SELECT 'car_id_nulo',CAST(COUNTIF(id_imovel IS NULL) AS STRING) FROM car
UNION ALL SELECT 'sicor_id_car_nulo',CAST(COUNTIF(id_car IS NULL) AS STRING) FROM s
UNION ALL SELECT 'car_ids_distintos',CAST(COUNT(*) AS STRING) FROM ck
UNION ALL SELECT 'sicor_ids_distintos',CAST(COUNT(*) AS STRING) FROM sk
UNION ALL SELECT 'car_ids_duplicados',CAST(COUNTIF(n>1) AS STRING) FROM ck
UNION ALL SELECT 'sicor_ids_duplicados',CAST(COUNTIF(n>1) AS STRING) FROM sk
UNION ALL SELECT 'sicor_registros_com_car',CAST(COUNT(*) AS STRING) FROM matched
UNION ALL SELECT 'sicor_registros_sem_car',CAST(COUNT(*) AS STRING) FROM unmatched
UNION ALL SELECT 'proporcao_sicor_com_car',CAST(SAFE_DIVIDE((SELECT COUNT(*) FROM matched),(SELECT COUNT(*) FROM s)) AS STRING)
UNION ALL SELECT 'proporcao_sicor_sem_car',CAST(SAFE_DIVIDE((SELECT COUNT(*) FROM unmatched),(SELECT COUNT(*) FROM s)) AS STRING))
SELECT 1 ordem,'metrica' tipo,item,valor,CAST(NULL AS STRING) id_1,CAST(NULL AS STRING) id_2 FROM metrics
UNION ALL SELECT 2,'exemplo_correspondente','id_car_id_imovel',CAST(NULL AS STRING),id_car,id_referencia_bacen FROM matched QUALIFY ROW_NUMBER() OVER(ORDER BY id_car)<=5
UNION ALL SELECT 3,'exemplo_sem_correspondencia','id_car_sem_imovel',CAST(NULL AS STRING),id_car,id_referencia_bacen FROM unmatched WHERE id_car IS NOT NULL QUALIFY ROW_NUMBER() OVER(ORDER BY id_car)<=5
ORDER BY ordem,item,id_1