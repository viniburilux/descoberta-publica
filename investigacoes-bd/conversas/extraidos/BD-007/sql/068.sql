WITH alvos AS (
 SELECT 'micro-CAR' grupo,'PA-1506187-94551B72659E427F961D2F62CEBA7392' id_imovel,'1506187' id_municipio UNION ALL
 SELECT 'micro-CAR','PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98','1506187' UNION ALL
 SELECT 'micro-CAR','MS-5006606-4693892971CF47B4B2684C3A94950BEE','5006606' UNION ALL
 SELECT 'micro-CAR','BA-2921401-9177991E4861442EACDDC06DB91','2921401' UNION ALL
 SELECT 'micro-CAR','BA-2929057-C5D11EE026A64399A6EF36764E8739E9','2929057' UNION ALL
 SELECT 'vizinho','PA-1506187-878F5B604D8E471F8DE7F692F7F7288C','1506187' UNION ALL
 SELECT 'vizinho','PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56','1506187' UNION ALL
 SELECT 'vizinho','PA-1506187-48EDE9CDCF3947959921871671228876','1506187' UNION ALL
 SELECT 'vizinho','MS-5006606-9F4376C099A342D2899444A8DB7FADE6','5006606' UNION ALL
 SELECT 'vizinho','MS-5006606-F52D5261C8504529A0FC680C01132DA2','5006606' UNION ALL
 SELECT 'vizinho','BA-2921401-0F05B7015F404007905C0A598A258AF4','2921401' UNION ALL
 SELECT 'vizinho','BA-2929057-43362B5DD011494FA6B0EE05C2761D93','2929057'
),car AS (
 SELECT a.id_imovel,a.id_municipio,a.sigla_uf,a.geometria,t.grupo
 FROM `basedosdados.br_sfb_sicar.area_imovel` a JOIN alvos t USING(id_imovel)
 WHERE a.data_extracao>=DATE '2026-06-02' AND a.data_extracao<=DATE '2026-08-04'
 QUALIFY ROW_NUMBER() OVER(PARTITION BY a.id_imovel ORDER BY a.data_extracao DESC)=1
),emb AS (
 SELECT id_embargo,ano,area_ha,data_desembargo,indicador_desembargado,id_municipio,sigla_uf,geometria
 FROM `basedosdados.br_ibama_fiscalizacao.area_embargada`
 WHERE ano BETWEEN 1987 AND 2026 AND id_municipio IN (SELECT DISTINCT id_municipio FROM alvos)
)
SELECT c.grupo,c.id_imovel,c.id_municipio,c.sigla_uf,e.id_embargo,e.ano,e.area_ha,e.data_desembargo,
 CASE WHEN e.indicador_desembargado='S' THEN 'Sim' ELSE 'Não informado como desembargado' END situacao_desembargo,
 e.ano<2023 embargo_anterior_2023,ST_INTERSECTS(c.geometria,e.geometria) interseccao
FROM car c JOIN emb e ON e.id_municipio=c.id_municipio
WHERE ST_INTERSECTS(c.geometria,e.geometria)
ORDER BY c.grupo,c.id_imovel,e.ano,e.id_embargo