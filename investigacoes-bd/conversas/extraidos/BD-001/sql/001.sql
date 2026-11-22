SELECT
  c.modalidade,
  COUNT(*) AS quantidade
FROM `basedosdados.br_mgi_pncp.contratacao` AS c
JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS m
  ON c.id_municipio = m.id_municipio
WHERE c.ano = 2025
  AND m.nome = 'Correntina'
  AND m.sigla_uf = 'BA'
GROUP BY c.modalidade
ORDER BY quantidade DESC