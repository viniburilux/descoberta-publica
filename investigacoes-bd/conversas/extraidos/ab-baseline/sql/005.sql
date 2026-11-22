WITH base AS (
 SELECT DISTINCT o.id_referencia_bacen, o.numero_ordem, p.id_car
 FROM `basedosdados.br_bcb_sicor.operacao` o
 JOIN `basedosdados.br_bcb_sicor.empreendimento` e USING(id_empreendimento)
 JOIN `basedosdados.br_bcb_sicor.fonte_recurso` f USING(id_fonte_recurso)
 JOIN `basedosdados.br_bcb_sicor.recurso_publico_propriedade` p
 ON o.id_referencia_bacen=p.id_referencia_bacen AND o.numero_ordem=p.numero_ordem AND p.ano_emissao=2022
 WHERE o.ano_emissao=2022 AND e.finalidade='Investimento' AND f.indicador_recurso_publico='1' AND p.id_car IS NOT NULL
), car AS (
 SELECT id_imovel
 FROM `basedosdados.br_sfb_sicar.area_imovel`
 WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
 GROUP BY id_imovel
)
SELECT COUNT(*) AS pares, COUNTIF(c.id_imovel IS NOT NULL) AS pares_com_match
FROM base b LEFT JOIN car c ON b.id_car=c.id_imovel