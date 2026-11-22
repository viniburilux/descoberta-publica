WITH r AS (
  SELECT id_municipio, sigla_uf, cnae_2_subclasse, ano
  FROM `basedosdados.br_me_rais.microdados_estabelecimentos`
  WHERE ano = 2023
), c AS (
  SELECT subclasse
  FROM `basedosdados.br_bd_diretorios_brasil.cnae_2`
), rk AS (
  SELECT cnae_2_subclasse, COUNT(*) AS n
  FROM r WHERE cnae_2_subclasse IS NOT NULL
  GROUP BY cnae_2_subclasse
), ck AS (
  SELECT subclasse, COUNT(*) AS n
  FROM c WHERE subclasse IS NOT NULL
  GROUP BY subclasse
), matched AS (
  SELECT rk.cnae_2_subclasse, rk.n
  FROM rk INNER JOIN ck ON rk.cnae_2_subclasse = ck.subclasse
), unmatched AS (
  SELECT rk.cnae_2_subclasse, rk.n
  FROM rk LEFT JOIN ck ON rk.cnae_2_subclasse = ck.subclasse
  WHERE ck.subclasse IS NULL
), metrics AS (
  SELECT 'rais_registros' AS metrica, CAST(COUNT(*) AS STRING) AS valor FROM r
  UNION ALL SELECT 'rais_cnae_nulo', CAST(COUNTIF(cnae_2_subclasse IS NULL) AS STRING) FROM r
  UNION ALL SELECT 'rais_cnae_distintos_nao_nulos', CAST(COUNT(*) AS STRING) FROM rk
  UNION ALL SELECT 'diretorio_cnae_registros', CAST(COUNT(*) AS STRING) FROM c
  UNION ALL SELECT 'diretorio_subclasses_distintas', CAST(COUNT(*) AS STRING) FROM ck
  UNION ALL SELECT 'diretorio_subclasses_nulas', CAST(COUNTIF(subclasse IS NULL) AS STRING) FROM c
  UNION ALL SELECT 'rais_subclasses_duplicadas', CAST(COUNTIF(n > 1) AS STRING) FROM rk
  UNION ALL SELECT 'diretorio_subclasses_duplicadas', CAST(COUNTIF(n > 1) AS STRING) FROM ck
  UNION ALL SELECT 'subclasses_rais_com_correspondencia', CAST(COUNT(*) AS STRING) FROM matched
  UNION ALL SELECT 'subclasses_rais_sem_correspondencia', CAST(COUNT(*) AS STRING) FROM unmatched
  UNION ALL SELECT 'proporcao_subclasses_rais_com_correspondencia', CAST(SAFE_DIVIDE(COUNT(*), (SELECT COUNT(*) FROM rk)) AS STRING) FROM matched
  UNION ALL SELECT 'registros_rais_com_cnae_correspondente', CAST((SELECT COUNT(*) FROM r INNER JOIN ck ON r.cnae_2_subclasse = ck.subclasse) AS STRING)
  UNION ALL SELECT 'registros_rais_sem_cnae_correspondente', CAST((SELECT COUNT(*) FROM r LEFT JOIN ck ON r.cnae_2_subclasse = ck.subclasse WHERE ck.subclasse IS NULL) AS STRING)
)
SELECT 'metrica' AS tipo, metrica AS item, valor, CAST(NULL AS STRING) AS chave, CAST(NULL AS STRING) AS detalhe
FROM metrics
UNION ALL
SELECT 'exemplo_correspondente', 'subclasse', CAST(n AS STRING), cnae_2_subclasse, 'presente_no_diretorio'
FROM matched
UNION ALL
SELECT 'exemplo_sem_correspondencia', 'subclasse', CAST(n AS STRING), cnae_2_subclasse, 'ausente_no_diretorio'
FROM unmatched
ORDER BY tipo, item, chave
LIMIT 60