WITH e AS (
 SELECT id_embargo,id_auto,id_municipio,ano
 FROM `basedosdados.br_ibama_fiscalizacao.area_embargada`
 WHERE ano >= 1987 AND id_auto IS NOT NULL
), a AS (
 SELECT id_auto FROM `basedosdados.br_ibama_fiscalizacao.auto_infracao`
 WHERE ano >= 1977 AND id_auto IS NOT NULL
 GROUP BY id_auto
)
SELECT e.id_embargo,e.id_auto,e.id_municipio,e.ano
FROM e LEFT JOIN a USING(id_auto)
WHERE a.id_auto IS NULL
ORDER BY e.id_embargo
LIMIT 10