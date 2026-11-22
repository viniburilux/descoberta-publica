WITH car AS (
 SELECT id_imovel,id_municipio,sigla_uf,area FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao >= DATE '2026-06-02' AND data_extracao <= DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
), oi AS (
 SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
), oc AS (SELECT id_referencia_bacen,numero_ordem,COUNT(*) n FROM oi GROUP BY 1,2), p AS (
 SELECT c.id_imovel,c.id_municipio,c.sigla_uf,c.area,
 COUNT(DISTINCT op.id_referencia_bacen) operacoes,
 SUM(op.area_financiada/oc.n) area_financiada,
 SUM(op.valor_parcela_credito/oc.n) credito
 FROM `basedosdados.br_bcb_sicor.operacao` op JOIN oc USING(id_referencia_bacen,numero_ordem)
 JOIN oi USING(id_referencia_bacen,numero_ordem) JOIN car c ON REPLACE(c.id_imovel,'-','')=oi.id_car_norm
 WHERE op.ano_emissao=2023 GROUP BY 1,2,3,4
)
SELECT p.id_imovel,d.nome,p.sigla_uf,p.operacoes,p.area area_car,p.area_financiada,
 SAFE_DIVIDE(p.area_financiada,p.area) razao_area,p.credito
FROM p LEFT JOIN `basedosdados.br_bd_diretorios_brasil.municipio` d USING(id_municipio)
WHERE p.area > 0 ORDER BY razao_area DESC LIMIT 10