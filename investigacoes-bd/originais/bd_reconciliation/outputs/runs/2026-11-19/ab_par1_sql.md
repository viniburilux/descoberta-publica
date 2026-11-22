# SQL verbatim, par A/B 1 (caso 2022 investimento publico)

Thread A (baseline): https://basedosdados.org/chatbot?t=e6d448ba-eceb-4c09-9705-dad568afe806
Thread B (com experiencia): https://basedosdados.org/chatbot?t=de090efe-9af0-4778-8556-a3c3eb6ef6ba

## A: query final (verificada por protocolo externo)
```sql
WITH operacoes AS (
  SELECT
    o.id_referencia_bacen,
    o.numero_ordem,
    o.valor_parcela_credito,
    CONCAT(SUBSTR(p.id_car, 1, 2), '-', SUBSTR(p.id_car, 3, 7), '-', SUBSTR(p.id_car, 10)) AS id_car
  FROM `basedosdados.br_bcb_sicor.operacao` AS o
  JOIN `basedosdados.br_bcb_sicor.empreendimento` AS e
    ON o.id_empreendimento = e.id_empreendimento
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` AS f
    ON o.id_fonte_recurso = f.id_fonte_recurso
  JOIN `basedosdados.br_bcb_sicor.recurso_publico_propriedade` AS p
    ON o.id_referencia_bacen = p.id_referencia_bacen
   AND o.numero_ordem = p.numero_ordem
   AND p.ano_emissao = 2022
  WHERE o.ano_emissao = 2022
    AND e.finalidade = 'Investimento'
    AND f.indicador_recurso_publico = '1'
    AND p.id_car IS NOT NULL
), operacoes_car AS (
  SELECT DISTINCT id_referencia_bacen, numero_ordem, valor_parcela_credito, id_car
  FROM operacoes
), rateio AS (
  SELECT
    oc.id_referencia_bacen,
    oc.numero_ordem,
    oc.id_car,
    SAFE_DIVIDE(oc.valor_parcela_credito, COUNT(*) OVER (PARTITION BY oc.id_referencia_bacen, oc.numero_ordem)) AS valor_rateado
  FROM operacoes_car AS oc
), car_atual AS (
  SELECT id_imovel, id_municipio
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
  QUALIFY ROW_NUMBER() OVER (PARTITION BY id_imovel ORDER BY data_extracao DESC) = 1
), por_municipio AS (
  SELECT
    m.id_municipio,
    m.nome,
    SUM(r.valor_rateado) AS valor_credito
  FROM rateio AS r
  JOIN car_atual AS c ON r.id_car = c.id_imovel
  JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS m USING (id_municipio)
  GROUP BY m.id_municipio, m.nome
), ranking AS (
  SELECT
    ROW_NUMBER() OVER (ORDER BY valor_credito DESC, nome) AS posicao,
    nome AS municipio,
    valor_credito,
    COUNT(*) OVER () AS numero_municipios,
    SUM(valor_credito) OVER () AS total_geral
  FROM por_municipio
)
SELECT
  'TOTAL_GERAL' AS tipo_resultado,
  CAST(NULL AS INT64) AS posicao,
  CAST(NULL AS STRING) AS municipio,
  total_geral AS valor_credito,
  numero_municipios,
  total_geral
FROM ranking
WHERE posicao = 1
UNION ALL
SELECT
  'TOP_10' AS tipo_resultado,
  posicao,
  municipio,
  valor_credito,
  numero_municipios,
  total_geral
FROM ranking
WHERE posicao <= 10
ORDER BY tipo_resultado, posicao
```

## B: query final (erro de snapshot: data_extracao = data maxima global)
```sql
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
```
