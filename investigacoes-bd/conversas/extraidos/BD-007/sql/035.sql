WITH car AS (
 SELECT REPLACE(id_imovel,'-','') id_car_norm,id_municipio,sigla_uf,area,modulos_fiscais
 FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao>=DATE '2026-06-02' AND data_extracao<=DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
),pl AS (
 SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
),n AS (SELECT id_referencia_bacen,numero_ordem,COUNT(*) n_imoveis FROM pl GROUP BY 1,2),p AS (
 SELECT c.id_car_norm,c.id_municipio,c.sigla_uf,c.area,c.modulos_fiscais,
 SUM(op.valor_parcela_credito/n.n_imoveis) credito,SUM(op.area_financiada/n.n_imoveis) area_financiada,
 COUNT(DISTINCT op.id_referencia_bacen) operacoes
 FROM `basedosdados.br_bcb_sicor.operacao` op JOIN n USING(id_referencia_bacen,numero_ordem)
 JOIN pl USING(id_referencia_bacen,numero_ordem) JOIN car c USING(id_car_norm)
 WHERE op.ano_emissao=2023 GROUP BY 1,2,3,4,5
),q AS (
 SELECT *,CASE WHEN area<1 THEN 'micro-registro (<1 ha)'
 WHEN modulos_fiscais IS NOT NULL AND modulos_fiscais<=4 THEN 'pequeno (até 4 módulos fiscais)'
 WHEN area>1000 THEN 'grande (>1.000 ha)'
 ELSE 'médio (demais)' END faixa
 FROM p WHERE area_financiada>area
)
SELECT faixa,COUNT(*) imoveis,SUM(credito) credito_alocado,SUM(area_financiada) area_financiada,
 SUM(area) area_car,SAFE_DIVIDE(SUM(area_financiada),SUM(area)) razao_agregada,
 AVG(SAFE_DIVIDE(area_financiada,area)) razao_media_imovel,AVG(operacoes) operacoes_media
FROM q GROUP BY faixa ORDER BY CASE faixa WHEN 'micro-registro (<1 ha)' THEN 1 WHEN 'pequeno (até 4 módulos fiscais)' THEN 2 WHEN 'médio (demais)' THEN 3 ELSE 4 END