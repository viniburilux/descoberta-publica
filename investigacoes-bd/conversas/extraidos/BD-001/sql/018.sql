WITH b AS (
 SELECT c.ano,c.id_contratacao_pncp,c.id_municipio,m.nome municipio,c.data_publicacao,c.nome_orgao,c.objeto_compra,c.valor_total_homologado,c.modalidade
 FROM `basedosdados.br_mgi_pncp.contratacao` c JOIN `basedosdados.br_bd_diretorios_brasil.municipio` m ON c.id_municipio=m.id_municipio
 WHERE c.ano BETWEEN 2021 AND 2026 AND m.sigla_uf='BA'
 AND REGEXP_CONTAINS(LOWER(COALESCE(c.objeto_compra,'')),r'carnaval|são joão|sao joao|festejo|festividade|festa junina|artista|cantor|cantora|banda|show|festival|palco|sonoriza|tenda|trio elétrico|trio eletrico')
), g AS (
 SELECT municipio,ano,valor_total_homologado,COUNT(*) qtd,ARRAY_AGG(STRUCT(id_contratacao_pncp, data_publicacao, objeto_compra) ORDER BY data_publicacao LIMIT 5) exemplos
 FROM b WHERE valor_total_homologado IS NOT NULL GROUP BY municipio,ano,valor_total_homologado
)
SELECT municipio,ano,valor_total_homologado,qtd,exemplos FROM g WHERE qtd>=3 ORDER BY qtd DESC,valor_total_homologado DESC LIMIT 25