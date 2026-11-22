WITH car AS (
 SELECT REPLACE(id_imovel,'-','') id_car_norm,id_municipio,sigla_uf,area
 FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao>=DATE '2026-06-02' AND data_extracao<=DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
),pl AS (
 SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
),onum AS (SELECT id_referencia_bacen,numero_ordem,COUNT(*) n FROM pl GROUP BY 1,2),m AS (
 SELECT c.id_municipio,c.sigla_uf,SUM(op.valor_parcela_credito/onum.n) credito
 FROM `basedosdados.br_bcb_sicor.operacao` op JOIN onum USING(id_referencia_bacen,numero_ordem)
 JOIN pl USING(id_referencia_bacen,numero_ordem) JOIN car c USING(id_car_norm)
 WHERE op.ano_emissao=2023 GROUP BY 1,2
)
SELECT m.id_municipio,d.nome,m.sigla_uf,m.credito,ROW_NUMBER() OVER(ORDER BY m.credito DESC) ranking
FROM m JOIN `basedosdados.br_bd_diretorios_brasil.municipio` d USING(id_municipio)
ORDER BY ranking LIMIT 20