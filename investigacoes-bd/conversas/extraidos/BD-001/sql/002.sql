WITH base AS (
  SELECT
    c.id_contratacao_pncp,
    c.objeto_compra,
    c.nome_orgao,
    c.nome_unidade,
    c.valor_total_homologado,
    CASE
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'carnaval|s[aã]o jo[aã]o|festa junina|festividade|festejo|comemora[cç][aã]o|arrai[aá]') THEN 'Festividades específicas'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'artista|cantor|cantora|banda|m[uú]sic[oa]|dupla|dj|d[jé]|servi[cç]o[s]? art[ií]stic|apresenta[cç][aã]o musical') THEN 'Artistas, bandas e atrações musicais'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'show|espet[aá]culo|evento[s]?|festival|programa[cç][aã]o cultural|evento cultural|evento festivo|produ[cç][aã]o de evento') THEN 'Shows e eventos'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'palco|sonoriza[cç][aã]o|ilumina[cç][aã]o|estrutura para evento|estrutura de evento|loca[cç][aã]o de estrutura|trio el[eé]trico|gerador') THEN 'Estrutura e apoio a eventos'
      WHEN REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'fest[ae]|event') THEN 'Outras festividades e eventos'
      ELSE NULL
    END AS segmento
  FROM `basedosdados.br_mgi_pncp.contratacao` AS c
  JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS m
    ON c.id_municipio = m.id_municipio
  WHERE c.ano = 2025
    AND m.nome = 'Correntina'
    AND m.sigla_uf = 'BA'
    AND c.modalidade = 'Inexigibilidade'
)
SELECT
  segmento,
  COUNT(*) AS quantidade_contratacoes,
  SUM(COALESCE(valor_total_homologado, 0)) AS total_homologado_segmento,
  SUM(SUM(COALESCE(valor_total_homologado, 0))) OVER () AS total_homologado_geral,
  SUM(COUNT(*)) OVER () AS quantidade_total
FROM base
WHERE segmento IS NOT NULL
GROUP BY segmento
ORDER BY total_homologado_segmento DESC