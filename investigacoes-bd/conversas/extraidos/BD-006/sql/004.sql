WITH autos AS (
  SELECT id_auto
  FROM `basedosdados.br_ibama_fiscalizacao.auto_infracao`
  WHERE ano >= 1977
), embargos AS (
  SELECT id_embargo, id_auto, id_municipio, ano
  FROM `basedosdados.br_ibama_fiscalizacao.area_embargada`
  WHERE ano >= 1987
), auto_keys AS (
  SELECT id_auto, COUNT(*) AS n
  FROM autos
  WHERE id_auto IS NOT NULL
  GROUP BY id_auto
), embargo_keys AS (
  SELECT id_auto, COUNT(*) AS n
  FROM embargos
  WHERE id_auto IS NOT NULL
  GROUP BY id_auto
), matched AS (
  SELECT e.id_embargo, e.id_auto, e.id_municipio, e.ano
  FROM embargos e
  INNER JOIN auto_keys a USING (id_auto)
), unmatched AS (
  SELECT e.id_embargo, e.id_auto, e.id_municipio, e.ano
  FROM embargos e
  LEFT JOIN auto_keys a USING (id_auto)
  WHERE a.id_auto IS NULL
), metrics AS (
  SELECT 'origem_auto_infracao_registros' AS metrica, CAST(COUNT(*) AS STRING) AS valor FROM autos
  UNION ALL SELECT 'destino_area_embargada_registros', CAST(COUNT(*) AS STRING) FROM embargos
  UNION ALL SELECT 'autos_id_auto_nulo', CAST(COUNTIF(id_auto IS NULL) AS STRING) FROM autos
  UNION ALL SELECT 'embargos_id_auto_nulo', CAST(COUNTIF(id_auto IS NULL) AS STRING) FROM embargos
  UNION ALL SELECT 'autos_id_auto_distintos', CAST(COUNT(DISTINCT id_auto) AS STRING) FROM autos WHERE id_auto IS NOT NULL
  UNION ALL SELECT 'embargos_id_auto_distintos', CAST(COUNT(DISTINCT id_auto) AS STRING) FROM embargos WHERE id_auto IS NOT NULL
  UNION ALL SELECT 'autos_chaves_duplicadas', CAST(COUNTIF(n > 1) AS STRING) FROM auto_keys
  UNION ALL SELECT 'embargos_chaves_duplicadas', CAST(COUNTIF(n > 1) AS STRING) FROM embargo_keys
  UNION ALL SELECT 'embargos_com_auto', CAST(COUNT(*) AS STRING) FROM matched
  UNION ALL SELECT 'embargos_sem_auto', CAST(COUNT(*) AS STRING) FROM unmatched
  UNION ALL SELECT 'embargos_com_auto_proporcao', CAST(SAFE_DIVIDE(COUNT(*), (SELECT COUNT(*) FROM embargos)) AS STRING) FROM matched
  UNION ALL SELECT 'embargos_sem_auto_proporcao', CAST(SAFE_DIVIDE(COUNT(*), (SELECT COUNT(*) FROM embargos)) AS STRING) FROM unmatched
  UNION ALL SELECT 'autos_com_pelo_menos_um_embargo', CAST(COUNT(DISTINCT id_auto) AS STRING) FROM matched
)
SELECT 'metrica' AS tipo, metrica AS item, valor, CAST(NULL AS STRING) AS id_exemplo, CAST(NULL AS STRING) AS detalhe
FROM metrics
UNION ALL
SELECT 'exemplo_correspondente', 'embargo', CAST(ano AS STRING), id_embargo, id_auto
FROM matched
ORDER BY tipo, item, id_exemplo
LIMIT 40