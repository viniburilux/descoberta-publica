WITH car AS (
 SELECT DISTINCT REPLACE(id_imovel,'-','') id_car_norm
 FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao >= DATE '2026-06-02' AND data_extracao <= DATE '2026-08-04'
), p AS (
 SELECT REPLACE(id_car,'-','') id_car_norm
 FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
 WHERE ano_emissao=2023 AND id_car IS NOT NULL AND TRIM(id_car)!=''
)
SELECT COUNT(*) registros_sicor_com_car, COUNTIF(c.id_car_norm IS NOT NULL) registros_com_correspondencia,
 COUNTIF(c.id_car_norm IS NULL) registros_sem_correspondencia,
 SAFE_DIVIDE(COUNTIF(c.id_car_norm IS NOT NULL),COUNT(*)) taxa_correspondencia
FROM p LEFT JOIN car c USING(id_car_norm)