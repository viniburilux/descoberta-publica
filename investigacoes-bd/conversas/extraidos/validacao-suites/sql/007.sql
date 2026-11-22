-- 02_duplicidade | rais_cnae
WITH l AS (
  SELECT COUNT(*) AS registros, COUNT(DISTINCT cnae_2_subclasse) AS chaves_distintas
  FROM `basedosdados.br_me_rais.microdados_estabelecimentos` WHERE ano IN (2023)
), r AS (
  SELECT COUNT(*) AS registros, COUNT(DISTINCT subclasse) AS chaves_distintas
  FROM `basedosdados.br_bd_diretorios_brasil.cnae_2` 
)
SELECT 'left' AS lado, registros, chaves_distintas,
       registros - chaves_distintas AS chaves_repetidas FROM l
UNION ALL
SELECT 'right', registros, chaves_distintas,
       registros - chaves_distintas FROM r;