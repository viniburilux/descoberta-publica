WITH propriedades AS (
  SELECT DISTINCT id_referencia_bacen, numero_ordem, UPPER(REPLACE(id_car, '-', '')) AS id_imovel_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2023 AND id_car IS NOT NULL AND TRIM(id_car) <> ''
), area_ranked AS (
  SELECT UPPER(REPLACE(id_imovel, '-', '')) AS id_imovel_norm, id_municipio,
    ROW_NUMBER() OVER (PARTITION BY UPPER(REPLACE(id_imovel, '-', '')) ORDER BY data_extracao DESC) AS rn
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
    AND id_imovel IS NOT NULL AND id_municipio IS NOT NULL
), area AS (
  SELECT id_imovel_norm, id_municipio FROM area_ranked WHERE rn = 1
), imoveis_operacao AS (
  SELECT DISTINCT p.id_referencia_bacen, p.numero_ordem, a.id_municipio, p.id_imovel_norm
  FROM propriedades p JOIN area a USING (id_imovel_norm)
), contagem_imoveis AS (
  SELECT id_referencia_bacen, numero_ordem, COUNT(DISTINCT id_imovel_norm) AS numero_imoveis
  FROM imoveis_operacao GROUP BY id_referencia_bacen, numero_ordem
), operacoes_publicas AS (
  SELECT o.id_referencia_bacen, o.numero_ordem, MAX(o.valor_parcela_credito) AS valor_parcela_credito
  FROM `basedosdados.br_bcb_sicor.operacao` o
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` f USING (id_fonte_recurso)
  WHERE o.ano_emissao = 2023 AND f.indicador_recurso_publico = '1'
  GROUP BY o.id_referencia_bacen, o.numero_ordem
)
SELECT
  io.id_municipio,
  SUM(op.valor_parcela_credito / ci.numero_imoveis) AS valor_financiado_rateado
FROM imoveis_operacao io
JOIN contagem_imoveis ci USING (id_referencia_bacen, numero_ordem)
JOIN operacoes_publicas op USING (id_referencia_bacen, numero_ordem)
GROUP BY io.id_municipio