-- 01_chaves_nulas | rais_cnae
WITH l AS (
  SELECT COUNT(*) AS registros,
         COUNTIF(cnae_2_subclasse IS NULL OR TRIM(CAST(cnae_2_subclasse AS STRING)) = '') AS chave_vazia
  FROM `basedosdados.br_me_rais.microdados_estabelecimentos`
  WHERE ano IN (2023)
), r AS (
  SELECT COUNT(*) AS registros,
         COUNTIF(subclasse IS NULL OR TRIM(CAST(subclasse AS STRING)) = '') AS chave_vazia
  FROM `basedosdados.br_bd_diretorios_brasil.cnae_2`
  
)
SELECT 'left' AS lado, registros, chave_vazia FROM l
UNION ALL
SELECT 'right', registros, chave_vazia FROM r;
