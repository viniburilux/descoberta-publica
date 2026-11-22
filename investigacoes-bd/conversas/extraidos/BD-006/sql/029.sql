WITH car_ids AS (
  SELECT DISTINCT REPLACE(UPPER(TRIM(id_imovel)), '-', '') AS id_car_normalizado
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao IN ('2026-06-02','2026-08-01','2026-08-02','2026-08-03','2026-08-04') AND id_imovel IS NOT NULL
), s AS (
  SELECT ano_emissao,SUBSTR(REPLACE(UPPER(TRIM(id_car)), '-', ''),1,2) AS uf_prefixo,REPLACE(UPPER(TRIM(id_car)), '-', '') AS id_car_normalizado
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao IN (2019,2023,2026) AND id_car IS NOT NULL AND TRIM(id_car) != ''
), agg AS (
  SELECT s.ano_emissao,s.uf_prefixo,COUNT(*) registros_sicor,COUNT(DISTINCT s.id_car_normalizado) ids_sicor,COUNTIF(c.id_car_normalizado IS NOT NULL) registros_com_car,COUNT(DISTINCT IF(c.id_car_normalizado IS NOT NULL,s.id_car_normalizado,NULL)) ids_com_car
  FROM s LEFT JOIN car_ids c USING(id_car_normalizado)
  GROUP BY s.ano_emissao,s.uf_prefixo
)
SELECT ano_emissao,uf_prefixo,registros_sicor,ids_sicor,registros_com_car,ids_com_car,SAFE_DIVIDE(registros_com_car,registros_sicor) cobertura_registros,SAFE_DIVIDE(ids_com_car,ids_sicor) cobertura_ids
FROM agg ORDER BY ano_emissao,cobertura_registros,uf_prefixo