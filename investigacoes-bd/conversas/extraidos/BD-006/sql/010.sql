WITH r AS (SELECT id_municipio,sigla_uf,cnae_2_subclasse FROM `basedosdados.br_me_rais.microdados_estabelecimentos` WHERE ano=2023), c AS (SELECT subclasse FROM `basedosdados.br_bd_diretorios_brasil.cnae_2`), rk AS (SELECT cnae_2_subclasse,COUNT(*) n FROM r WHERE cnae_2_subclasse IS NOT NULL GROUP BY 1), ck AS (SELECT subclasse,COUNT(*) n FROM c WHERE subclasse IS NOT NULL GROUP BY 1), matched AS (SELECT rk.* FROM rk JOIN ck ON rk.cnae_2_subclasse=ck.subclasse), unmatched AS (SELECT rk.* FROM rk LEFT JOIN ck ON rk.cnae_2_subclasse=ck.subclasse WHERE ck.subclasse IS NULL), metrics AS (
SELECT 'rais_registros' item,CAST(COUNT(*) AS STRING) valor FROM r
UNION ALL SELECT 'rais_cnae_nulo',CAST(COUNTIF(cnae_2_subclasse IS NULL) AS STRING) FROM r
UNION ALL SELECT 'rais_subclasses_distintas',CAST(COUNT(*) AS STRING) FROM rk
UNION ALL SELECT 'diretorio_registros',CAST(COUNT(*) AS STRING) FROM c
UNION ALL SELECT 'diretorio_subclasses_distintas',CAST(COUNT(*) AS STRING) FROM ck
UNION ALL SELECT 'rais_subclasses_duplicadas',CAST(COUNTIF(n>1) AS STRING) FROM rk
UNION ALL SELECT 'diretorio_subclasses_duplicadas',CAST(COUNTIF(n>1) AS STRING) FROM ck
UNION ALL SELECT 'rais_subclasses_com_diretorio',CAST(COUNT(*) AS STRING) FROM matched
UNION ALL SELECT 'rais_subclasses_sem_diretorio',CAST(COUNT(*) AS STRING) FROM unmatched
UNION ALL SELECT 'proporcao_subclasses_com_diretorio',CAST(SAFE_DIVIDE((SELECT COUNT(*) FROM matched),(SELECT COUNT(*) FROM rk)) AS STRING)
UNION ALL SELECT 'rais_registros_com_cnae',CAST((SELECT COUNT(*) FROM r JOIN ck ON r.cnae_2_subclasse=ck.subclasse) AS STRING)
UNION ALL SELECT 'rais_registros_sem_cnae',CAST((SELECT COUNT(*) FROM r LEFT JOIN ck ON r.cnae_2_subclasse=ck.subclasse WHERE ck.subclasse IS NULL) AS STRING))
SELECT 1 ordem,'metrica' tipo,item,valor,CAST(NULL AS STRING) id_1,CAST(NULL AS STRING) id_2 FROM metrics
UNION ALL SELECT 2,'exemplo_correspondente','subclasse',CAST(n AS STRING),cnae_2_subclasse,'presente' FROM matched QUALIFY ROW_NUMBER() OVER(ORDER BY cnae_2_subclasse)<=5
UNION ALL SELECT 3,'exemplo_sem_correspondencia','subclasse',CAST(n AS STRING),cnae_2_subclasse,'ausente' FROM unmatched QUALIFY ROW_NUMBER() OVER(ORDER BY cnae_2_subclasse)<=5
ORDER BY ordem,item,id_1