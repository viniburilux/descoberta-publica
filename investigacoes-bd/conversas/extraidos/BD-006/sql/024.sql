SELECT
  ano_emissao,
  LENGTH(TRIM(id_car)) AS comprimento,
  COUNT(*) AS registros,
  COUNTIF(REGEXP_CONTAINS(TRIM(id_car), r'^[A-Za-z]{2}[0-9]{7}[A-Fa-f0-9]{32}$')) AS formato_sem_hifen,
  COUNTIF(REGEXP_CONTAINS(TRIM(id_car), r'^[A-Za-z]{2}-[0-9]{7}-[A-Fa-f0-9]{32}$')) AS formato_com_hifen,
  COUNTIF(REGEXP_CONTAINS(TRIM(id_car), r'[^A-Za-z0-9]')) AS com_caractere_nao_alfanumerico
FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
WHERE ano_emissao BETWEEN 2017 AND 2026
  AND id_car IS NOT NULL
  AND TRIM(id_car) != ''
GROUP BY ano_emissao, comprimento
ORDER BY ano_emissao, comprimento