WITH operacoes_investimento_publicas AS (
  SELECT
    o.id_referencia_bacen,
    o.numero_ordem,
    o.valor_parcela_credito
  FROM `basedosdados.br_bcb_sicor.operacao` AS o
  JOIN `basedosdados.br_bcb_sicor.empreendimento` AS e
    ON o.id_empreendimento = e.id_empreendimento
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` AS f
    ON o.id_fonte_recurso = f.id_fonte_recurso
  WHERE o.ano_emissao = 2022
    AND e.finalidade = 'Investimento'
    AND f.indicador_recurso_publico = '1'
),
car_por_operacao AS (
  SELECT DISTINCT
    p.id_referencia_bacen,
    p.numero_ordem,
    UPPER(REPLACE(p.id_car, '-', '')) AS id_car_normalizado
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade` AS p
  WHERE p.ano_emissao = 2022
    AND p.id_car IS NOT NULL
),
car_com_contagem AS (
  SELECT
    id_referencia_bacen,
    numero_ordem,
    id_car_normalizado,
    COUNT(*) OVER (
      PARTITION BY id_referencia_bacen, numero_ordem
    ) AS numero_imoveis_car
  FROM car_por_operacao
),
snapshots_car AS (
  SELECT
    UPPER(REPLACE(a.id_imovel, '-', '')) AS id_car_normalizado,
    a.id_municipio,
    ROW_NUMBER() OVER (
      PARTITION BY UPPER(REPLACE(a.id_imovel, '-', ''))
      ORDER BY a.data_extracao DESC
    ) AS ordem_snapshot
  FROM `basedosdados.br_sfb_sicar.area_imovel` AS a
  WHERE a.data_extracao BETWEEN DATE '2026-06-02' AND DATE '2026-08-04'
),
rateio_por_municipio AS (
  SELECT
    s.id_municipio,
    SUM(o.valor_parcela_credito / c.numero_imoveis_car) AS credito_rateado
  FROM operacoes_investimento_publicas AS o
  JOIN car_com_contagem AS c
    ON o.id_referencia_bacen = c.id_referencia_bacen
   AND o.numero_ordem = c.numero_ordem
  JOIN snapshots_car AS s
    ON c.id_car_normalizado = s.id_car_normalizado
   AND s.ordem_snapshot = 1
  GROUP BY s.id_municipio
),
ranqueado AS (
  SELECT
    r.id_municipio,
    m.nome AS municipio,
    r.credito_rateado,
    ROW_NUMBER() OVER (ORDER BY r.credito_rateado DESC, r.id_municipio) AS posicao,
    SUM(r.credito_rateado) OVER () AS total_geral,
    COUNT(*) OVER () AS numero_municipios
  FROM rateio_por_municipio AS r
  JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS m
    ON r.id_municipio = m.id_municipio
)
SELECT
  posicao,
  id_municipio,
  municipio,
  credito_rateado,
  total_geral,
  numero_municipios
FROM ranqueado
WHERE posicao <= 10
ORDER BY posicao