WITH car AS (
 SELECT REPLACE(id_imovel,'-','') id_car_norm,id_imovel,id_municipio,sigla_uf,area,modulos_fiscais,data_criacao,data_atualizacao
 FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao>=DATE '2026-06-02' AND data_extracao<=DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
),pl AS (
 SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
),n AS (
 SELECT id_referencia_bacen,numero_ordem,COUNT(*) n_imoveis FROM pl GROUP BY 1,2
),p AS (
 SELECT c.id_car_norm,c.id_imovel,c.id_municipio,c.sigla_uf,c.area,c.modulos_fiscais,c.data_criacao,c.data_atualizacao,
 SUM(op.valor_parcela_credito/n.n_imoveis) credito_alocado,
 SUM(op.area_financiada/n.n_imoveis) area_financiada_alocada,
 COUNT(DISTINCT op.id_referencia_bacen) operacoes,
 COUNT(*) linhas_operacao,
 COUNT(DISTINCT op.id_empreendimento) empreendimentos
 FROM `basedosdados.br_bcb_sicor.operacao` op
 JOIN n USING(id_referencia_bacen,numero_ordem)
 JOIN pl USING(id_referencia_bacen,numero_ordem)
 JOIN car c USING(id_car_norm)
 WHERE op.ano_emissao=2023
 GROUP BY 1,2,3,4,5,6,7,8
)
SELECT p.id_imovel,d.nome AS municipio,p.sigla_uf,p.area AS area_car_ha,p.modulos_fiscais,
 p.area_financiada_alocada,p.credito_alocado,
 SAFE_DIVIDE(p.area_financiada_alocada,p.area) AS razao_area,
 p.operacoes,p.linhas_operacao,p.empreendimentos,p.data_criacao,p.data_atualizacao
FROM p
LEFT JOIN `basedosdados.br_bd_diretorios_brasil.municipio` d USING(id_municipio)
WHERE p.area < 1 AND p.area > 0 AND p.area_financiada_alocada > p.area
ORDER BY razao_area DESC
LIMIT 50