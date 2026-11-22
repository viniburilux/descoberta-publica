WITH car AS (
 SELECT REPLACE(id_imovel,'-','') id_car_norm,id_municipio
 FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao>=DATE '2026-06-02' AND data_extracao<=DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
),p AS (
 SELECT DISTINCT REPLACE(id_car,'-','') id_car_norm,REGEXP_REPLACE(cpf,'[^0-9]','') documento
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!='' AND cpf IS NOT NULL AND TRIM(cpf)!=''
 UNION DISTINCT
 SELECT DISTINCT REPLACE(id_car,'-',''),REGEXP_REPLACE(cnpj_basico,'[^0-9]','')
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!='' AND cnpj_basico IS NOT NULL AND TRIM(cnpj_basico)!=''
),f AS (SELECT DISTINCT c.id_car_norm,c.id_municipio FROM car c JOIN p USING(id_car_norm)),e AS (
 SELECT DISTINCT REGEXP_REPLACE(cpf_cnpj_embargado,'[^0-9]','') documento,id_municipio,id_embargo
 FROM `basedosdados.br_ibama_fiscalizacao.area_embargada`
 WHERE ano BETWEEN 1987 AND 2026 AND cpf_cnpj_embargado IS NOT NULL AND TRIM(cpf_cnpj_embargado)!=''
),j AS (
 SELECT f.id_car_norm,f.id_municipio,p.documento,e.id_embargo,e.id_municipio AS municipio_embargo
 FROM f JOIN p USING(id_car_norm) LEFT JOIN e ON e.documento=p.documento
)
SELECT COUNT(DISTINCT id_car_norm) imoveis_financiados,
 COUNT(DISTINCT IF(id_embargo IS NOT NULL,id_car_norm,NULL)) imoveis_com_embargo_mesmo_documento,
 COUNT(DISTINCT IF(id_embargo IS NOT NULL AND municipio_embargo=id_municipio,id_car_norm,NULL)) imoveis_com_embargo_documento_municipio,
 COUNT(DISTINCT IF(id_embargo IS NOT NULL,documento,NULL)) documentos_embargados_que_aparecem_no_sicor
FROM j