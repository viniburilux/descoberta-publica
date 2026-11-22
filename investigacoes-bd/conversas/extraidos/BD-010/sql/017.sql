WITH ids AS (
  SELECT id_imovel
  FROM UNNEST([
    'PA-1506187-94551B72659E427F961D2F62CEBA7392','MS-5006606-4693892971CF47B4B2684C3A94950BEE','PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A','BA-2921401-9177991E4861442EACFE3ACDDC06DB91','BA-2928109-0F43ABB998F5484394BAA55A4964A2BD','BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F','BA-2929057-C5D11EE026A64399A6EF36764E8739E9','BA-2913705-C31099AB04E24F15B9941AAAF17DC244','BA-2929057-2483416C90F94058B15FED07A5FE9FB7','RS-4322301-411110B140A543DB906D80C3081D1822','BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70','PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98','BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968','RS-4322301-249321677C5045DC84BE25A36C504F31','RS-4322301-8DD943476D08400A931895B8A17A8BA9','BA-2916500-9222A7C0C77E4E019B498875C6578189','BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB','BA-2902005-876B8A8CE62D40119A8446C4262A5AC7','RS-4322301-0BBDEB7272784E4DACA585E486AE37A9','BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6','PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56','PA-1506187-48EDE9CDCF3947959921871671228876'
  ]) AS id_imovel
),
app_base AS (
  SELECT a.* EXCEPT(id_imovel), a.id_imovel AS id_original, REPLACE(a.id_imovel, '-', '') AS id_norm
  FROM `basedosdados.br_sfb_sicar.app` a
  WHERE a.data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
    AND REPLACE(a.id_imovel, '-', '') IN (SELECT REPLACE(id_imovel, '-', '') FROM ids)
),
app_latest AS (
  SELECT * FROM app_base
  QUALIFY data_extracao = MAX(data_extracao) OVER (PARTITION BY id_norm)
),
rl_base AS (
  SELECT r.* EXCEPT(id_imovel), r.id_imovel AS id_original, REPLACE(r.id_imovel, '-', '') AS id_norm
  FROM `basedosdados.br_sfb_sicar.reserva_legal` r
  WHERE r.data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
    AND REPLACE(r.id_imovel, '-', '') IN (SELECT REPLACE(id_imovel, '-', '') FROM ids)
),
rl_latest AS (
  SELECT * FROM rl_base
  QUALIFY data_extracao = MAX(data_extracao) OVER (PARTITION BY id_norm)
),
imovel_latest AS (
  SELECT * EXCEPT(rn) FROM (
    SELECT a.*, REPLACE(a.id_imovel, '-', '') AS id_norm,
      ROW_NUMBER() OVER (PARTITION BY REPLACE(a.id_imovel, '-', '') ORDER BY a.data_extracao DESC) AS rn
    FROM `basedosdados.br_sfb_sicar.area_imovel` a
    WHERE a.data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
      AND REPLACE(a.id_imovel, '-', '') IN (SELECT REPLACE(id_imovel, '-', '') FROM ids)
  ) WHERE rn = 1
),
condicoes AS (
  SELECT id_norm, 'app' AS tabela, MAX(data_extracao) AS data_extracao,
    STRING_AGG(DISTINCT condicao, ' | ') AS condicao, COUNT(*) AS n_geometrias
  FROM app_latest GROUP BY id_norm
  UNION ALL
  SELECT id_norm, 'reserva_legal' AS tabela, MAX(data_extracao) AS data_extracao,
    STRING_AGG(DISTINCT condicao, ' | ') AS condicao, COUNT(*) AS n_geometrias
  FROM rl_latest GROUP BY id_norm
),
micros AS (
  SELECT id_imovel FROM UNNEST([
    'BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968','BA-2902005-876B8A8CE62D40119A8446C4262A5AC7','BA-2913705-C31099AB04E24F15B9941AAAF17DC244','BA-2916500-9222A7C0C77E4E019B498875C6578189','BA-2921401-9177991E4861442EACFE3ACDDC06DB91','BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6','BA-2928109-0F43ABB998F5484394BAA55A4964A2BD','BA-2929057-2483416C90F94058B15FED07A5FE9FB7','BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F','BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB','BA-2929057-C5D11EE026A64399A6EF36764E8739E9','BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70','RS-4322301-249321677C5045DC84BE25A36C504F31'
  ]) AS id_imovel
),
rl_micros AS (
  SELECT m.id_imovel, MAX(r.data_extracao) AS data_extracao, ST_UNION_AGG(r.geometria) AS geom_rl
  FROM micros m JOIN rl_latest r ON r.id_norm = REPLACE(m.id_imovel, '-', '')
  GROUP BY m.id_imovel
),
imovel_micros AS (
  SELECT m.id_imovel, i.area AS area_imovel_ha, i.geometria AS geom_imovel
  FROM micros m JOIN imovel_latest i ON i.id_norm = REPLACE(m.id_imovel, '-', '')
),
par AS (
  SELECT r.id_imovel, r.data_extracao, ST_AREA(r.geom_rl)/10000 AS area_rl_ha, i.area_imovel_ha,
    ST_AREA(ST_INTERSECTION(r.geom_rl, i.geom_imovel))/10000 AS area_intersecao_ha,
    SAFE_DIVIDE(ST_AREA(ST_INTERSECTION(r.geom_rl, i.geom_imovel)), ST_AREA(r.geom_rl))*100 AS percentual_rl_intersecta_imovel
  FROM rl_micros r JOIN imovel_micros i USING (id_imovel)
),
pair_rl AS (
  SELECT a.geom_rl AS geom_a, b.geom_rl AS geom_b, a.data_extracao AS data_extracao_a, b.data_extracao AS data_extracao_b
  FROM rl_micros a JOIN rl_micros b ON a.id_imovel = 'PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56' AND b.id_imovel = 'PA-1506187-48EDE9CDCF3947959921871671228876'
),
ms_app AS (
  SELECT ST_UNION_AGG(a.geometria) AS geom_app, MAX(a.data_extracao) AS data_extracao
  FROM app_latest a WHERE a.id_norm = REPLACE('MS-5006606-4693892971CF47B4B2684C3A94950BEE', '-', '')
),
saida AS (
  SELECT '1_condicao' AS bloco, i.id_imovel, CAST(NULL AS STRING) AS id_imovel_2, c.tabela, c.data_extracao, c.condicao, c.n_geometrias,
    CAST(NULL AS FLOAT64) AS area_rl_ha, CAST(NULL AS FLOAT64) AS area_imovel_ha, CAST(NULL AS FLOAT64) AS area_intersecao_ha,
    CAST(NULL AS FLOAT64) AS percentual_a, CAST(NULL AS FLOAT64) AS percentual_b, CAST(NULL AS FLOAT64) AS area_app_ha, CAST(NULL AS FLOAT64) AS percentual_intersecao_imovel
  FROM ids i LEFT JOIN condicoes c ON c.id_norm = REPLACE(i.id_imovel, '-', '')
  UNION ALL
  SELECT '2_micros_rl_imovel', p.id_imovel, CAST(NULL AS STRING), 'reserva_legal', p.data_extracao, CAST(NULL AS STRING), CAST(NULL AS INT64),
    p.area_rl_ha, p.area_imovel_ha, p.area_intersecao_ha, p.percentual_rl_intersecta_imovel, CAST(NULL AS FLOAT64), CAST(NULL AS FLOAT64), CAST(NULL AS FLOAT64)
  FROM par p
  UNION ALL
  SELECT '3_intersecao_rl_dois_car', 'PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56', 'PA-1506187-48EDE9CDCF3947959921871671228876', 'reserva_legal', pa.data_extracao_a, CAST(NULL AS STRING), CAST(NULL AS INT64),
    ST_AREA(pa.geom_a)/10000, ST_AREA(pa.geom_b)/10000, ST_AREA(ST_INTERSECTION(pa.geom_a, pa.geom_b))/10000,
    SAFE_DIVIDE(ST_AREA(ST_INTERSECTION(pa.geom_a, pa.geom_b)), ST_AREA(pa.geom_a))*100,
    SAFE_DIVIDE(ST_AREA(ST_INTERSECTION(pa.geom_a, pa.geom_b)), ST_AREA(pa.geom_b))*100,
    CAST(NULL AS FLOAT64), CAST(NULL AS FLOAT64)
  FROM pair_rl pa
  UNION ALL
  SELECT '4_ms_app_imovel', 'MS-5006606-4693892971CF47B4B2684C3A94950BEE', CAST(NULL AS STRING), 'app', a.data_extracao, CAST(NULL AS STRING), CAST(NULL AS INT64),
    CAST(NULL AS FLOAT64), i.area, ST_AREA(ST_INTERSECTION(a.geom_app, i.geometria))/10000, CAST(NULL AS FLOAT64), CAST(NULL AS FLOAT64),
    ST_AREA(a.geom_app)/10000, SAFE_DIVIDE(ST_AREA(ST_INTERSECTION(a.geom_app, i.geometria)), ST_AREA(a.geom_app))*100
  FROM ms_app a CROSS JOIN (SELECT area, geometria FROM imovel_latest WHERE id_norm = REPLACE('MS-5006606-4693892971CF47B4B2684C3A94950BEE', '-', '')) i
)
SELECT * FROM saida ORDER BY bloco, id_imovel, tabela, id_imovel_2