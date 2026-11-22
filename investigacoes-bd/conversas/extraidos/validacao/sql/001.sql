WITH l AS (
  SELECT ano, CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) AS chave
  FROM `basedosdados.br_inpe_prodes.municipio_bioma`
  WHERE ano IN (2023)
), r AS (
  SELECT DISTINCT CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) AS chave
  FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe`
  WHERE ano IN (2023)
)
SELECT
  l.ano,
  COUNT(*) AS registros_left,
  COUNT(DISTINCT l.chave) AS chaves_distintas_left,
  COUNTIF(r.chave IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.chave IS NOT NULL, l.chave, NULL)) AS chaves_correspondentes,
  COUNTIF(r.chave IS NULL) AS registros_sem_correspondencia
FROM l LEFT JOIN r USING (chave)
GROUP BY l.ano ORDER BY l.ano;