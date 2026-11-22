WITH car AS (
 SELECT REPLACE(id_imovel,'-','') id_car_norm,id_imovel,id_municipio,sigla_uf,area
 FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao>=DATE '2026-06-02' AND data_extracao<=DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
),p AS (
 SELECT DISTINCT ano_emissao,id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao BETWEEN 2013 AND 2026 AND id_car IS NOT NULL AND TRIM(id_car)!=''
),n AS (SELECT ano_emissao,id_referencia_bacen,numero_ordem,COUNT(*) n_imoveis FROM p GROUP BY 1,2,3),b AS (
 SELECT op.ano_emissao,c.id_car_norm,c.id_imovel,c.id_municipio,c.sigla_uf,c.area,
 op.id_referencia_bacen,op.numero_ordem,op.valor_parcela_credito/n.n_imoveis credito_rateado,op.area_financiada/n.n_imoveis area_financiada_rateada
 FROM p JOIN n USING(ano_emissao,id_referencia_bacen,numero_ordem) JOIN `basedosdados.br_bcb_sicor.operacao` op USING(ano_emissao,id_referencia_bacen,numero_ordem) JOIN car c USING(id_car_norm)
 WHERE op.ano_emissao BETWEEN 2013 AND 2026
),classified AS (
 SELECT *,CASE WHEN area<0.1 THEN 'Micro (<0,1 ha)' WHEN area<1 THEN 'Muito pequenos (0,1 a <1 ha)' WHEN area<4 THEN 'Pequenos (1 a <4 ha)' ELSE 'Demais (>=4 ha)' END faixa FROM b
),agg AS (
 SELECT ano_emissao,faixa,COUNT(DISTINCT id_imovel) imoveis_unicos,COUNT(DISTINCT id_referencia_bacen) operacoes_distintas,COUNT(*) linhas_operacao,SUM(credito_rateado) credito_associado,SUM(area_financiada_rateada) area_financiada_acumulada,SUM(DISTINCT area) area_car_declarada
 FROM classified GROUP BY ano_emissao,faixa
)
SELECT *,SAFE_DIVIDE(area_financiada_acumulada,area_car_declarada) razao_area_financiada_area_car FROM agg ORDER BY ano_emissao,CASE faixa WHEN 'Micro (<0,1 ha)' THEN 1 WHEN 'Muito pequenos (0,1 a <1 ha)' THEN 2 WHEN 'Pequenos (1 a <4 ha)' THEN 3 ELSE 4 END