WITH autos AS (
  SELECT id_auto FROM `basedosdados.br_ibama_fiscalizacao.auto_infracao` WHERE ano >= 1977
), embargos AS (
  SELECT id_embargo, id_auto, id_municipio, ano FROM `basedosdados.br_ibama_fiscalizacao.area_embargada` WHERE ano >= 1987
), auto_keys AS (SELECT id_auto, COUNT(*) n FROM autos WHERE id_auto IS NOT NULL GROUP BY id_auto), embargo_keys AS (SELECT id_auto, COUNT(*) n FROM embargos WHERE id_auto IS NOT NULL GROUP BY id_auto),
matched AS (SELECT e.* FROM embargos e JOIN auto_keys a USING(id_auto)), unmatched AS (SELECT e.* FROM embargos e LEFT JOIN auto_keys a USING(id_auto) WHERE a.id_auto IS NULL),
metrics AS (
SELECT 'autos_registros' item, CAST(COUNT(*) AS STRING) valor FROM autos
UNION ALL SELECT 'embargos_registros', CAST(COUNT(*) AS STRING) FROM embargos
UNION ALL SELECT 'autos_id_nulo', CAST(COUNTIF(id_auto IS NULL) AS STRING) FROM autos
UNION ALL SELECT 'embargos_id_nulo', CAST(COUNTIF(id_auto IS NULL) AS STRING) FROM embargos
UNION ALL SELECT 'autos_ids_distintos', CAST(COUNT(*) AS STRING) FROM auto_keys
UNION ALL SELECT 'embargos_ids_distintos', CAST(COUNT(*) AS STRING) FROM embargo_keys
UNION ALL SELECT 'autos_ids_duplicados', CAST(COUNTIF(n > 1) AS STRING) FROM auto_keys
UNION ALL SELECT 'embargos_ids_duplicados', CAST(COUNTIF(n > 1) AS STRING) FROM embargo_keys
UNION ALL SELECT 'embargos_com_auto', CAST(COUNT(*) AS STRING) FROM matched
UNION ALL SELECT 'embargos_sem_auto', CAST(COUNT(*) AS STRING) FROM unmatched
UNION ALL SELECT 'proporcao_embargos_com_auto', CAST(SAFE_DIVIDE((SELECT COUNT(*) FROM matched),(SELECT COUNT(*) FROM embargos)) AS STRING)
UNION ALL SELECT 'proporcao_embargos_sem_auto', CAST(SAFE_DIVIDE((SELECT COUNT(*) FROM unmatched),(SELECT COUNT(*) FROM embargos)) AS STRING)
UNION ALL SELECT 'autos_com_embargo', CAST(COUNT(DISTINCT id_auto) AS STRING) FROM matched)
SELECT 1 ordem, 'metrica' tipo, item, valor, CAST(NULL AS STRING) id_1, CAST(NULL AS STRING) id_2 FROM metrics
UNION ALL SELECT 2, 'exemplo_correspondente', 'embargo', CAST(ano AS STRING), CAST(id_embargo AS STRING), CAST(id_auto AS STRING) FROM matched QUALIFY ROW_NUMBER() OVER (ORDER BY id_embargo) <= 5
UNION ALL SELECT 3, 'exemplo_sem_correspondencia', 'embargo', CAST(ano AS STRING), CAST(id_embargo AS STRING), CAST(id_auto AS STRING) FROM unmatched QUALIFY ROW_NUMBER() OVER (ORDER BY id_embargo) <= 5
ORDER BY ordem, item, id_1