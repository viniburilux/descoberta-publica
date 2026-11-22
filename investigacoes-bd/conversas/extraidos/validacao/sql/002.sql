WITH l AS (
  SELECT ano, cnae_2_subclasse AS chave
  FROM `basedosdados.br_me_rais.microdados_estabelecimentos`
  WHERE ano IN (2023)
), r AS (
  SELECT DISTINCT subclasse AS chave
  FROM `basedosdados.br_bd_diretorios_brasil.cnae_2`
)
SELECT
  l.ano,
  COUNT(*) AS registros_left,
  COUNT(DISTINCT l.chave) AS subclasses_distintas_left,
  COUNTIF(r.chave IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.chave IS NOT NULL, l.chave, NULL)) AS subclasses_correspondentes,
  COUNTIF(r.chave IS NULL) AS registros_sem_correspondencia
FROM l LEFT JOIN r USING (chave)
GROUP BY l.ano ORDER BY l.ano;