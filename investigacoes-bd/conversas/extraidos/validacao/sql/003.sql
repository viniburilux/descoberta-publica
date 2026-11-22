WITH e AS (
  SELECT id_embargo, id_auto
  FROM `basedosdados.br_ibama_fiscalizacao.area_embargada`
), a AS (
  SELECT DISTINCT id_auto
  FROM `basedosdados.br_ibama_fiscalizacao.auto_infracao`
  WHERE ano >= 1977
)
SELECT
  COUNT(*) AS embargos_registros,
  COUNTIF(e.id_auto IS NULL OR TRIM(e.id_auto) = '') AS embargos_id_auto_vazio,
  COUNTIF(a.id_auto IS NOT NULL) AS embargos_com_auto,
  COUNTIF(e.id_auto IS NOT NULL AND TRIM(e.id_auto) != '' AND a.id_auto IS NULL) AS embargos_sem_auto,
  COUNT(DISTINCT e.id_auto) AS autos_distintos_referenciados
FROM e LEFT JOIN a ON e.id_auto = a.id_auto;