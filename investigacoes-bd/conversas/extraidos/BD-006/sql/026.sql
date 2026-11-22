WITH car AS (
  SELECT
    data_extracao,
    sigla_uf,
    REPLACE(UPPER(TRIM(id_imovel)), '-', '') AS id_car_normalizado
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao IN ('2026-06-02','2026-08-01','2026-08-02','2026-08-03','2026-08-04')
    AND id_imovel IS NOT NULL
), car_ids AS (
  SELECT DISTINCT id_car_normalizado
  FROM car
), sicor AS (
  SELECT
    ano_emissao,
    SUBSTR(REPLACE(UPPER(TRIM(id_car)), '-', ''), 1, 2) AS uf_prefixo,
    REPLACE(UPPER(TRIM(id_car)), '-', '') AS id_car_normalizado,
    id_car
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao IN (2019, 2023, 2026)
    AND id_car IS NOT NULL
    AND TRIM(id_car) != ''
), por_ano AS (
  SELECT
    ano_emissao,
    COUNT(*) AS registros_id_car,
    COUNT(DISTINCT id_car_normalizado) AS ids_distintos,
    COUNTIF(c.id_car_normalizado IS NOT NULL) AS registros_com_algum_snapshot,
    COUNT(DISTINCT IF(c.id_car_normalizado IS NOT NULL, s.id_car_normalizado, NULL)) AS ids_com_algum_snapshot,
    COUNTIF(c.id_car_normalizado IS NULL) AS registros_sem_snapshot
  FROM sicor s
  LEFT JOIN car_ids c USING (id_car_normalizado)
  GROUP BY ano_emissao
), por_snapshot AS (
  SELECT
    s.ano_emissao,
    c.data_extracao,
    COUNT(*) AS registros_com_snapshot,
    COUNT(DISTINCT s.id_car_normalizado) AS ids_com_snapshot
  FROM sicor s
  JOIN car c USING (id_car_normalizado)
  GROUP BY s.ano_emissao, c.data_extracao
)
SELECT 'por_ano' AS tipo,
  CAST(ano_emissao AS STRING) AS grupo,
  CAST(registros_id_car AS STRING) AS registros_id_car,
  CAST(ids_distintos AS STRING) AS ids_distintos,
  CAST(registros_com_algum_snapshot AS STRING) AS registros_com_snapshot,
  CAST(ids_com_algum_snapshot AS STRING) AS ids_com_snapshot,
  CAST(registros_sem_snapshot AS STRING) AS registros_sem_snapshot,
  CAST(NULL AS STRING) AS data_extracao,
  CAST(NULL AS STRING) AS registros_snapshot
FROM por_ano
UNION ALL
SELECT 'por_snapshot', CAST(ano_emissao AS STRING), CAST(NULL AS STRING), CAST(NULL AS STRING), CAST(registros_com_snapshot AS STRING), CAST(ids_com_snapshot AS STRING), CAST(NULL AS STRING), data_extracao, CAST(registros_com_snapshot AS STRING)
FROM por_snapshot
ORDER BY tipo, grupo, data_extracao