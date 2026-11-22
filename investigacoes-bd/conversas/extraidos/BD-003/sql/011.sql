SELECT id_municipio_paciente, sigla_uf, COUNT(*) AS n
FROM `basedosdados.br_ms_sih.aihs_reduzidas`
WHERE ano = 2025 AND mes = 1
  AND CAST(cid_principal_categoria AS STRING) = 'A09'
GROUP BY 1,2
ORDER BY n DESC
LIMIT 20