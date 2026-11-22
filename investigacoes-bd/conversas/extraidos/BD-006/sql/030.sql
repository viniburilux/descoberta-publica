WITH operacoes AS (
  SELECT
    id_referencia_bacen,
    numero_ordem,
    SUM(area_financiada) AS area_financiada_ha,
    SUM(valor_parcela_credito) AS credito_brl,
    COUNT(*) AS linhas_operacao
  FROM `basedosdados.br_bcb_sicor.operacao`
  WHERE ano_emissao = 2026
  GROUP BY id_referencia_bacen, numero_ordem
), propriedades AS (
  SELECT DISTINCT
    id_referencia_bacen,
    numero_ordem,
    id_car,
    ano_emissao
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2026
    AND id_car IS NOT NULL
    AND TRIM(id_car) != ''
), car AS (
  SELECT DISTINCT
    REPLACE(UPPER(TRIM(id_imovel)), '-', '') AS id_car_normalizado,
    id_imovel,
    id_municipio,
    sigla_uf,
    area AS area_imovel_ha
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao IN ('2026-06-02','2026-08-01','2026-08-02','2026-08-03','2026-08-04')
), credito_imovel AS (
  SELECT
    p.id_car,
    c.id_imovel,
    c.id_municipio,
    c.sigla_uf,
    COUNT(DISTINCT CONCAT(p.id_referencia_bacen, '|', p.numero_ordem)) AS operacoes,
    SUM(o.area_financiada_ha) AS area_financiada_ha,
    SUM(o.credito_brl) AS credito_brl,
    MAX(c.area_imovel_ha) AS area_imovel_ha
  FROM propriedades p
  JOIN operacoes o
    ON p.id_referencia_bacen = o.id_referencia_bacen
   AND p.numero_ordem = o.numero_ordem
  JOIN car c
    ON p.id_car = REPLACE(UPPER(TRIM(c.id_imovel)), '-', '')
  GROUP BY p.id_car,c.id_imovel,c.id_municipio,c.sigla_uf
), pam AS (
  SELECT
    id_municipio,
    SUM(quantidade_produzida) AS producao_ton,
    SUM(valor_producao) AS valor_producao_mil_brl,
    SUM(area_colhida) AS area_colhida_ha
  FROM `basedosdados.br_ibge_pam.lavoura_temporaria`
  WHERE ano = 2024
  GROUP BY id_municipio
), mapbiomas AS (
  SELECT
    id_municipio,
    SUM(area) AS area_mapeada_ha,
    COUNT(DISTINCT id_classe) AS classes_presentes
  FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe`
  WHERE ano = 2025
  GROUP BY id_municipio
)
SELECT
  c.id_car,
  c.id_imovel,
  c.id_municipio,
  c.sigla_uf,
  c.operacoes,
  c.area_financiada_ha,
  c.credito_brl,
  c.area_imovel_ha,
  p.producao_ton,
  p.valor_producao_mil_brl,
  p.area_colhida_ha,
  m.area_mapeada_ha,
  m.classes_presentes
FROM credito_imovel c
LEFT JOIN pam p USING (id_municipio)
LEFT JOIN mapbiomas m USING (id_municipio)
ORDER BY c.credito_brl DESC
LIMIT 20