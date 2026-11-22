WITH queimadas AS (
  SELECT
    id_municipio,
    COUNT(*) AS focos,
    SUM(potencia_radiativa_fogo) AS frp_total_mw,
    AVG(risco_fogo) AS risco_fogo_medio,
    SUM(precipitacao) AS precipitacao_somada
  FROM `basedosdados.br_inpe_queimadas.microdados`
  WHERE ano = 2023
  GROUP BY id_municipio
), prodes AS (
  SELECT
    id_municipio,
    SUM(desmatado) AS desmatado_km2
  FROM `basedosdados.br_inpe_prodes.municipio_bioma`
  WHERE ano = 2023
  GROUP BY id_municipio
), mapbiomas AS (
  SELECT
    id_municipio,
    SUM(area) AS area_mapeada_ha,
    COUNT(DISTINCT id_classe) AS classes_presentes
  FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe`
  WHERE ano = 2023
  GROUP BY id_municipio
)
SELECT
  q.id_municipio,
  q.focos,
  q.frp_total_mw,
  q.risco_fogo_medio,
  q.precipitacao_somada,
  p.desmatado_km2,
  m.area_mapeada_ha,
  m.classes_presentes
FROM queimadas q
JOIN prodes p USING (id_municipio)
JOIN mapbiomas m USING (id_municipio)
ORDER BY q.focos DESC
LIMIT 20