WITH op_imoveis AS (
  SELECT DISTINCT id_referencia_bacen, numero_ordem, REPLACE(id_car, '-', '') AS id_car_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2023 AND id_car IS NOT NULL AND TRIM(id_car) <> ''
),
ops_pub AS (
  SELECT o.id_referencia_bacen, o.numero_ordem,
    MAX(o.valor_parcela_credito) AS valor_parcela_credito,
    MAX(o.area_financiada) AS area_financiada
  FROM `basedosdados.br_bcb_sicor.operacao` o
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` f USING (id_fonte_recurso)
  WHERE o.ano_emissao = 2023 AND f.indicador_recurso_publico = '1'
  GROUP BY 1, 2
),
cont AS (
  SELECT id_referencia_bacen, numero_ordem, COUNT(*) AS n
  FROM op_imoveis GROUP BY 1, 2
),
car AS (
  SELECT id_imovel, area, id_municipio
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
  QUALIFY ROW_NUMBER() OVER (PARTITION BY REPLACE(id_imovel, '-', '') ORDER BY data_extracao DESC) = 1
),
cred AS (
  SELECT c.id_imovel, c.area, c.id_municipio,
    SUM(p.valor_parcela_credito / n.n) AS credito,
    SUM(p.area_financiada / n.n) AS area_fin
  FROM ops_pub p
  JOIN cont n USING (id_referencia_bacen, numero_ordem)
  JOIN op_imoveis i USING (id_referencia_bacen, numero_ordem)
  JOIN car c ON REPLACE(c.id_imovel, '-', '') = i.id_car_norm
  GROUP BY 1, 2, 3
),
ids AS (
  SELECT * FROM UNNEST(['PA-1506187-94551B72659E427F961D2F62CEBA7392','MS-5006606-4693892971CF47B4B2684C3A94950BEE','PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A','BA-2921401-9177991E4861442EACFE3ACDDC06DB91','BA-2928109-0F43ABB998F5484394BAA55A4964A2BD','BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F','BA-2929057-C5D11EE026A64399A6EF36764E8739E9','BA-2913705-C31099AB04E24F15B9941AAAF17DC244','BA-2929057-2483416C90F94058B15FED07A5FE9FB7','RS-4322301-411110B140A543DB906D80C3081D1822','BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70','PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98','BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968','RS-4322301-249321677C5045DC84BE25A36C504F31','RS-4322301-8DD943476D08400A931895B8A17A8BA9','BA-2916500-9222A7C0C77E4E019B498875C6578189','BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB','BA-2902005-876B8A8CE62D40119A8446C4262A5AC7','RS-4322301-0BBDEB7272784E4DACA585E486AE37A9','BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6']) AS id_car
)
SELECT
  i.id_car,
  c.id_municipio,
  c.area AS area_car_ha,
  c.credito AS credito_publico_alocado,
  c.area_fin AS area_financiada_alocada,
  SAFE_DIVIDE(c.area_fin, c.area) * 100 AS razao_pct,
  (c.id_imovel IS NOT NULL) AS presente_no_recorte_publico
FROM ids i
LEFT JOIN cred c ON REPLACE(c.id_imovel, '-', '') = REPLACE(i.id_car, '-', '')
ORDER BY razao_pct DESC