SELECT
  c.id_contratacao_pncp,
  c.data_publicacao,
  c.nome_orgao,
  c.objeto_compra,
  c.valor_total_estimado,
  c.valor_total_homologado
FROM `basedosdados.br_mgi_pncp.contratacao` AS c
JOIN `basedosdados.br_bd_diretorios_brasil.municipio` AS m
  ON c.id_municipio = m.id_municipio
WHERE c.ano = 2025
  AND m.nome = 'Correntina'
  AND m.sigla_uf = 'BA'
  AND c.modalidade = 'Inexigibilidade'
  AND REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra, '')), r'carnaval|s[aã]o jo[aã]o|festa junina|festividade|festejo|comemora[cç][aã]o|arrai[aá]|artista|cantor|cantora|banda|m[uú]sic[oa]|dupla|dj|d[jé]|servi[cç]o[s]? art[ií]stic|apresenta[cç][aã]o musical|show|espet[aá]culo|evento[s]?|festival|programa[cç][aã]o cultural|evento cultural|evento festivo|produ[cç][aã]o de evento|palco|sonoriza[cç][aã]o|ilumina[cç][aã]o|estrutura para evento|estrutura de evento|loca[cç][aã]o de estrutura|trio el[eé]trico|gerador')
ORDER BY c.data_publicacao, c.id_contratacao_pncp