WITH
car AS (
 SELECT REPLACE(id_imovel,'-','') id_car_norm,id_municipio,sigla_uf,area
 FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao>=DATE '2026-06-02' AND data_extracao<=DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
),pl AS (
 SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
),onum AS (SELECT id_referencia_bacen,numero_ordem,COUNT(*) n FROM pl GROUP BY 1,2),
fc AS (
 SELECT c.id_car_norm,c.id_municipio,c.area area_car,
 SUM(op.area_financiada/onum.n) area_financiada
 FROM `basedosdados.br_bcb_sicor.operacao` op JOIN onum USING(id_referencia_bacen,numero_ordem)
 JOIN pl USING(id_referencia_bacen,numero_ordem) JOIN car c USING(id_car_norm)
 WHERE op.ano_emissao=2023 GROUP BY 1,2,3
),
grupos AS (SELECT *,SAFE_DIVIDE(area_financiada,area_car)>1 acima_100 FROM fc),
prodes AS (
 SELECT id_municipio,
  SUM(IF(ano=2023,desmatado,0))-SUM(IF(ano=2019,desmatado,0)) AS desmatamento_2020_2023_km2
 FROM `basedosdados.br_inpe_prodes.municipio_bioma`
 WHERE ano IN (2019,2023)
 GROUP BY id_municipio
)
SELECT CASE WHEN g.acima_100 THEN 'area_financiada_acima_100pct' ELSE 'demais_imoveis' END grupo_area,
 COUNT(*) imoveis,
 COUNTIF(p.id_municipio IS NOT NULL) imoveis_com_prodes,
 COUNTIF(COALESCE(p.desmatamento_2020_2023_km2,0)>0) imoveis_em_municipio_com_aumento_prodes,
 AVG(COALESCE(p.desmatamento_2020_2023_km2,0)) media_desmatamento_municipal_km2,
 SUM(COALESCE(p.desmatamento_2020_2023_km2,0)) desmatamento_municipal_repetido_km2,
 SAFE_DIVIDE(COUNTIF(COALESCE(p.desmatamento_2020_2023_km2,0)>0),COUNT(*)) taxa_municipio_com_aumento_prodes
FROM grupos g LEFT JOIN prodes p USING(id_municipio)
GROUP BY grupo_area ORDER BY grupo_area