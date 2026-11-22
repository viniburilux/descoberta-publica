WITH car AS (
  SELECT id_imovel, id_municipio, sigla_uf, data_extracao
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao = '2026-08-04'
), s AS (
  SELECT id_car, id_referencia_bacen, numero_ordem, ano_emissao
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2026
), car_keys AS (
  SELECT id_imovel, COUNT(*) AS n
  FROM car WHERE id_imovel IS NOT NULL GROUP BY id_imovel
), sicor_keys AS (
  SELECT id_car, COUNT(*) AS n
  FROM s WHERE id_car IS NOT NULL GROUP BY id_car
), matched AS (
  SELECT s.id_car, s.id_referencia_bacen, s.numero_ordem, c.id_municipio, c.sigla_uf
  FROM s INNER JOIN car c ON s.id_car = c.id_imovel
), unmatched AS (
  SELECT s.id_car, s.id_referencia_bacen, s.numero_ordem
  FROM s LEFT JOIN car c ON s.id_car = c.id_imovel
  WHERE c.id_imovel IS NULL
), metrics AS (
  SELECT 'car_registros_snapshot' AS metrica, CAST(COUNT(*) AS STRING) AS valor FROM car
  UNION ALL SELECT 'sicor_registros_2026', CAST(COUNT(*) AS STRING) FROM s
  UNION ALL SELECT 'car_id_imovel_nulo', CAST(COUNTIF(id_imovel IS NULL) AS STRING) FROM car
  UNION ALL SELECT 'sicor_id_car_nulo', CAST(COUNTIF(id_car IS NULL) AS STRING) FROM s
  UNION ALL SELECT 'car_id_imovel_distintos', CAST(COUNT(*) AS STRING) FROM car_keys
  UNION ALL SELECT 'sicor_id_car_distintos', CAST(COUNT(*) AS STRING) FROM sicor_keys
  UNION ALL SELECT 'car_ids_duplicados', CAST(COUNTIF(n > 1) AS STRING) FROM car_keys
  UNION ALL SELECT 'sicor_ids_duplicados', CAST(COUNTIF(n > 1) AS STRING) FROM sicor_keys
  UNION ALL SELECT 'sicor_registros_com_car', CAST(COUNT(*) AS STRING) FROM matched
  UNION ALL SELECT 'sicor_registros_sem_car', CAST(COUNT(*) AS STRING) FROM unmatched
  UNION ALL SELECT 'proporcao_sicor_com_car', CAST(SAFE_DIVIDE(COUNT(*), (SELECT COUNT(*) FROM s)) AS STRING) FROM matched
  UNION ALL SELECT 'proporcao_sicor_sem_car', CAST(SAFE_DIVIDE(COUNT(*), (SELECT COUNT(*) FROM s)) AS STRING) FROM unmatched
  UNION ALL SELECT 'imoveis_car_com_sicor', CAST(COUNT(DISTINCT id_municipio || '|' || sigla_uf) AS STRING) FROM matched
)
SELECT 'metrica' AS tipo, metrica AS item, valor, CAST(NULL AS STRING) AS id_1, CAST(NULL AS STRING) AS id_2
FROM metrics
UNION ALL
SELECT 'exemplo_correspondente', 'id_car_id_imovel', id_car, id_referencia_bacen
FROM matched
UNION ALL
SELECT 'exemplo_sem_correspondencia', 'id_car_sem_imovel', id_car, id_referencia_bacen
FROM unmatched
ORDER BY tipo, item, id_1
LIMIT 60