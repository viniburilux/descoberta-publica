WITH car_ids AS (
  SELECT DISTINCT REPLACE(UPPER(TRIM(id_imovel)), '-', '') id_norm
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao IN ('2026-06-02','2026-08-01','2026-08-02','2026-08-03','2026-08-04') AND id_imovel IS NOT NULL
), s AS (
  SELECT REPLACE(UPPER(TRIM(id_car)), '-', '') id_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao=2026 AND id_car IS NOT NULL AND TRIM(id_car) != ''
), unmatched AS (
  SELECT s.id_norm
  FROM s LEFT JOIN car_ids c USING(id_norm)
  WHERE c.id_norm IS NULL
)
SELECT
  LENGTH(id_norm) AS comprimento,
  SUBSTR(id_norm,1,2) AS uf_prefixo,
  SUBSTR(id_norm,3,7) AS municipio_embutido,
  COUNT(*) AS registros,
  COUNT(DISTINCT id_norm) AS ids_distintos,
  COUNTIF(REGEXP_CONTAINS(id_norm,r'^[A-Z]{2}[0-9]{7}[A-F0-9]{32}$')) AS formato_estrutural_valido
FROM unmatched
GROUP BY comprimento,uf_prefixo,municipio_embutido
ORDER BY registros DESC
LIMIT 50