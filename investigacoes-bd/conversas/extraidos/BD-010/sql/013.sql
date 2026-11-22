WITH ids AS (
  SELECT id_imovel
  FROM UNNEST([
    'PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56',
    'PA-1506187-48EDE9CDCF3947959921871671228876',
    'PA-1506187-8A59FA2709F1467CB9659E8E433E29A2',
    'PA-1506187-2FA6A081B1F745D4800249F665C9DE96',
    'PA-1506187-A4DD4E93695C4B7DA32C7F0DB8CDE959',
    'PA-1506187-34A1DD76FA7D40848D10832D82940BDA',
    'PA-1506187-DAE50532EA2F4A3093A94AA2A6197177',
    'PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98',
    'BA-2929057-C5D11EE026A64399A6EF36764E8739E9'
  ]) AS id_imovel
),
recente AS (
  SELECT
    a.id_imovel,
    a.data_criacao,
    a.data_atualizacao,
    a.data_extracao,
    a.status,
    a.condicao,
    a.area,
    a.tipo,
    ROW_NUMBER() OVER (
      PARTITION BY REPLACE(a.id_imovel, '-', '')
      ORDER BY a.data_extracao DESC
    ) AS rn
  FROM `basedosdados.br_sfb_sicar.area_imovel` a
  WHERE a.data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
    AND REPLACE(a.id_imovel, '-', '') IN (
      SELECT REPLACE(id_imovel, '-', '') FROM ids
    )
)
SELECT
  i.id_imovel,
  r.data_criacao,
  r.data_atualizacao,
  r.data_extracao,
  r.status,
  r.condicao,
  r.area,
  r.tipo
FROM ids i
LEFT JOIN recente r
  ON REPLACE(r.id_imovel, '-', '') = REPLACE(i.id_imovel, '-', '')
  AND r.rn = 1
ORDER BY i.id_imovel