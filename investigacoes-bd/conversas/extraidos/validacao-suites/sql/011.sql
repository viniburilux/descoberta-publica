-- 02_duplicidade | ibama_autos_embargos
WITH l AS (
  SELECT COUNT(*) AS registros, COUNT(DISTINCT id_auto) AS chaves_distintas
  FROM `basedosdados.br_ibama_fiscalizacao.auto_infracao` WHERE ano >= 1977
), r AS (
  SELECT COUNT(*) AS registros, COUNT(DISTINCT id_auto) AS chaves_distintas
  FROM `basedosdados.br_ibama_fiscalizacao.area_embargada` 
)
SELECT 'left' AS lado, registros, chaves_distintas,
       registros - chaves_distintas AS chaves_repetidas FROM l
UNION ALL
SELECT 'right', registros, chaves_distintas,
       registros - chaves_distintas FROM r;