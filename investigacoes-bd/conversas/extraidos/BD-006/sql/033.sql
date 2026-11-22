WITH car_municipios AS (
  SELECT DISTINCT id_municipio
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao IN ('2026-06-02','2026-08-01','2026-08-02','2026-08-03','2026-08-04')
    AND id_municipio IS NOT NULL
), car_ids AS (
  SELECT DISTINCT REPLACE(UPPER(TRIM(id_imovel)), '-', '') AS id_norm
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao IN ('2026-06-02','2026-08-01','2026-08-02','2026-08-03','2026-08-04')
    AND id_imovel IS NOT NULL
), sicor_unmatched AS (
  SELECT DISTINCT
    REPLACE(UPPER(TRIM(s.id_car)), '-', '') AS id_norm,
    SUBSTR(REPLACE(UPPER(TRIM(s.id_car)), '-', ''),3,7) AS id_municipio
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade` s
  LEFT JOIN car_ids c
    ON REPLACE(UPPER(TRIM(s.id_car)), '-', '') = c.id_norm
  WHERE s.ano_emissao = 2026
    AND s.id_car IS NOT NULL
    AND TRIM(s.id_car) != ''
    AND c.id_norm IS NULL
)
SELECT
  COUNT(*) AS ids_sicor_nao_encontrados,
  COUNTIF(cm.id_municipio IS NOT NULL) AS ids_em_municipio_com_outros_car,
  COUNTIF(cm.id_municipio IS NULL) AS ids_em_municipio_sem_car,
  COUNT(DISTINCT id_municipio) AS municipios_dos_ids_nao_encontrados,
  COUNT(DISTINCT IF(cm.id_municipio IS NOT NULL,id_municipio,NULL)) AS municipios_com_outros_car
FROM sicor_unmatched u
LEFT JOIN car_municipios cm USING(id_municipio)