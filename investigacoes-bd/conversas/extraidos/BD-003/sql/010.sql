SELECT
  COUNT(*) AS internacoes_a00_a09,
  COUNTIF(m.id_municipio IS NOT NULL) AS com_municipio_ne,
  COUNT(DISTINCT id_municipio_paciente) AS municipios_distintos
FROM `basedosdados.br_ms_sih.aihs_reduzidas` s
LEFT JOIN `basedosdados.br_bd_diretorios_brasil.municipio` m
  ON s.id_municipio_paciente = m.id_municipio
 AND m.nome_regiao = 'Nordeste'
WHERE ano = 2025 AND mes = 1
  AND CAST(cid_principal_categoria AS STRING) IN ('A00','A01','A02','A03','A04','A05','A06','A07','A08','A09')