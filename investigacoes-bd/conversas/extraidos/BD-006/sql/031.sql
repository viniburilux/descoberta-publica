WITH car AS (
  SELECT DISTINCT id_imovel
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao='2026-08-04' AND id_imovel IS NOT NULL
), s AS (
  SELECT id_car
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao=2026 AND id_car IS NOT NULL AND TRIM(id_car) != ''
), tests AS (
  SELECT 'literal' transformacao, s.id_car, c.id_imovel
  FROM s LEFT JOIN car c ON s.id_car = c.id_imovel
  UNION ALL
  SELECT 'trim_upper', s.id_car, c.id_imovel
  FROM s LEFT JOIN car c ON UPPER(TRIM(s.id_car)) = UPPER(TRIM(c.id_imovel))
  UNION ALL
  SELECT 'remove_nao_alfanumericos', s.id_car, c.id_imovel
  FROM s LEFT JOIN car c ON REGEXP_REPLACE(UPPER(TRIM(s.id_car)), r'[^A-Z0-9]', '') = REGEXP_REPLACE(UPPER(TRIM(c.id_imovel)), r'[^A-Z0-9]', '')
  UNION ALL
  SELECT 'remove_hifens', s.id_car, c.id_imovel
  FROM s LEFT JOIN car c ON REPLACE(UPPER(TRIM(s.id_car)), '-', '') = REPLACE(UPPER(TRIM(c.id_imovel)), '-', '')
)
SELECT
  transformacao,
  COUNT(*) AS registros_sicor,
  COUNTIF(id_imovel IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(id_imovel IS NOT NULL,id_car,NULL)) AS ids_correspondentes,
  SAFE_DIVIDE(COUNTIF(id_imovel IS NOT NULL),COUNT(*)) AS cobertura_registros
FROM tests
GROUP BY transformacao
ORDER BY transformacao