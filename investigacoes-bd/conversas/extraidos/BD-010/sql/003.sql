WITH op_imoveis AS (
  SELECT DISTINCT id_referencia_bacen, numero_ordem, REPLACE(id_car, '-', '') AS id_car_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2023 AND id_car IS NOT NULL AND TRIM(id_car) <> ''
),
ops_pub AS (
  SELECT o.id_referencia_bacen, o.numero_ordem,
    MAX(o.valor_parcela_credito) AS valor_parcela_credito,
    MAX(o.area_financiada) AS area_financiada
  FROM `basedosdados.br_bcb_sicor.operacao` o
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` f USING (id_fonte_recurso)
  WHERE o.ano_emissao = 2023 AND f.indicador_recurso_publico = '1'
  GROUP BY 1, 2
),
cont AS (
  SELECT id_referencia_bacen, numero_ordem, COUNT(*) AS n
  FROM op_imoveis GROUP BY 1, 2
),
car AS (
  SELECT id_imovel, area, id_municipio
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
  QUALIFY ROW_NUMBER() OVER (PARTITION BY REPLACE(id_imovel, '-', '') ORDER BY data_extracao DESC) = 1
),
cred AS (
  SELECT c.id_imovel, c.area, c.id_municipio,
    SUM(p.valor_parcela_credito / n.n) AS credito,
    SUM(p.area_financiada / n.n) AS area_fin
  FROM ops_pub p
  JOIN cont n USING (id_referencia_bacen, numero_ordem)
  JOIN op_imoveis i USING (id_referencia_bacen, numero_ordem)
  JOIN car c ON REPLACE(c.id_imovel, '-', '') = i.id_car_norm
  GROUP BY 1, 2, 3
)
SELECT
  COUNTIF(area < 1 AND area_fin > area) AS micros_gt100,
  SUM(IF(area < 1 AND area_fin > area, credito, 0)) AS valor_micros_gt100,
  COUNTIF(area_fin > area) AS imoveis_gt100
FROM cred