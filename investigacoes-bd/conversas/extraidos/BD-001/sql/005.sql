WITH base AS (
  SELECT
    c.valor_total_estimado,
    c.valor_total_homologado,
    CASE
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'carnaval|s[aã]o jo[aã]o|festa junina|festividade|festejo|comemora[cç][aã]o|arrai[aá]|r[eé]veillon') THEN 'Festividades específicas'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'artista|cantor|cantora|banda|m[uú]sic[oa]|dupla|\bdj\b|servi[cç]o[s]? art[ií]stic|apresenta[cç][aã]o musical') THEN 'Artistas, bandas e atrações musicais'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'\bshow[s]?\b|espet[aá]culo|festival|programa[cç][aã]o cultural|evento cultural|evento festivo|produ[cç][aã]o de evento') THEN 'Shows e eventos'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'palco|sonoriza[cç][aã]o|ilumina[cç][aã]o|estrutura para evento|estrutura de evento|loca[cç][aã]o de estrutura|trio el[eé]trico|gerador') THEN 'Estrutura e apoio a eventos'
      ELSE NULL
    END AS segmento
  FROM `basedosdados.br_mgi_pncp.contratacao` AS c
  JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS m
    ON c.id_municipio = m.id_municipio
  WHERE c.ano = 2025
    AND m.sigla_uf = 'BA'
    AND c.modalidade = 'Inexigibilidade'
), agregados AS (
  SELECT
    segmento,
    COUNT(*) AS quantidade_contratacoes,
    COUNTIF(valor_total_homologado IS NOT NULL) AS quantidade_com_valor_homologado,
    SUM(valor_total_homologado) AS total_homologado_segmento,
    SUM(valor_total_estimado) AS total_estimado_segmento
  FROM base
  WHERE segmento IS NOT NULL
  GROUP BY segmento
)
SELECT
  segmento,
  quantidade_contratacoes,
  quantidade_com_valor_homologado,
  total_homologado_segmento,
  total_estimado_segmento,
  SUM(quantidade_contratacoes) OVER () AS quantidade_total,
  SUM(quantidade_com_valor_homologado) OVER () AS quantidade_total_com_valor_homologado,
  SUM(total_homologado_segmento) OVER () AS total_homologado_geral,
  SUM(total_estimado_segmento) OVER () AS total_estimado_geral
FROM agregados
ORDER BY total_estimado_segmento DESC