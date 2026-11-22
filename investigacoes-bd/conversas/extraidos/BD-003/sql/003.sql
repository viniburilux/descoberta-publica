SELECT sigla_uf, COUNT(*) AS n
FROM `basedosdados.br_ms_sih.aihs_reduzidas`
WHERE ano = 2025 AND mes = 1
GROUP BY sigla_uf
ORDER BY sigla_uf