WITH car AS (
 SELECT id_imovel,id_municipio,sigla_uf FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao >= DATE '2026-06-02' AND data_extracao <= DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
), oi AS (
 SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
), oc AS (SELECT id_referencia_bacen,numero_ordem,COUNT(*) n FROM oi GROUP BY 1,2), cr AS (
 SELECT c.id_municipio,c.sigla_uf,SUM(op.valor_parcela_credito/oc.n) credito
 FROM `basedosdados.br_bcb_sicor.operacao` op JOIN oc USING(id_referencia_bacen,numero_ordem)
 JOIN oi USING(id_referencia_bacen,numero_ordem) JOIN car c ON REPLACE(c.id_imovel,'-','')=oi.id_car_norm
 WHERE op.ano_emissao=2023 GROUP BY 1,2
), soja AS (
 SELECT id_municipio,sigla_uf,SUM(area_colhida) area_soja,SUM(quantidade_produzida) producao_soja,SUM(valor_producao) valor_soja
 FROM `basedosdados.br_ibge_pam.lavoura_temporaria` WHERE ano=2023 AND produto='Soja (em grão)' GROUP BY 1,2
), mapa AS (
 SELECT id_municipio,sigla_uf,SUM(IF(nivel_2='Agricultura',area,0)) agricultura,SUM(IF(nivel_2='Pastagem',area,0)) pastagem
 FROM `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe` WHERE ano=2023 GROUP BY 1,2
), x AS (
 SELECT cr.credito,s.area_soja,s.producao_soja,s.valor_soja,m.agricultura,m.pastagem
 FROM cr LEFT JOIN soja s USING(id_municipio,sigla_uf) LEFT JOIN mapa m USING(id_municipio,sigla_uf)
)
SELECT COUNT(*) municipios_com_credito,
 CORR(credito,area_soja) corr_credito_area_soja,
 CORR(credito,producao_soja) corr_credito_producao_soja,
 CORR(credito,valor_soja) corr_credito_valor_soja,
 CORR(credito,agricultura) corr_credito_area_agricultura,
 CORR(credito,pastagem) corr_credito_area_pastagem
FROM x