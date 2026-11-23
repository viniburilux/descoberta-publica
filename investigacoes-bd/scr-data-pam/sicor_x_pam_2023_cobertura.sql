WITH
sicor_base AS (
  SELECT DISTINCT
    id_municipio,
    id_referencia_bacen,
    numero_ordem
  FROM `basedosdados.br_bcb_sicor.recurso_publico_complemento_operacao`
  WHERE ano_emissao = 2023
    AND id_municipio IS NOT NULL
),
sicor_municipios AS (
  SELECT
    s.id_municipio,
    SUM(o.valor_parcela_credito) AS valor_contratado
  FROM sicor_base AS s
  LEFT JOIN (
    SELECT DISTINCT
      id_referencia_bacen,
      numero_ordem,
      valor_parcela_credito
    FROM `basedosdados.br_bcb_sicor.operacao`
    WHERE ano_emissao = 2023
  ) AS o
    ON s.id_referencia_bacen = o.id_referencia_bacen
   AND s.numero_ordem = o.numero_ordem
  GROUP BY s.id_municipio
),
pam_temporaria AS (
  SELECT DISTINCT id_municipio
  FROM `basedosdados.br_ibge_pam.lavoura_temporaria`
  WHERE ano = 2023
    AND id_municipio IS NOT NULL
),
pam_permanente AS (
  SELECT DISTINCT id_municipio
  FROM `basedosdados.br_ibge_pam.lavoura_permanente`
  WHERE ano = 2023
    AND id_municipio IS NOT NULL
),
pam AS (
  SELECT id_municipio FROM pam_temporaria
  UNION DISTINCT
  SELECT id_municipio FROM pam_permanente
),
municipios_brasil AS (
  SELECT DISTINCT id_municipio
  FROM `basedosdados.br_bd_diretorios_brasil.municipio`
  WHERE id_municipio IS NOT NULL
),
resumo_corrigido AS (
  SELECT
    COUNT(DISTINCT s.id_municipio) AS municipios_sicor,
    COUNT(DISTINCT p.id_municipio) AS municipios_pam,
    COUNT(DISTINCT CASE
      WHEN s.id_municipio IS NOT NULL
       AND p.id_municipio IS NOT NULL
      THEN s.id_municipio
    END) AS municipios_casados,
    COUNT(DISTINCT CASE
      WHEN s.id_municipio IS NOT NULL
       AND p.id_municipio IS NULL
      THEN s.id_municipio
    END) AS municipios_so_sicor,
    COUNT(DISTINCT CASE
      WHEN s.id_municipio IS NULL
       AND p.id_municipio IS NOT NULL
      THEN p.id_municipio
    END) AS municipios_so_pam,
    (SELECT COUNT(DISTINCT id_municipio)
     FROM municipios_brasil) AS municipios_brasil,
    (SELECT COUNT(DISTINCT id_municipio)
     FROM pam_temporaria) AS municipios_pam_temporaria,
    (SELECT COUNT(DISTINCT id_municipio)
     FROM pam_permanente) AS municipios_pam_permanente
  FROM sicor_municipios AS s
  FULL OUTER JOIN pam AS p USING (id_municipio)
)
SELECT
  'resumo' AS tipo_linha,
  CAST(NULL AS STRING) AS id_municipio,
  municipios_sicor,
  municipios_pam,
  municipios_pam_temporaria,
  municipios_pam_permanente,
  municipios_casados,
  municipios_so_sicor,
  municipios_so_pam,
  municipios_brasil,
  CAST(NULL AS FLOAT64) AS valor_contratado
FROM resumo_corrigido
UNION ALL
SELECT
  'sicor_por_municipio' AS tipo_linha,
  id_municipio,
  CAST(NULL AS INT64),
  CAST(NULL AS INT64),
  CAST(NULL AS INT64),
  CAST(NULL AS INT64),
  CAST(NULL AS INT64),
  CAST(NULL AS INT64),
  CAST(NULL AS INT64),
  CAST(NULL AS INT64),
  valor_contratado
FROM sicor_municipios
ORDER BY tipo_linha, id_municipio
