-- 05_residuos | sicor_car | amostra e contagem dos nao correspondentes
WITH l AS (
  SELECT DISTINCT REPLACE(UPPER(TRIM(id_car)), '-', '') AS __k FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade` WHERE ano_emissao IN (2019, 2023, 2026)
), r AS (
  SELECT DISTINCT REPLACE(UPPER(TRIM(id_imovel)), '-', '') AS __k FROM `basedosdados.br_sfb_sicar.area_imovel` 
)
SELECT COUNT(*) AS ids_left_sem_correspondencia
FROM l LEFT JOIN r USING (__k)
WHERE r.__k IS NULL;
