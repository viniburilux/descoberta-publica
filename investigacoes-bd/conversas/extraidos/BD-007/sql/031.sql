WITH car AS (
 SELECT REPLACE(id_imovel,'-','') id_car_norm,id_municipio,sigla_uf
 FROM `basedosdados.br_sfb_sicar.area_imovel` WHERE data_extracao>=DATE '2026-06-02' AND data_extracao<=DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
),pl AS (
 SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade` WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
),onum AS (SELECT id_referencia_bacen,numero_ordem,COUNT(*) n FROM pl GROUP BY 1,2),credit AS (
 SELECT c.id_municipio,c.sigla_uf,SUM(op.valor_parcela_credito/onum.n) credito
 FROM `basedosdados.br_bcb_sicor.operacao` op JOIN onum USING(id_referencia_bacen,numero_ordem) JOIN pl USING(id_referencia_bacen,numero_ordem) JOIN car c USING(id_car_norm)
 WHERE op.ano_emissao=2023 GROUP BY 1,2
),top20 AS (SELECT *,ROW_NUMBER() OVER(ORDER BY credito DESC) ranking FROM credit QUALIFY ranking<=20),
pop AS (SELECT id_municipio,populacao FROM `basedosdados.br_ibge_populacao.municipio` WHERE ano=2023),
pib AS (SELECT id_municipio,pib FROM `basedosdados.br_ibge_pib.municipio` WHERE ano=2023),
va AS (SELECT id_municipio,va_agropecuaria FROM `basedosdados.br_ibge_pib.municipio` WHERE ano=2021),
re AS (SELECT id_municipio,SUM(quantidade_vinculos_ativos) empregos_total,SUM(IF(SUBSTR(cnae_2,1,2) IN ('01','02','03'),quantidade_vinculos_ativos,0)) empregos_agro FROM `basedosdados.br_me_rais.microdados_estabelecimentos` WHERE ano=2023 GROUP BY id_municipio),
rs AS (SELECT id_municipio,AVG(valor_remuneracao_media) remuneracao_media FROM `basedosdados.br_me_rais.microdados_vinculos` WHERE ano=2023 AND vinculo_ativo_3112='1' GROUP BY id_municipio),
sc AS (SELECT id_municipio,SUM(IF(id_conta_bd='1.1.1.0.0.00.00.00' AND estagio_bd='Receitas Brutas Realizadas',valor,0)) receita_tributaria,SUM(IF(id_conta_bd='1.1.7.0.0.00.00.00' AND estagio_bd='Receitas Brutas Realizadas',valor,0)) transferencias FROM `basedosdados.br_me_siconfi.municipio_receitas_orcamentarias` WHERE ano=2023 GROUP BY id_municipio),
nasc AS (SELECT id_municipio_residencia id_municipio,COUNT(*) nascidos FROM `basedosdados.br_ms_sinasc.microdados` WHERE ano=2023 GROUP BY 1),
ob AS (SELECT id_municipio_residencia id_municipio,COUNT(*) obitos FROM `basedosdados.br_ms_sim.microdados` WHERE ano=2023 AND idade<1 GROUP BY 1),
sa AS (SELECT n.id_municipio,SAFE_MULTIPLY(SAFE_DIVIDE(ob.obitos,n.nascidos),1000) mortalidade_infantil FROM nasc n LEFT JOIN ob USING(id_municipio)),
idb AS (SELECT id_municipio,MAX(IF(rede='publica' AND ensino='fundamental' AND anos_escolares='iniciais (1-5)',ideb,NULL)) ideb_iniciais,MAX(IF(rede='publica' AND ensino='fundamental' AND anos_escolares='finais (6-9)',ideb,NULL)) ideb_finais FROM `basedosdados.br_inep_ideb.municipio` WHERE ano=2023 GROUP BY id_municipio)
SELECT t.ranking,d.nome,t.sigla_uf,t.credito,pop.populacao,SAFE_DIVIDE(t.credito,pop.populacao) credito_per_capita,pib.pib,SAFE_DIVIDE(pib.pib,pop.populacao) pib_per_capita,va.va_agropecuaria,SAFE_DIVIDE(va.va_agropecuaria,pop.populacao) va_agro_per_capita,re.empregos_total,re.empregos_agro,SAFE_DIVIDE(re.empregos_agro,re.empregos_total) participacao_agro_emprego,rs.remuneracao_media,sc.receita_tributaria,sc.transferencias,SAFE_DIVIDE(sc.receita_tributaria,pop.populacao) tributo_per_capita,SAFE_DIVIDE(sc.transferencias,pop.populacao) transferencia_per_capita,sa.mortalidade_infantil,idb.ideb_iniciais,idb.ideb_finais
FROM top20 t LEFT JOIN pop USING(id_municipio) LEFT JOIN pib USING(id_municipio) LEFT JOIN va USING(id_municipio) LEFT JOIN re USING(id_municipio) LEFT JOIN rs USING(id_municipio) LEFT JOIN sc USING(id_municipio) LEFT JOIN sa USING(id_municipio) LEFT JOIN idb USING(id_municipio) LEFT JOIN `basedosdados.br_bd_diretorios_brasil.municipio` d USING(id_municipio) ORDER BY t.ranking