SELECT 'car' origem, id_imovel AS id, LENGTH(id_imovel) AS tamanho
FROM `basedosdados.br_sfb_sicar.area_imovel`
WHERE data_extracao='2026-08-04'
  AND id_imovel IS NOT NULL
LIMIT 5
UNION ALL
SELECT 'sicor' origem, id_car AS id, LENGTH(id_car) AS tamanho
FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
WHERE ano_emissao=2026
  AND id_car IS NOT NULL
LIMIT 5