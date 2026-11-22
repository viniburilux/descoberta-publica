WITH prodes AS (
  SELECT
    id_municipio,
    SUM(desmatado) AS desmatado_km2,
    SUM(area_total) AS area_bioma_km2
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
), pam AS (
  SELECT
    id_municipio,
    SUM(quantidade_produzida) AS producao_ton,
    SUM(valor_producao) AS valor_producao_mil_brl,
    SUM(area_colhida) AS area_colhida_ha
  FROM `basedosdados.br_ibge_pam.lavoura_temporaria`
  WHERE ano = 2023
  GROUP BY id_municipio
)
SELECT
  p.id_municipio,
  p.desmatado_km2,
  p.area_bioma_km2,
  m.area_mapeada_ha,
  m.classes_presentes,
  a.producao_ton,
  a.valor_producao_mil_brl,
  a.area_colhida_ha
FROM prodes p
JOIN mapbiomas m USING (id_municipio)
JOIN pam a USING (id_municipio)
ORDER BY p.desmatado_km2 DESC
LIMIT 20