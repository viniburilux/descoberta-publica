WITH car AS (
 SELECT REPLACE(id_imovel,'-','') id_car_norm,id_imovel,id_municipio,sigla_uf,area,modulos_fiscais
 FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao>=DATE '2026-06-02' AND data_extracao<=DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
),pl AS (
 SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
),n AS (SELECT id_referencia_bacen,numero_ordem,COUNT(*) n_imoveis FROM pl GROUP BY 1,2),pc AS (
 SELECT c.id_car_norm,c.id_imovel,c.id_municipio,c.sigla_uf,c.area,c.modulos_fiscais,
 SUM(op.valor_parcela_credito/n.n_imoveis) credito,SUM(op.area_financiada/n.n_imoveis) area_financiada
 FROM `basedosdados.br_bcb_sicor.operacao` op JOIN n USING(id_referencia_bacen,numero_ordem)
 JOIN pl USING(id_referencia_bacen,numero_ordem) JOIN car c USING(id_car_norm)
 WHERE op.ano_emissao=2023 GROUP BY 1,2,3,4,5,6
),top20 AS (
 SELECT *,ROW_NUMBER() OVER(ORDER BY SAFE_DIVIDE(area_financiada,area) DESC) ranking
 FROM pc WHERE area<1 AND area>0 AND area_financiada>area
 QUALIFY ranking<=20
),dp AS (SELECT DISTINCT chave,valor FROM `basedosdados.br_bcb_sicor.dicionario` WHERE nome_coluna='id_programa'),df AS (SELECT DISTINCT chave,valor FROM `basedosdados.br_bcb_sicor.dicionario` WHERE nome_coluna='id_fonte_recurso')
SELECT t.ranking,t.id_imovel,d.nome municipio,t.sigla_uf,t.area area_car_ha,t.area_financiada,t.credito,
 SAFE_DIVIDE(t.area_financiada,t.area) razao_area,
 op.id_referencia_bacen,op.numero_ordem,op.data_emissao,op.ano_safra_emissao,
 op.valor_parcela_credito valor_parcela_credito_original,op.area_financiada area_financiada_original,
 e.finalidade,e.produto,e.atividade,e.modalidade,e.unidade_medida,
 COALESCE(dp.valor,CONCAT('código ',op.id_programa)) programa,
 COALESCE(df.valor,CONCAT('código ',op.id_fonte_recurso)) fonte_recurso
FROM top20 t
JOIN pl USING(id_car_norm)
JOIN n USING(id_referencia_bacen,numero_ordem)
JOIN `basedosdados.br_bcb_sicor.operacao` op USING(id_referencia_bacen,numero_ordem)
LEFT JOIN `basedosdados.br_bcb_sicor.empreendimento` e USING(id_empreendimento)
LEFT JOIN dp ON dp.chave=op.id_programa
LEFT JOIN df ON df.chave=op.id_fonte_recurso
LEFT JOIN `basedosdados.br_bd_diretorios_brasil.municipio` d USING(id_municipio)
WHERE op.ano_emissao=2023
ORDER BY t.ranking,op.data_emissao,op.id_referencia_bacen,op.numero_ordem