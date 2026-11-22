WITH ids AS (
  SELECT id_imovel
  FROM UNNEST([
    'PA-1506187-94551B72659E427F961D2F62CEBA7392',
    'MS-5006606-4693892971CF47B4B2684C3A94950BEE',
    'PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A',
    'BA-2921401-9177991E4861442EACFE3ACDDC06DB91',
    'BA-2928109-0F43ABB998F5484394BAA55A4964A2BD',
    'BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F',
    'BA-2929057-C5D11EE026A64399A6EF36764E8739E9',
    'BA-2913705-C31099AB04E24F15B9941AAAF17DC244',
    'BA-2929057-2483416C90F94058B15FED07A5FE9FB7',
    'RS-4322301-411110B140A543DB906D80C3081D1822',
    'BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70',
    'PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98',
    'BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968',
    'RS-4322301-249321677C5045DC84BE25A36C504F31',
    'RS-4322301-8DD943476D08400A931895B8A17A8BA9',
    'BA-2916500-9222A7C0C77E4E019B498875C6578189',
    'BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB',
    'BA-2902005-876B8A8CE62D40119A8446C4262A5AC7',
    'RS-4322301-0BBDEB7272784E4DACA585E486AE37A9',
    'BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6',
    'PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56',
    'PA-1506187-48EDE9CDCF3947959921871671228876'
  ]) AS id_imovel
),
app_recente AS (
  SELECT
    REPLACE(a.id_imovel, '-', '') AS id_norm,
    a.data_extracao,
    a.tipo AS tipo_codigo,
    a.area,
    ROW_NUMBER() OVER (
      PARTITION BY REPLACE(a.id_imovel, '-', '')
      ORDER BY a.data_extracao DESC
    ) AS rn
  FROM `basedosdados.br_sfb_sicar.app` a
  WHERE a.data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
    AND REPLACE(a.id_imovel, '-', '') IN (SELECT REPLACE(id_imovel, '-', '') FROM ids)
),
app_agregado AS (
  SELECT
    id_norm,
    data_extracao,
    'app' AS tabela,
    tipo_codigo,
    d.valor AS tipo,
    SUM(area) AS area_ha
  FROM app_recente a
  LEFT JOIN `basedosdados.br_sfb_sicar.dicionario` d
    ON d.id_tabela = 'app'
   AND d.nome_coluna = 'tipo'
   AND d.chave = a.tipo_codigo
  WHERE rn = 1
  GROUP BY id_norm, data_extracao, tipo_codigo, tipo
),
rl_recente AS (
  SELECT
    REPLACE(r.id_imovel, '-', '') AS id_norm,
    r.data_extracao,
    r.tipo AS tipo_codigo,
    r.area,
    ROW_NUMBER() OVER (
      PARTITION BY REPLACE(r.id_imovel, '-', '')
      ORDER BY r.data_extracao DESC
    ) AS rn
  FROM `basedosdados.br_sfb_sicar.reserva_legal` r
  WHERE r.data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
    AND REPLACE(r.id_imovel, '-', '') IN (SELECT REPLACE(id_imovel, '-', '') FROM ids)
),
rl_agregado AS (
  SELECT
    id_norm,
    data_extracao,
    'reserva_legal' AS tabela,
    tipo_codigo,
    d.valor AS tipo,
    SUM(area) AS area_ha
  FROM rl_recente r
  LEFT JOIN `basedosdados.br_sfb_sicar.dicionario` d
    ON d.id_tabela = 'reserva_legal'
   AND d.nome_coluna = 'tipo'
   AND d.chave = r.tipo_codigo
  WHERE rn = 1
  GROUP BY id_norm, data_extracao, tipo_codigo, tipo
),
ambiental AS (
  SELECT * FROM app_agregado
  UNION ALL
  SELECT * FROM rl_agregado
),
grid AS (
  SELECT i.id_imovel, REPLACE(i.id_imovel, '-', '') AS id_norm, t.tabela
  FROM ids i
  CROSS JOIN UNNEST(['app', 'reserva_legal']) AS t(tabela)
)
SELECT
  g.id_imovel,
  g.tabela,
  a.data_extracao,
  a.tipo_codigo,
  a.tipo,
  COALESCE(a.area_ha, 0) AS area_ha,
  a.tipo_codigo IS NOT NULL AS tem_poligono
FROM grid g
LEFT JOIN ambiental a
  ON a.id_norm = g.id_norm
 AND a.tabela = g.tabela
ORDER BY g.id_imovel, g.tabela, a.tipo