SELECT id_fonte_recurso, COUNT(*) AS n_ops, SUM(valor_parcela_credito) AS valor_total
FROM `basedosdados.br_bcb_sicor.operacao`
WHERE ano_emissao = 2023 AND id_fonte_recurso IN ('911','0911')
GROUP BY id_fonte_recurso