SELECT
  ano,
  COUNT(*) AS registros_contrato,
  COUNTIF(valor_global IS NOT NULL) AS contratos_com_valor,
  SUM(COALESCE(valor_global, 0)) AS soma_valor_global
FROM `basedosdados.br_mgi_pncp.contrato`
WHERE ano IN (2021, 2022, 2025, 2026)
GROUP BY ano
ORDER BY ano