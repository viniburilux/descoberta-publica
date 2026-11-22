WITH base AS (
  SELECT DISTINCT
    p.id_car,
    CONCAT(SUBSTR(p.id_car, 1, 2), '-', SUBSTR(p.id_car, 3, 7), '-', SUBSTR(p.id_car, 10)) AS id_car_formatado
  FROM `basedosdados.br_bcb_sicor.operacao` AS o
  JOIN `basedosdados.br_bcb_sicor.empreendimento` AS e USING (id_empreendimento)
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` AS f USING (id_fonte_recurso)
  JOIN `basedosdados.br_bcb_sicor.recurso_publico_propriedade` AS p
    ON o.id_referencia_bacen = p.id_referencia_bacen
   AND o.numero_ordem = p.numero_ordem
   AND p.ano_emissao = 2022
  WHERE o.ano_emissao = 2022
    AND e.finalidade = 'Investimento'
    AND f.indicador_recurso_publico = '1'
    AND p.id_car IS NOT NULL
), car_janela AS (
  SELECT DISTINCT id_imovel
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
), car_maxima AS (
  SELECT DISTINCT id_imovel
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao = '2026-08-04'
), checks AS (
  SELECT
    b.id_car,
    EXISTS (SELECT 1 FROM car_janela c WHERE c.id_imovel = b.id_car_formatado) AS ligado_formatado,
    EXISTS (SELECT 1 FROM car_janela c WHERE REPLACE(UPPER(c.id_imovel), '-', '') = REPLACE(UPPER(b.id_car), '-', '')) AS ligado_replace,
    EXISTS (SELECT 1 FROM car_maxima c WHERE c.id_imovel = b.id_car_formatado) AS maxima_formatado
  FROM base b
), connected_total AS (
  SELECT SUM(SAFE_DIVIDE(o.valor_parcela_credito, n.n_car)) AS valor_conectado
  FROM (
    SELECT DISTINCT
      o.id_referencia_bacen,
      o.numero_ordem,
      o.valor_parcela_credito,
      CONCAT(SUBSTR(p.id_car, 1, 2), '-', SUBSTR(p.id_car, 3, 7), '-', SUBSTR(p.id_car, 10)) AS id_car_formatado
    FROM `basedosdados.br_bcb_sicor.operacao` AS o
    JOIN `basedosdados.br_bcb_sicor.empreendimento` AS e USING (id_empreendimento)
    JOIN `basedosdados.br_bcb_sicor.fonte_recurso` AS f USING (id_fonte_recurso)
    JOIN `basedosdados.br_bcb_sicor.recurso_publico_propriedade` AS p
      ON o.id_referencia_bacen = p.id_referencia_bacen
     AND o.numero_ordem = p.numero_ordem
     AND p.ano_emissao = 2022
    WHERE o.ano_emissao = 2022
      AND e.finalidade = 'Investimento'
      AND f.indicador_recurso_publico = '1'
      AND p.id_car IS NOT NULL
  ) AS o
  JOIN car_janela c ON o.id_car_formatado = c.id_imovel
  JOIN (
    SELECT id_referencia_bacen, numero_ordem, COUNT(*) AS n_car
    FROM (
      SELECT DISTINCT
        o.id_referencia_bacen,
        o.numero_ordem,
        CONCAT(SUBSTR(p.id_car, 1, 2), '-', SUBSTR(p.id_car, 3, 7), '-', SUBSTR(p.id_car, 10)) AS id_car_formatado
      FROM `basedosdados.br_bcb_sicor.operacao` AS o
      JOIN `basedosdados.br_bcb_sicor.empreendimento` AS e USING (id_empreendimento)
      JOIN `basedosdados.br_bcb_sicor.fonte_recurso` AS f USING (id_fonte_recurso)
      JOIN `basedosdados.br_bcb_sicor.recurso_publico_propriedade` AS p
        ON o.id_referencia_bacen = p.id_referencia_bacen
       AND o.numero_ordem = p.numero_ordem
       AND p.ano_emissao = 2022
      WHERE o.ano_emissao = 2022
        AND e.finalidade = 'Investimento'
        AND f.indicador_recurso_publico = '1'
        AND p.id_car IS NOT NULL
    )
    GROUP BY id_referencia_bacen, numero_ordem
  ) n USING (id_referencia_bacen, numero_ordem)
), total_sem_car AS (
  SELECT SUM(o.valor_parcela_credito) AS valor_sem_car
  FROM `basedosdados.br_bcb_sicor.operacao` AS o
  JOIN `basedosdados.br_bcb_sicor.empreendimento` AS e USING (id_empreendimento)
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` AS f USING (id_fonte_recurso)
  WHERE o.ano_emissao = 2022
    AND e.finalidade = 'Investimento'
    AND f.indicador_recurso_publico = '1'
)
SELECT 'NORMALIZACAO' AS checagem,
  COUNT(*) AS id_car_distintos,
  COUNTIF(ligado_formatado) AS ligados_por_concat,
  COUNTIF(ligado_replace) AS ligados_por_replace,
  COUNTIF(ligado_formatado AND NOT ligado_replace) AS concat_sem_replace,
  COUNTIF(ligado_replace AND NOT ligado_formatado) AS replace_sem_concat,
  CAST(NULL AS FLOAT64) AS valor,
  CAST(NULL AS FLOAT64) AS fracao
FROM checks
UNION ALL
SELECT 'SNAPSHOTS',
  COUNTIF(ligado_formatado),
  COUNTIF(maxima_formatado),
  COUNTIF(ligado_formatado AND NOT maxima_formatado),
  NULL, NULL, NULL, NULL
FROM checks
UNION ALL
SELECT 'ESCOPO', NULL, NULL, NULL, NULL, NULL, s.valor_sem_car, SAFE_DIVIDE(c.valor_conectado, s.valor_sem_car)
FROM total_sem_car s CROSS JOIN connected_total c