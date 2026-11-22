WITH base AS (
  SELECT
    id_referencia_bacen,
    numero_ordem,
    valor_parcela_credito,
    id_fonte_recurso,
    CONCAT(id_referencia_bacen, '||', numero_ordem) AS chave_operacao_ordem
  FROM `basedosdados.br_bcb_sicor.operacao`
  WHERE ano_emissao = 2023
),
chaves AS (
  SELECT
    chave_operacao_ordem,
    COUNT(*) AS linhas_na_chave,
    COUNT(DISTINCT valor_parcela_credito) AS valores_distintos,
    MIN(valor_parcela_credito) AS valor_minimo,
    MAX(valor_parcela_credito) AS valor_maximo
  FROM base
  GROUP BY chave_operacao_ordem
),
base_com_fonte AS (
  SELECT
    b.valor_parcela_credito,
    f.indicador_recurso_publico
  FROM base b
  LEFT JOIN `basedosdados.br_bcb_sicor.fonte_recurso` f
    ON b.id_fonte_recurso = f.id_fonte_recurso
)
SELECT
  (SELECT COUNT(*) FROM base) AS linhas_totais,
  (SELECT COUNT(*) FROM chaves) AS chaves_distintas,
  (SELECT COUNTIF(linhas_na_chave > 1) FROM chaves) AS chaves_repetidas,
  (SELECT SUM(IF(linhas_na_chave > 1, linhas_na_chave, 0)) FROM chaves) AS linhas_em_chaves_repetidas,
  (SELECT COUNTIF(linhas_na_chave > 1 AND valores_distintos > 1) FROM chaves) AS chaves_repetidas_com_valor_diferente,
  (SELECT SUM(valor_parcela_credito) FROM base_com_fonte) AS total_valor_parcela_credito,
  (SELECT SUM(IF(indicador_recurso_publico = '1', valor_parcela_credito, 0)) FROM base_com_fonte) AS total_valor_recurso_publico,
  (SELECT COUNTIF(indicador_recurso_publico IS NULL) FROM base_com_fonte) AS linhas_sem_classificacao_da_fonte