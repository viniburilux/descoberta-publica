WITH operacoes AS (
  SELECT DISTINCT
    o.id_referencia_bacen,
    o.numero_ordem,
    o.valor_parcela_credito
  FROM `basedosdados.br_bcb_sicor.operacao` AS o
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` AS f
    ON o.id_fonte_recurso = f.id_fonte_recurso
  JOIN `basedosdados.br_bcb_sicor.empreendimento` AS e
    ON o.id_empreendimento = e.id_empreendimento
  WHERE o.ano_emissao = 2022
    AND f.indicador_recurso_publico = '1'
    AND e.finalidade = 'Investimento'
), propriedades AS (
  SELECT DISTINCT
    p.id_referencia_bacen,
    p.numero_ordem,
    REPLACE(UPPER(p.id_car), '-', '') AS id_car_normalizado
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade` AS p
  WHERE p.ano_emissao = 2022
    AND p.id_car IS NOT NULL
), car_snapshot AS (
  SELECT id_car_normalizado, id_municipio
  FROM (
    SELECT
      REPLACE(UPPER(a.id_imovel), '-', '') AS id_car_normalizado,
      a.id_municipio,
      ROW_NUMBER() OVER (
        PARTITION BY REPLACE(UPPER(a.id_imovel), '-', '')
        ORDER BY a.data_extracao DESC, a.data_atualizacao DESC
      ) AS rn
    FROM `basedosdados.br_sfb_sicar.area_imovel` AS a
    WHERE a.data_extracao = '2026-08-04'
  )
  WHERE rn = 1
), operacao_car AS (
  SELECT DISTINCT
    o.id_referencia_bacen,
    o.numero_ordem,
    o.valor_parcela_credito,
    c.id_car_normalizado,
    c.id_municipio
  FROM operacoes AS o
  JOIN propriedades AS p
    ON o.id_referencia_bacen = p.id_referencia_bacen
   AND o.numero_ordem = p.numero_ordem
  JOIN car_snapshot AS c
    ON p.id_car_normalizado = c.id_car_normalizado
), rateado AS (
  SELECT
    id_referencia_bacen,
    numero_ordem,
    id_municipio,
    valor_parcela_credito / COUNT(*) OVER (
      PARTITION BY id_referencia_bacen, numero_ordem
    ) AS valor_rateado
  FROM operacao_car
), municipios AS (
  SELECT
    r.id_municipio,
    m.nome AS municipio,
    SUM(r.valor_rateado) AS credito_rateado
  FROM rateado AS r
  LEFT JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS m
    ON r.id_municipio = m.id_municipio
  GROUP BY r.id_municipio, m.nome
), resumo AS (
  SELECT
    *,
    SUM(credito_rateado) OVER () AS total_geral,
    COUNT(*) OVER () AS numero_municipios,
    ROW_NUMBER() OVER (ORDER BY credito_rateado DESC, municipio) AS ranking
  FROM municipios
)
SELECT
  ranking,
  id_municipio,
  municipio,
  credito_rateado,
  total_geral,
  numero_municipios
FROM resumo
WHERE ranking <= 10
ORDER BY ranking