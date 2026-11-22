-- Crédito rural por município: caso 2022 (finalidade Investimento), verificado no chatbot da Base dos Dados em 19/11/2026.
-- Cânone 2023 (todas as finalidades): mesmo padrão, trocando p.ano_emissao/o.ano_emissao para 2023 e removendo o filtro de finalidade.
-- Tabelas públicas: basedosdados.br_bcb_sicor.*, basedosdados.br_sfb_sicar.area_imovel, basedosdados.br_bd_diretorios_brasil.municipio.

WITH operacoes AS (
  SELECT
    o.id_referencia_bacen,
    o.numero_ordem,
    o.valor_parcela_credito,
    CONCAT(SUBSTR(p.id_car, 1, 2), '-', SUBSTR(p.id_car, 3, 7), '-', SUBSTR(p.id_car, 10)) AS id_car
  FROM basedosdados.br_bcb_sicor.operacao AS o
  JOIN basedosdados.br_bcb_sicor.empreendimento AS e
    ON o.id_empreendimento = e.id_empreendimento
  JOIN basedosdados.br_bcb_sicor.fonte_recurso AS f
    ON o.id_fonte_recurso = f.id_fonte_recurso
  JOIN basedosdados.br_bcb_sicor.recurso_publico_propriedade AS p
    ON o.id_referencia_bacen = p.id_referencia_bacen
   AND o.numero_ordem = p.numero_ordem
   AND p.ano_emissao = 2022
  WHERE o.ano_emissao = 2022
    AND e.finalidade = 'Investimento'
    AND f.indicador_recurso_publico = '1'
    AND p.id_car IS NOT NULL
), operacoes_car AS (
  SELECT DISTINCT id_referencia_bacen, numero_ordem, valor_parcela_credito, id_car
  FROM operacoes
), rateio AS (
  SELECT
    oc.id_referencia_bacen,
    oc.numero_ordem,
    oc.id_car,
    SAFE_DIVIDE(oc.valor_parcela_credito, COUNT(*) OVER (PARTITION BY oc.id_referencia_bacen, oc.numero_ordem)) AS valor_rateado
  FROM operacoes_car AS oc
), car_atual AS (
  SELECT id_imovel, id_municipio
  FROM basedosdados.br_sfb_sicar.area_imovel
  WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
  QUALIFY ROW_NUMBER() OVER (PARTITION BY id_imovel ORDER BY data_extracao DESC) = 1
), por_municipio AS (
  SELECT
    m.id_municipio,
    m.nome,
    SUM(r.valor_rateado) AS valor_credito
  FROM rateio AS r
  JOIN car_atual AS c ON r.id_car = c.id_imovel
  JOIN basedosdados.br_bd_diretorios_brasil.municipio AS m USING (id_municipio)
  GROUP BY m.id_municipio, m.nome
), ranking AS (
  SELECT
    ROW_NUMBER() OVER (ORDER BY valor_credito DESC, nome) AS posicao,
    nome AS municipio,
    valor_credito,
    COUNT(*) OVER () AS numero_municipios,
    SUM(valor_credito) OVER () AS total_geral
  FROM por_municipio
)
SELECT 'TOTAL_GERAL' AS tipo_resultado, NULL AS posicao, NULL AS municipio,
       total_geral AS valor_credito, numero_municipios
FROM ranking WHERE posicao = 1
UNION ALL
SELECT 'TOP_10', posicao, municipio, valor_credito, numero_municipios
FROM ranking WHERE posicao <= 10
ORDER BY tipo_resultado, posicao
