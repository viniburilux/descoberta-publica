WITH car AS (
 SELECT id_imovel,id_municipio,sigla_uf,area FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao >= DATE '2026-06-02' AND data_extracao <= DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
), oi AS (
 SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
), oc AS (SELECT id_referencia_bacen,numero_ordem,COUNT(*) n FROM oi GROUP BY 1,2), b AS (
 SELECT c.id_municipio,c.sigla_uf,op.id_referencia_bacen,c.id_imovel,
 op.valor_parcela_credito/oc.n credito,op.area_financiada/oc.n area_financiada
 FROM `basedosdados.br_bcb_sicor.operacao` op JOIN oc USING(id_referencia_bacen,numero_ordem)
 JOIN oi USING(id_referencia_bacen,numero_ordem) JOIN car c ON REPLACE(c.id_imovel,'-','')=oi.id_car_norm
 WHERE op.ano_emissao=2023
), m AS (
 SELECT id_municipio,sigla_uf,COUNT(DISTINCT id_referencia_bacen) operacoes,COUNT(DISTINCT id_imovel) imoveis,SUM(credito) credito,SUM(area_financiada) area_financiada
 FROM b GROUP BY 1,2
), r AS (SELECT m.*,SAFE_DIVIDE(credito,SUM(credito) OVER()) participacao FROM m)
SELECT r.id_municipio,d.nome,r.sigla_uf,r.operacoes,r.imoveis,r.credito,r.area_financiada,r.participacao
FROM r LEFT JOIN `basedosdados.br_bd_diretorios_brasil.municipio` d USING(id_municipio)
ORDER BY credito DESC LIMIT 15