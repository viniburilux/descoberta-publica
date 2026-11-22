SELECT id_referencia_bacen, numero_ordem, valor_parcela_credito, ano_emissao
FROM `basedosdados.br_bcb_sicor.recurso_publico`
WHERE ano_emissao = 2023
LIMIT 5