WITH car AS (
 SELECT id_imovel,area FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao >= DATE '2026-06-02' AND data_extracao <= DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
), oi AS (
 SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
), oc AS (SELECT id_referencia_bacen,numero_ordem,COUNT(*) n FROM oi GROUP BY 1,2), b AS (
 SELECT REPLACE(c.id_imovel,'-','') id_imovel,c.id_imovel, c.area,
 op.id_referencia_bacen,op.valor_parcela_credito/oc.n credito,op.area_financiada/oc.n area_financiada
 FROM `basedosdados.br_bcb_sicor.operacao` op JOIN oc USING(id_referencia_bacen,numero_ordem)
 JOIN oi USING(id_referencia_bacen,numero_ordem) JOIN car c ON REPLACE(c.id_imovel,'-','')=oi.id_car_norm
 WHERE op.ano_emissao=2023
), p AS (
 SELECT id_imovel,ANY_VALUE(area) area_car,COUNT(DISTINCT id_referencia_bacen) operacoes,
 SUM(credito) credito,SUM(area_financiada) area_financiada
 FROM b GROUP BY id_imovel
), faixa AS (
 SELECT CASE WHEN SAFE_DIVIDE(area_financiada,area_car)>1 THEN 'acima de 100%'
 WHEN SAFE_DIVIDE(area_financiada,area_car)>0.5 THEN '50% a 100%'
 WHEN SAFE_DIVIDE(area_financiada,area_car)>0.25 THEN '25% a 50%'
 WHEN SAFE_DIVIDE(area_financiada,area_car)>=0 THEN 'até 25%'
 ELSE 'sem razão' END faixa, COUNT(*) imoveis, SUM(credito) credito,
 SUM(area_financiada) area_financiada, AVG(SAFE_DIVIDE(area_financiada,area_car)) razao_media
 FROM p GROUP BY 1
)
SELECT * FROM faixa ORDER BY CASE faixa WHEN 'acima de 100%' THEN 1 WHEN '50% a 100%' THEN 2 WHEN '25% a 50%' THEN 3 WHEN 'até 25%' THEN 4 ELSE 5 END