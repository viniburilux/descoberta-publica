-- 01_chaves_nulas | ibama_autos_embargos
WITH l AS (
  SELECT COUNT(*) AS registros,
         COUNTIF(id_auto IS NULL OR TRIM(CAST(id_auto AS STRING)) = '') AS chave_vazia
  FROM `basedosdados.br_ibama_fiscalizacao.auto_infracao`
  WHERE ano >= 1977
), r AS (
  SELECT COUNT(*) AS registros,
         COUNTIF(id_auto IS NULL OR TRIM(CAST(id_auto AS STRING)) = '') AS chave_vazia
  FROM `basedosdados.br_ibama_fiscalizacao.area_embargada`
  
)
SELECT 'left' AS lado, registros, chave_vazia FROM l
UNION ALL
SELECT 'right', registros, chave_vazia FROM r;