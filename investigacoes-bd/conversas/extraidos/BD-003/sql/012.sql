WITH municipios_ne AS (
  SELECT id_municipio, id_municipio_6
  FROM `basedosdados.br_bd_diretorios_brasil.municipio`
  WHERE nome_regiao = 'Nordeste'
),
anos AS (
  SELECT ano FROM UNNEST(GENERATE_ARRAY(2018, 2025)) AS ano
),
base_municipio_ano AS (
  SELECT m.id_municipio, a.ano
  FROM municipios_ne m
  CROSS JOIN anos a
),
emendas AS (
  SELECT
    e.id_municipio_gasto AS id_municipio,
    e.ano_emenda AS ano,
    SUM(COALESCE(e.valor_pago, 0)) AS emendas_pagas
  FROM `basedosdados.br_cgu_emendas_parlamentares.microdados` e
  INNER JOIN municipios_ne m ON e.id_municipio_gasto = m.id_municipio
  WHERE e.ano_emenda BETWEEN 2018 AND 2025
    AND REGEXP_CONTAINS(e.id_municipio_gasto, r'^[0-9]+$')
  GROUP BY 1, 2
),
internacoes AS (
  SELECT
    m.id_municipio,
    s.ano,
    COUNT(*) AS internacoes_hidricas
  FROM `basedosdados.br_ms_sih.aihs_reduzidas` s
  INNER JOIN municipios_ne m ON s.id_municipio_paciente = m.id_municipio_6
  WHERE s.ano BETWEEN 2018 AND 2025
    AND s.mes BETWEEN 1 AND 12
    -- Proxy restrito: diagnósticos principais A00-A09, doenças infecciosas intestinais.
    AND CAST(s.cid_principal_categoria AS STRING) IN ('A00','A01','A02','A03','A04','A05','A06','A07','A08','A09')
  GROUP BY 1, 2
),
populacao AS (
  SELECT id_municipio, ano, populacao
  FROM `basedosdados.br_ibge_populacao.municipio`
  WHERE ano BETWEEN 2018 AND 2025
),
painel AS (
  SELECT
    b.id_municipio,
    b.ano,
    COALESCE(e.emendas_pagas, 0) AS emendas_pagas,
    COALESCE(i.internacoes_hidricas, 0) AS internacoes_hidricas,
    p.populacao,
    SAFE_DIVIDE(COALESCE(i.internacoes_hidricas, 0) * 100000.0, p.populacao) AS taxa_internacoes_100k
  FROM base_municipio_ano b
  LEFT JOIN emendas e USING (id_municipio, ano)
  LEFT JOIN internacoes i USING (id_municipio, ano)
  LEFT JOIN populacao p USING (id_municipio, ano)
  WHERE p.populacao IS NOT NULL
),
com_lag AS (
  SELECT
    *,
    LEAD(taxa_internacoes_100k) OVER (PARTITION BY id_municipio ORDER BY ano) AS taxa_internacoes_ano_seguinte
  FROM painel
)
SELECT 'pooled_contemporanea' AS analise, CAST(NULL AS INT64) AS ano, COUNT(*) AS observacoes, CORR(emendas_pagas, taxa_internacoes_100k) AS correlacao_pearson
FROM painel
UNION ALL
SELECT 'pooled_defasagem_emendas_1_ano', CAST(NULL AS INT64), COUNTIF(taxa_internacoes_ano_seguinte IS NOT NULL), CORR(emendas_pagas, taxa_internacoes_ano_seguinte)
FROM com_lag
UNION ALL
SELECT 'por_ano', ano, COUNT(*) AS observacoes, CORR(emendas_pagas, taxa_internacoes_100k)
FROM painel
GROUP BY ano
ORDER BY analise, ano