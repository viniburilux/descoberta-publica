WITH
car AS (
 SELECT REPLACE(id_imovel,'-','') id_car_norm,id_municipio,sigla_uf,area
 FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao>=DATE '2026-06-02' AND data_extracao<=DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
),
pl AS (
 SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
),
pd AS (
 SELECT DISTINCT REPLACE(id_car,'-','') id_car_norm,REGEXP_REPLACE(cpf,'[^0-9]','') documento
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!='' AND cpf IS NOT NULL AND TRIM(cpf)!=''
 UNION DISTINCT
 SELECT DISTINCT REPLACE(id_car,'-',''),REGEXP_REPLACE(cnpj_basico,'[^0-9]','')
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!='' AND cnpj_basico IS NOT NULL AND TRIM(cnpj_basico)!=''
),
onum AS (SELECT id_referencia_bacen,numero_ordem,COUNT(*) n FROM pl GROUP BY 1,2),
fc AS (
 SELECT c.id_car_norm,c.id_municipio,c.sigla_uf,c.area area_car,
 SUM(op.valor_parcela_credito/onum.n) credito,SUM(op.area_financiada/onum.n) area_financiada
 FROM `basedosdados.br_bcb_sicor.operacao` op JOIN onum USING(id_referencia_bacen,numero_ordem)
 JOIN pl USING(id_referencia_bacen,numero_ordem) JOIN car c USING(id_car_norm)
 WHERE op.ano_emissao=2023 GROUP BY 1,2,3,4
),
eb AS (
 SELECT REGEXP_REPLACE(cpf_cnpj_embargado,'[^0-9]','') documento,id_municipio,id_embargo,area_ha,ano,
 (indicador_desembargado IS NULL OR indicador_desembargado!='S') ativo
 FROM `basedosdados.br_ibama_fiscalizacao.area_embargada`
 WHERE ano BETWEEN 1987 AND 2026 AND cpf_cnpj_embargado IS NOT NULL AND TRIM(cpf_cnpj_embargado)!=''
),
cf AS (
 SELECT fc.*,COUNTIF(eb.id_embargo IS NOT NULL)>0 alvo_embargo
 FROM fc LEFT JOIN pd USING(id_car_norm)
 LEFT JOIN eb ON eb.documento=pd.documento AND eb.id_municipio=fc.id_municipio
 GROUP BY fc.id_car_norm,fc.id_municipio,fc.sigla_uf,fc.area_car,fc.credito,fc.area_financiada
),
embargos_distintos AS (
 SELECT DISTINCT eb.id_embargo,eb.id_municipio,eb.area_ha
 FROM eb JOIN pd ON pd.documento=eb.documento
 JOIN cf ON cf.id_car_norm=pd.id_car_norm AND cf.id_municipio=eb.id_municipio
 WHERE cf.alvo_embargo
),
municipios AS (
 SELECT cf.id_municipio,cf.sigla_uf,COUNT(*) imoveis_com_embargo,SUM(cf.credito) credito_alocado,
 SUM(cf.area_financiada) area_financiada
 FROM cf WHERE cf.alvo_embargo GROUP BY 1,2
),
areas AS (
 SELECT id_municipio,SUM(area_ha) area_embargada FROM embargos_distintos GROUP BY 1
)
SELECT m.id_municipio,d.nome,m.sigla_uf,m.imoveis_com_embargo,m.credito_alocado,m.area_financiada,
 COALESCE(a.area_embargada,0) area_embargada
FROM municipios m LEFT JOIN areas a USING(id_municipio)
LEFT JOIN `basedosdados.br_bd_diretorios_brasil.municipio` d USING(id_municipio)
ORDER BY imoveis_com_embargo DESC,credito_alocado DESC LIMIT 15