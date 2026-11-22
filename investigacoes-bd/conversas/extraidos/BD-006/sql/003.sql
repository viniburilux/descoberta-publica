WITH rais AS (
  SELECT id_municipio, sigla_uf, cnae_2_subclasse
  FROM `basedosdados.br_me_rais.microdados_estabelecimentos`
  WHERE ano = 2023
    AND sigla_uf IS NOT NULL
    AND cnae_2_subclasse IS NOT NULL
  GROUP BY id_municipio, sigla_uf, cnae_2_subclasse
), cnae AS (
  SELECT subclasse
  FROM `basedosdados.br_bd_diretorios_brasil.cnae_2`
  GROUP BY subclasse
)
SELECT
  COUNT(*) AS chaves_rais,
  COUNTIF(c.subclasse IS NOT NULL) AS chaves_com_cnae,
  COUNTIF(c.subclasse IS NULL) AS chaves_sem_cnae
FROM rais r
LEFT JOIN cnae c
  ON r.cnae_2_subclasse = c.subclasse