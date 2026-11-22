SELECT
  SUBSTR(id_car, 3, 7) AS id_municipio_car,
  SUM(valor) AS valor_total_financiado,
  COUNT(DISTINCT id_referencia_bacen) AS numero_operacoes
FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
WHERE ano_emissao = 2023
GROUP BY id_municipio_car
ORDER BY valor_total_financiado DESC
LIMIT 20