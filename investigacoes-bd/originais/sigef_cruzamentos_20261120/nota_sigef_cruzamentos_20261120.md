# Cruzamentos SIGEF/SICAR próprios - 20/11/2026 ~04h16 -03

## Rotas
- geoportal.incra.gov.br/geoserver (GeoNode INCRA, oficial): WFS 1.0.0, camada geonode:sigef_geo
  (2.358.176 parcelas; props: parcela_codigo, status, data_aprovacao/submissao, registro_matricula,
  area_hectares, natureza, situacao_informada). BBOX ordem lon,lat validada (lat,lon zera).
- SICAR WFS (geoserver.car.gov.br): camada sicar:sicar_imoveis_ba para o PA Bom Sucesso.
- Hosts seguem mortos: geoservicos.incra.gov.br, snci.incra.gov.br, certificacao.incra.gov.br sem DNS;
  sigef.incra.gov.br sem geoserver (404).
- Perímetro do PA = espelho (assent_geom.json); ressalva mantida até fonte INCRA aberta da geometria.

## Método
Projeção UTM WGS84 (22S Rondon, 24S SFC), shapely: interseção real de geometrias, limiar 1 m²;
contenção por contains; distâncias entre geometrias completas. Situação corrente dos WFS na consulta.

## Rondon do Pará (bbox dos CARs A/B)
- 23 parcelas SIGEF no bbox. Destaques:
  - 4db62766 "FAZENDA SÃO PEDRO - 001": 1.347,8014 ha, natureza Particular, status TITULACAO,
    aprovada/submetida 30/03/2021, situacao NAO_TITULADA, sem matrícula.
    Interseção: 100% do CAR A (1.350,22 ha declarados) e 1.237,48 ha (~96%) do CAR B.
  - b0603186 "GLEBA RONDON A - Parte 1": 7.892,9137 ha, Gleba Pública, status APROVACAO_FISCAL,
    REGISTRADA (matrícula 4081, CNS 06.735-5), aprovada 20/05/2021. Sobrepõe CAR A em 31,24 ha.
  - Demais: toques de borda <= 0,35 ha; micros do TOP-20 com interseções residuais (<50 m²) na borda da 4db62766.

## PA Bom Sucesso (SFC) - sobre perímetro espelho
- SICAR: 55 CARs no bbox; 26 intersectam o PA com área >1 m²:
  2 tipo AST cobrindo ~100% do PA (1.519,53 ha, criado 05/05/2016; 1.513,57 ha, criado 21/05/2025;
  ambos AT Aguardando análise), 18 IRU de 33-42 ha (escala de lote; SIPRA prevê 34 unidades),
  1 IRU de 336,17 ha, 5 toques marginais <0,15 ha.
- SIGEF: 11 parcelas no bbox; ZERO com sobreposição de área >1 m²; 5 CERTIFICADAS tangenciam
  o limite (0,0-2 m). Agregador dizia "38 CAR + 5 SIGEF": critério dele parece ser toque/bbox;
  nossa contagem por área real difere. Não declaramos a lista do agregador.
