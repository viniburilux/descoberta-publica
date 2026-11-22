WITH
car AS (
  SELECT id_imovel, id_municipio, sigla_uf, area
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao >= DATE '2026-06-02' AND data_extracao <= DATE '2026-08-04'
  QUALIFY ROW_NUMBER() OVER (PARTITION BY REPLACE(id_imovel, '-', '') ORDER BY data_extracao DESC) = 1
),
op_imoveis AS (
  SELECT DISTINCT id_referencia_bacen, numero_ordem, REPLACE(id_car, '-', '') AS id_car_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2023 AND id_car IS NOT NULL AND TRIM(id_car) != ''
),
op_contagem AS (
  SELECT id_referencia_bacen, numero_ordem, COUNT(*) AS n_imoveis FROM op_imoveis GROUP BY 1,2
),
base AS (
  SELECT c.id_municipio, c.sigla_uf, c.id_imovel, c.area AS area_car,
    op.id_referencia_bacen, op.numero_ordem,
    op.valor_parcela_credito / oc.n_imoveis AS credito_alocado,
    op.area_financiada / oc.n_imoveis AS area_financiada_alocada,
    1.0 / oc.n_imoveis AS peso_imovel
  FROM `basedosdados.br_bcb_sicor.operacao` op
  JOIN op_contagem oc USING (id_referencia_bacen, numero_ordem)
  JOIN op_imoveis oi USING (id_referencia_bacen, numero_ordem)
  JOIN car c ON REPLACE(c.id_imovel, '-', '') = oi.id_car_norm
  WHERE op.ano_emissao = 2023
),
mun AS (
  SELECT id_municipio, sigla_uf,
    COUNT(DISTINCT id_referencia_bacen) AS operacoes,
    COUNT(DISTINCT id_imovel) AS imoveis,
    SUM(credito_alocado) AS credito,
    SUM(area_financiada_alocada) AS area_financiada,
    SUM(area_car * peso_imovel) AS area_car
  FROM base GROUP BY 1,2
),
uf AS (
  SELECT sigla_uf, COUNT(*) AS municipios, SUM(operacoes) AS operacoes, SUM(imoveis) AS imoveis,
    SUM(credito) AS credito, SUM(area_financiada) AS area_financiada, SUM(area_car) AS area_car,
    SAFE_DIVIDE(SUM(area_financiada), SUM(area_car)) AS razao_area
  FROM mun GROUP BY sigla_uf
),
res AS (
  SELECT 'Brasil' AS recorte, COUNT(*) AS municipios, SUM(operacoes) AS operacoes, SUM(imoveis) AS imoveis,
    SUM(credito) AS credito, SUM(area_financiada) AS area_financiada, SUM(area_car) AS area_car,
    SAFE_DIVIDE(SUM(area_financiada), SUM(area_car)) AS razao_area
  FROM mun
  UNION ALL
  SELECT sigla_uf, municipios, operacoes, imoveis, credito, area_financiada, area_car, razao_area FROM uf
)
SELECT * FROM res ORDER BY IF(recorte = 'Brasil', 0, 1), credito DESC