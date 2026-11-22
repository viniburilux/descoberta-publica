SELECT finalidade, COUNT(*) AS quantidade
FROM `basedosdados.br_bcb_sicor.empreendimento`
GROUP BY finalidade
ORDER BY quantidade DESC