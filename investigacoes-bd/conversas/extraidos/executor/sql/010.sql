WITH propriedades AS (
  SELECT DISTINCT
    id_referencia_bacen,
    numero_ordem,
    UPPER(REPLACE(id_car, '-', '')) AS id_imovel_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2023
    AND id_car IS NOT NULL
    AND TRIM(id_car) <> ''
),
-- Mantém o snapshot mais recente de cada imóvel CAR normalizado.
area_ranked AS (
  SELECT
    UPPER(REPLACE(id_imovel, '-', '')) AS id_imovel_norm,
    id_municipio,
    ROW_NUMBER() OVER (
      PARTITION BY UPPER(REPLACE(id_imovel, '-', ''))
      ORDER BY data_extracao DESC
    ) AS rn
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
    AND id_imovel IS NOT NULL
    AND id_municipio IS NOT NULL
),
area AS (
  SELECT id_imovel_norm, id_municipio
  FROM area_ranked
  WHERE rn = 1
),
imoveis_operacao AS (
  SELECT DISTINCT
    p.id_referencia_bacen,
    p.numero_ordem,
    a.id_municipio,
    p.id_imovel_norm
  FROM propriedades p
  JOIN area a USING (id_imovel_norm)
),
contagem_imoveis AS (
  SELECT
    id_referencia_bacen,
    numero_ordem,
    COUNT(DISTINCT id_imovel_norm) AS numero_imoveis
  FROM imoveis_operacao
  GROUP BY id_referencia_bacen, numero_ordem
),
-- A classificação oficial é a do catálogo de fontes do BCB.
operacoes_publicas AS (
  SELECT
    o.id_referencia_bacen,
    o.numero_ordem,
    MAX(o.valor_parcela_credito) AS valor_parcela_credito
  FROM `basedosdados.br_bcb_sicor.operacao` o
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` f
    ON o.id_fonte_recurso = f.id_fonte_recurso
  WHERE o.ano_emissao = 2023
    AND f.indicador_recurso_publico = '1'
  GROUP BY o.id_referencia_bacen, o.numero_ordem
),
municipal AS (
  SELECT
    io.id_municipio,
    m.nome AS nome_municipio,
    m.sigla_uf,
    SUM(op.valor_parcela_credito / ci.numero_imoveis) AS valor_financiado_rateado,
    COUNT(DISTINCT CONCAT(io.id_referencia_bacen, '-', io.numero_ordem)) AS numero_operacoes
  FROM imoveis_operacao io
  JOIN contagem_imoveis ci USING (id_referencia_bacen, numero_ordem)
  JOIN operacoes_publicas op USING (id_referencia_bacen, numero_ordem)
  LEFT JOIN `basedosdados.br_bd_diretorios_brasil.municipio` m USING (id_municipio)
  GROUP BY io.id_municipio, m.nome, m.sigla_uf
),
publico_total AS (
  SELECT SUM(o.valor_parcela_credito) AS total_recurso_publico_classificado
  FROM `basedosdados.br_bcb_sicor.operacao` o
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` f
    ON o.id_fonte_recurso = f.id_fonte_recurso
  WHERE o.ano_emissao = 2023
    AND f.indicador_recurso_publico = '1'
),
resultado AS (
  SELECT
    mu.id_municipio,
    mu.nome_municipio,
    mu.sigla_uf,
    mu.valor_financiado_rateado,
    mu.numero_operacoes,
    SUM(mu.valor_financiado_rateado) OVER () AS total_conectado_publico,
    pt.total_recurso_publico_classificado,
    SAFE_DIVIDE(
      SUM(mu.valor_financiado_rateado) OVER (),
      pt.total_recurso_publico_classificado
    ) AS fracao_sobre_recurso_publico_classificado,
    COUNT(*) OVER () AS municipios_conectados
  FROM municipal mu
  CROSS JOIN publico_total pt
)
SELECT *
FROM resultado
ORDER BY valor_financiado_rateado DESC, id_municipio