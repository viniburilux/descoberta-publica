WITH
-- Uma linha por imóvel no snapshot CAR mais recente disponível para cada identificador.
car AS (
  SELECT id_imovel, id_municipio, sigla_uf, area, data_extracao
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao >= DATE '2026-06-02' AND data_extracao <= DATE '2026-08-04'
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY REPLACE(id_imovel, '-', '')
    ORDER BY data_extracao DESC
  ) = 1
),
-- Remove repetições da relação operação-imóvel antes de alocar os valores.
op_imoveis AS (
  SELECT DISTINCT
    id_referencia_bacen, numero_ordem,
    REPLACE(id_car, '-', '') AS id_car_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2023
    AND id_car IS NOT NULL AND TRIM(id_car) != ''
),
op_contagem AS (
  SELECT id_referencia_bacen, numero_ordem, COUNT(*) AS n_imoveis
  FROM op_imoveis
  GROUP BY id_referencia_bacen, numero_ordem
),
-- Cada linha de operação é distribuída igualmente entre seus imóveis CAR vinculados.
credito_imovel AS (
  SELECT
    c.id_municipio,
    c.sigla_uf,
    c.id_imovel,
    c.area AS area_car,
    o.id_referencia_bacen,
    o.numero_ordem,
    1.0 / oc.n_imoveis AS peso_imovel,
    op.valor_parcela_credito / oc.n_imoveis AS credito_alocado,
    op.area_financiada / oc.n_imoveis AS area_financiada_alocada,
    op.area_informada / oc.n_imoveis AS area_informada_alocada
  FROM `basedosdados.br_bcb_sicor.operacao` op
  JOIN op_contagem oc USING (id_referencia_bacen, numero_ordem)
  JOIN op_imoveis oi USING (id_referencia_bacen, numero_ordem)
  JOIN car c ON REPLACE(c.id_imovel, '-', '') = oi.id_car_norm
  WHERE op.ano_emissao = 2023
),
credito_municipio AS (
  SELECT
    id_municipio, sigla_uf,
    COUNT(DISTINCT id_referencia_bacen) AS operacoes_com_car,
    COUNT(DISTINCT id_imovel) AS imoveis_car,
    SUM(credito_alocado) AS credito_contratado_alocado,
    SUM(area_financiada_alocada) AS area_financiada_alocada,
    SUM(area_car * peso_imovel) AS area_car_alocada
  FROM credito_imovel
  GROUP BY id_municipio, sigla_uf
),
soja AS (
  SELECT id_municipio, sigla_uf,
    SUM(area_colhida) AS area_soja_colhida,
    SUM(quantidade_produzida) AS producao_soja_t,
    SUM(valor_producao) AS valor_soja_mil_brl
  FROM `basedosdados.br_ibge_pam.lavoura_temporaria`
  WHERE ano = 2023 AND produto = 'Soja (em grão)'
  GROUP BY id_municipio, sigla_uf
),
mapa AS (
  SELECT id_municipio, sigla_uf,
    SUM(IF(nivel_1 = 'Agropecuária', area, 0)) AS area_agropecuaria_ha,
    SUM(IF(nivel_2 = 'Agricultura', area, 0)) AS area_agricultura_ha,
    SUM(IF(nivel_2 = 'Pastagem', area, 0)) AS area_pastagem_ha
  FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe`
  WHERE ano = 2023
  GROUP BY id_municipio, sigla_uf
),
resultado AS (
  SELECT
    cm.*,
    s.area_soja_colhida, s.producao_soja_t, s.valor_soja_mil_brl,
    m.area_agropecuaria_ha, m.area_agricultura_ha, m.area_pastagem_ha,
    SAFE_DIVIDE(cm.area_financiada_alocada, cm.area_car_alocada) AS razao_area_financiada_car,
    SAFE_DIVIDE(cm.credito_contratado_alocado, SUM(cm.credito_contratado_alocado) OVER ()) AS participacao_credito_brasil
  FROM credito_municipio cm
  LEFT JOIN soja s USING (id_municipio, sigla_uf)
  LEFT JOIN mapa m USING (id_municipio, sigla_uf)
)
SELECT *
FROM resultado
ORDER BY credito_contratado_alocado DESC
LIMIT 30