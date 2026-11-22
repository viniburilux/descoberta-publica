WITH mapbiomas AS (
  SELECT id_municipio, sigla_uf, bioma, ano
  FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe`
  WHERE ano = 2023
  GROUP BY id_municipio, sigla_uf, bioma, ano
), prodes AS (
  SELECT id_municipio, bioma, ano
  FROM `basedosdados.br_inpe_prodes.municipio_bioma`
  WHERE ano = 2023
  GROUP BY id_municipio, bioma, ano
)
SELECT
  COUNT(*) AS chaves_prodes,
  COUNTIF(m.id_municipio IS NOT NULL) AS chaves_com_mapbiomas,
  COUNTIF(m.id_municipio IS NULL) AS chaves_sem_mapbiomas
FROM prodes p
LEFT JOIN mapbiomas m
  ON p.id_municipio = m.id_municipio
 AND p.bioma = m.bioma
 AND p.ano = m.ano