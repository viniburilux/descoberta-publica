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
-- Deduplica snapshots do CAR, mantendo o registro mais recente de cada imóvel.
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
  SELECT id_referencia_bacen, numero_ordem, COUNT(DISTINCT id_imovel_norm) AS numero_imoveis
  FROM imoveis_operacao
  GROUP BY id_referencia_bacen, numero_ordem
),
operacoes AS (
  SELECT id_referencia_bacen, numero_ordem, MAX(valor_parcela_credito) AS valor_parcela_credito
  FROM `basedosdados.br_bcb_sicor.operacao`
  WHERE ano_emissao = 2023
  GROUP BY id_referencia_bacen, numero_ordem
),
municipal AS (
  SELECT
    io.id_municipio,
    m.nome AS nome_municipio,
    m.sigla_uf,
    SUM(o.valor_parcela_credito / ci.numero_imoveis) AS valor_financiado_rateado,
    COUNT(DISTINCT CONCAT(io.id_referencia_bacen, '-', io.numero_ordem)) AS numero_operacoes
  FROM imoveis_operacao io
  JOIN contagem_imoveis ci USING (id_referencia_bacen, numero_ordem)
  JOIN operacoes o USING (id_referencia_bacen, numero_ordem)
  LEFT JOIN `basedosdados.br_bd_diretorios_brasil.municipio` m USING (id_municipio)
  GROUP BY io.id_municipio, m.nome, m.sigla_uf
),
resultado AS (
  SELECT
    id_municipio,
    nome_municipio,
    sigla_uf,
    valor_financiado_rateado,
    numero_operacoes,
    RANK() OVER (ORDER BY valor_financiado_rateado DESC) AS ranking_valor,
    SUM(valor_financiado_rateado) OVER () AS total_conectado,
    COUNT(*) OVER () AS municipios_conectados
  FROM municipal
)
SELECT *
FROM resultado
ORDER BY ranking_valor, id_municipio