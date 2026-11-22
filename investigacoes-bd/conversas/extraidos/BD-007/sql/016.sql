WITH
car AS (
  SELECT REPLACE(id_imovel,'-','') AS id_car_norm,id_municipio,sigla_uf,area
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao >= DATE '2026-06-02' AND data_extracao <= DATE '2026-08-04'
  QUALIFY ROW_NUMBER() OVER(PARTITION BY REPLACE(id_imovel,'-','') ORDER BY data_extracao DESC)=1
),
prop_links AS (
  SELECT DISTINCT id_referencia_bacen,numero_ordem,REPLACE(id_car,'-','') AS id_car_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
),
prop_docs AS (
  SELECT DISTINCT REPLACE(id_car,'-','') AS id_car_norm, REGEXP_REPLACE(cpf,'[^0-9]','') AS documento
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!='' AND cpf IS NOT NULL AND TRIM(cpf)!=''
  UNION DISTINCT
  SELECT DISTINCT REPLACE(id_car,'-','') AS id_car_norm, REGEXP_REPLACE(cnpj_basico,'[^0-9]','') AS documento
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!='' AND cnpj_basico IS NOT NULL AND TRIM(cnpj_basico)!=''
),
op_n AS (
  SELECT id_referencia_bacen,numero_ordem,COUNT(*) AS n_imoveis FROM prop_links GROUP BY 1,2
),
credito_car AS (
  SELECT c.id_car_norm,c.id_municipio,c.sigla_uf,c.area AS area_car,
    SUM(op.valor_parcela_credito / n.n_imoveis) AS credito,
    SUM(op.area_financiada / n.n_imoveis) AS area_financiada
  FROM `basedosdados.br_bcb_sicor.operacao` op
  JOIN op_n n USING(id_referencia_bacen,numero_ordem)
  JOIN prop_links p USING(id_referencia_bacen,numero_ordem)
  JOIN car c USING(id_car_norm)
  WHERE op.ano_emissao=2023
  GROUP BY 1,2,3,4
),
embargo_doc_mun AS (
  SELECT REGEXP_REPLACE(cpf_cnpj_embargado,'[^0-9]','') AS documento,id_municipio,
    COUNT(DISTINCT id_embargo) AS embargos,SUM(area_ha) AS area_embargada,
    COUNTIF(ano < 2023)>0 AS historico_pre_2023,
    COUNTIF(indicador_desembargado IS NULL OR indicador_desembargado!='S')>0 AS ativo
  FROM `basedosdados.br_ibama_fiscalizacao.area_embargada`
  WHERE ano BETWEEN 1987 AND 2026 AND cpf_cnpj_embargado IS NOT NULL AND TRIM(cpf_cnpj_embargado)!=''
  GROUP BY 1,2
),
car_flags AS (
  SELECT cc.*,COUNTIF(e.documento IS NOT NULL)>0 AS tem_embargo,
    LOGICAL_OR(COALESCE(e.ativo,FALSE)) AS embargo_ativo,
    LOGICAL_OR(COALESCE(e.historico_pre_2023,FALSE)) AS embargo_historico_pre_2023,
    SUM(COALESCE(e.area_embargada,0)) AS area_embargada_associada,
    SUM(COALESCE(e.embargos,0)) AS registros_embargo_associados
  FROM credito_car cc LEFT JOIN prop_docs d USING(id_car_norm)
  LEFT JOIN embargo_doc_mun e ON e.documento=d.documento AND e.id_municipio=cc.id_municipio
  GROUP BY cc.id_car_norm,cc.id_municipio,cc.sigla_uf,cc.area_car,cc.credito,cc.area_financiada
),
classificado AS (
  SELECT *, (COALESCE(embargo_ativo,FALSE) OR COALESCE(embargo_historico_pre_2023,FALSE)) AS alvo_embargo,
    SAFE_DIVIDE(area_financiada,area_car)>1 AS acima_100
  FROM car_flags
)
SELECT CASE WHEN acima_100 THEN 'area_financiada_acima_100pct' ELSE 'demais_imoveis' END AS grupo_area,
  COUNT(*) AS imoveis,COUNTIF(alvo_embargo) AS imoveis_com_embargo,
  COUNTIF(embargo_ativo) AS imoveis_com_embargo_ativo,
  COUNTIF(embargo_historico_pre_2023) AS imoveis_com_historico_pre_2023,
  SUM(credito) AS credito_alocado,SUM(area_financiada) AS area_financiada,
  SUM(area_embargada_associada) AS area_embargada_associada,
  SAFE_DIVIDE(COUNTIF(alvo_embargo),COUNT(*)) AS taxa_embargo
FROM classificado GROUP BY grupo_area ORDER BY grupo_area