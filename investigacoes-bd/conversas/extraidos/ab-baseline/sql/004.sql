SELECT
  COUNT(*) AS operacoes_2022,
  COUNTIF(e.finalidade = 'Investimento') AS investimento,
  COUNTIF(f.indicador_recurso_publico = '1') AS investimento_publico,
  COUNTIF(p.id_car IS NOT NULL) AS com_car
FROM `basedosdados.br_bcb_sicor.operacao` AS o
JOIN `basedosdados.br_bcb_sicor.empreendimento` AS e USING (id_empreendimento)
JOIN `basedosdados.br_bcb_sicor.fonte_recurso` AS f USING (id_fonte_recurso)
LEFT JOIN `basedosdados.br_bcb_sicor.recurso_publico_propriedade` AS p
  ON o.id_referencia_bacen = p.id_referencia_bacen
 AND o.numero_ordem = p.numero_ordem
 AND p.ano_emissao = 2022
WHERE o.ano_emissao = 2022