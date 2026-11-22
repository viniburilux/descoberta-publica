WITH autos AS (
  SELECT id_auto
  FROM `basedosdados.br_ibama_fiscalizacao.auto_infracao`
  WHERE ano >= 1977
    AND id_auto IS NOT NULL
), embargos AS (
  SELECT id_auto
  FROM `basedosdados.br_ibama_fiscalizacao.area_embargada`
  WHERE ano >= 1987
    AND id_auto IS NOT NULL
)
SELECT
  COUNT(*) AS total_embargos,
  COUNTIF(a.id_auto IS NOT NULL) AS embargos_com_auto,
  COUNTIF(a.id_auto IS NULL) AS embargos_sem_auto,
  COUNT(DISTINCT e.id_auto) AS autos_com_embargo
FROM embargos e
LEFT JOIN autos a USING (id_auto)