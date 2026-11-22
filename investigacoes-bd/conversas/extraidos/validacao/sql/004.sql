WITH l AS (
  SELECT ano_emissao, REPLACE(UPPER(TRIM(id_car)), '-', '') AS chave
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao IN (2019, 2023, 2026)
    AND id_car IS NOT NULL AND TRIM(CAST(id_car AS STRING)) != ''
), r AS (
  SELECT DISTINCT REPLACE(UPPER(TRIM(id_imovel)), '-', '') AS chave
  FROM `basedosdados.br_sfb_sicar.area_imovel`
)
SELECT
  l.ano_emissao,
  COUNT(*) AS registros_left,
  COUNT(DISTINCT l.chave) AS ids_distintos_left,
  COUNTIF(r.chave IS NOT NULL) AS registros_correspondentes,
  COUNT(DISTINCT IF(r.chave IS NOT NULL, l.chave, NULL)) AS ids_correspondentes,
  COUNTIF(r.chave IS NULL) AS registros_sem_correspondencia
FROM l LEFT JOIN r USING (chave)
GROUP BY l.ano_emissao ORDER BY l.ano_emissao;