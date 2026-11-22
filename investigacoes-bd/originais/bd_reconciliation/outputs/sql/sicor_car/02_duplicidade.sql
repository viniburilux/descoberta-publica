-- 02_duplicidade | sicor_car
WITH l AS (
  SELECT COUNT(*) AS registros, COUNT(DISTINCT id_car) AS chaves_distintas
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade` WHERE ano_emissao IN (2019, 2023, 2026)
), r AS (
  SELECT COUNT(*) AS registros, COUNT(DISTINCT id_imovel) AS chaves_distintas
  FROM `basedosdados.br_sfb_sicar.area_imovel` 
)
SELECT 'left' AS lado, registros, chaves_distintas,
       registros - chaves_distintas AS chaves_repetidas FROM l
UNION ALL
SELECT 'right', registros, chaves_distintas,
       registros - chaves_distintas FROM r;
