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
    op.area_financiada / oc.n_imoveis AS area_financiada_alocada
  FROM `basedosdados.br_bcb_sicor.operacao` op
  JOIN op_contagem oc USING (id_referencia_bacen, numero_ordem)
  JOIN op_imoveis oi USING (id_referencia_bacen, numero_ordem)
  JOIN car c ON REPLACE(c.id_imovel, '-', '') = oi.id_car_norm
  WHERE op.ano_emissao = 2023
),
credito AS (
  SELECT id_municipio, sigla_uf, COUNT(DISTINCT id_referencia_bacen) AS operacoes,
    COUNT(DISTINCT id_imovel) AS imoveis, SUM(credito_alocado) AS credito,
    SUM(area_financiada_alocada) AS area_financiada
  FROM base GROUP BY 1,2
),
car_unico AS (
  SELECT id_municipio, sigla_uf, SUM(area_car) AS area_car
  FROM (SELECT DISTINCT id_municipio, sigla_uf, id_imovel, area_car FROM base)
  GROUP BY 1,2
),
municipios AS (
  SELECT c.*, u.area_car, SAFE_DIVIDE(c.area_financiada, u.area_car) AS razao_area
  FROM credito c JOIN car_unico u USING (id_municipio, sigla_uf)
),
uf AS (
  SELECT sigla_uf AS recorte, COUNT(*) AS municipios, SUM(operacoes) AS operacoes, SUM(imoveis) AS imoveis,
    SUM(credito) AS credito, SUM(area_financiada) AS area_financiada, SUM(area_car) AS area_car,
    SAFE_DIVIDE(SUM(area_financiada), SUM(area_car)) AS razao_area
  FROM municipios GROUP BY sigla_uf
), brasil AS (
  SELECT 'Brasil' AS recorte, COUNT(*) AS municipios, SUM(operacoes) AS operacoes, SUM(imoveis) AS imoveis,
    SUM(credito) AS credito, SUM(area_financiada) AS area_financiada, SUM(area_car) AS area_car,
    SAFE_DIVIDE(SUM(area_financiada), SUM(area_car)) AS razao_area
  FROM municipios
)
SELECT * FROM brasil UNION ALL SELECT * FROM uf ORDER BY IF(recorte = 'Brasil', 0, 1), credito DESC