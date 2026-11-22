-- 01_chaves_nulas | sicor_car
WITH l AS (
  SELECT COUNT(*) AS registros,
         COUNTIF(id_car IS NULL OR TRIM(CAST(id_car AS STRING)) = '') AS chave_vazia
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao IN (2019, 2023, 2026)
), r AS (
  SELECT COUNT(*) AS registros,
         COUNTIF(id_imovel IS NULL OR TRIM(CAST(id_imovel AS STRING)) = '') AS chave_vazia
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  
)
SELECT 'left' AS lado, registros, chave_vazia FROM l
UNION ALL
SELECT 'right', registros, chave_vazia FROM r;
