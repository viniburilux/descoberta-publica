WITH propriedades AS (
  SELECT DISTINCT
    id_referencia_bacen,
    numero_ordem,
    UPPER(REPLACE(id_car, '-', '')) AS id_car_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2023
    AND id_car IS NOT NULL
    AND TRIM(id_car) <> ''
),
area AS (
  SELECT id_imovel_norm, id_municipio
  FROM (
    SELECT
      UPPER(REPLACE(id_imovel, '-', '')) AS id_imovel_norm,
      id_municipio,
      ROW_NUMBER() OVER (
        PARTITION BY UPPER(REPLACE(id_imovel, '-', ''))
        ORDER BY data_extracao DESC
      ) AS rn
    FROM `basedosdados.br_sfb_sicar.area_imovel`
    WHERE data_extracao IS NOT NULL
      AND id_imovel IS NOT NULL
  )
  WHERE rn = 1
),
chaves_imoveis AS (
  SELECT DISTINCT
    p.id_referencia_bacen,
    p.numero_ordem,
    a.id_municipio,
    p.id_car_norm
  FROM propriedades p
  JOIN area a ON a.id_imovel_norm = p.id_car_norm
),
contagem AS (
  SELECT id_referencia_bacen, numero_ordem, COUNT(DISTINCT id_car_norm) AS n_imoveis
  FROM chaves_imoveis
  GROUP BY id_referencia_bacen, numero_ordem
),
operacoes AS (
  SELECT id_referencia_bacen, numero_ordem, valor_parcela_credito
  FROM `basedosdados.br_bcb_sicor.operacao`
  WHERE ano_emissao = 2023
)
SELECT
  c.id_referencia_bacen,
  c.numero_ordem,
  c.id_municipio,
  o.valor_parcela_credito,
  c.n_imoveis
FROM chaves_imoveis c
JOIN contagem n USING (id_referencia_bacen, numero_ordem)
JOIN operacoes o USING (id_referencia_bacen, numero_ordem)
LIMIT 10