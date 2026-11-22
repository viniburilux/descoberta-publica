-- 05_residuos | ibama_autos_embargos | amostra e contagem dos nao correspondentes
WITH l AS (
  SELECT DISTINCT id_auto AS __k FROM `basedosdados.br_ibama_fiscalizacao.auto_infracao` WHERE ano >= 1977
), r AS (
  SELECT DISTINCT id_auto AS __k FROM `basedosdados.br_ibama_fiscalizacao.area_embargada` 
)
SELECT COUNT(*) AS ids_left_sem_correspondencia
FROM l LEFT JOIN r USING (__k)
WHERE r.__k IS NULL;