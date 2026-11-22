# Método: vizinhanças dos 8 micros BA (TOP-20) - 20/11/2026

Fonte: SICAR WFS https://geoserver.car.gov.br/geoserver/sicar/ows
Requisição: WFS 1.0.0 GetFeature, typeName sicar:sicar_imoveis_ba, outputFormat application/json,
bbox = ponto do micro +/- 0,01 grau em lon/lat, sufixo EPSG:4326, ordem de eixo lon,lat
(validada com controle positivo no mesmo padrão; a ordem lat,lon retorna zero nesse endpoint).
Consultas feitas em 20/11/2026 ~04h12 -03. Contagens = totalFeatures no recorte consultado
(não provam ausência fora do recorte).

Distâncias: geometrias completas projetadas em UTM WGS84 por zona (23S/24S, EPSG:32723/32724);
distância planar ponto-polígono (shapely distance); contenção por point-in-polygon (contains).
Não é distância vértice-a-vértice.

Colunas usadas: cod_imovel, area (ha, campo oficial), municipio, status_imovel, condicao.
Situação = estado corrente no WFS na hora da consulta.

Raws: ba_viz_{4,5,8,11,13,16,18,20}_v2.json (1 fetch por micro, completo).
Distâncias consolidadas: ba_viz_distancias_utm.json.
Nota: fetch anterior (ba_vizinhos_*.json, ~04h07) tinha bug de ordem de eixo/URL e foi descartado;
os valores válidos são os dos raws _v2.
