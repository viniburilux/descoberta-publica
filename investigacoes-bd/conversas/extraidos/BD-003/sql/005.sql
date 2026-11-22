SELECT CAST(cid_principal_categoria AS STRING) AS cid, COUNT(*) AS n
FROM `basedosdados.br_ms_sih.aihs_reduzidas`
WHERE ano = 2025 AND mes = 1
GROUP BY cid
ORDER BY n DESC
LIMIT 30