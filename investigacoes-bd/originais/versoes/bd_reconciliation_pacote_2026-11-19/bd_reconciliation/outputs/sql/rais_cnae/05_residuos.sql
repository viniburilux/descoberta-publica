-- 05_residuos | rais_cnae | amostra e contagem dos nao correspondentes
WITH l AS (
  SELECT DISTINCT cnae_2_subclasse AS __k FROM `basedosdados.br_me_rais.microdados_estabelecimentos` WHERE ano IN (2023)
), r AS (
  SELECT DISTINCT subclasse AS __k FROM `basedosdados.br_bd_diretorios_brasil.cnae_2` 
)
SELECT COUNT(*) AS ids_left_sem_correspondencia
FROM l LEFT JOIN r USING (__k)
WHERE r.__k IS NULL;
