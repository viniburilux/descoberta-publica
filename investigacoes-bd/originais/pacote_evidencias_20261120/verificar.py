#!/usr/bin/env python3
"""Código mínimo de verificação espacial — OPERAÇÃO BD (20/11/2026).
Entradas: FeatureCollections GeoJSON (EPSG:4326) salvas das respostas literais WFS.
Uso: python3 verificar.py <alvo.json> <micro_lon> <micro_lat>   # distância ponto->polígonos
     python3 verificar.py <alvo.json> <poligono_ref.json>       # interseções + áreas geodésicas
Dependências: shapely, pyproj (padrão científico; sem transformação de CRS local).
"""
import json, sys, pyproj
from shapely.geometry import shape, Point

geod = pyproj.Geod(ellps="WGS84")

def dist_m(g, pt):
    if g.contains(pt): return 0.0
    geoms = [g] if g.geom_type == "Polygon" else list(g.geoms)
    return min(geod.inv(pt.x, pt.y, *(lambda n: (n.x, n.y))(gg.exterior.interpolate(gg.exterior.project(pt))))[2] for gg in geoms)

def area_ha(g):
    return abs(geod.geometry_area_perimeter(g)[0]) / 10000.0

def main():
    feats = json.load(open(sys.argv[1])).get("features", [])
    if len(sys.argv) == 4:
        pt = Point(float(sys.argv[2]), float(sys.argv[3]))
        for f in feats:
            p, g = f["properties"], shape(f["geometry"])
            print(p.get("year") or p.get("view_date"), p.get("cod_imovel") or p.get("classname") or "", f"area~{area_ha(g):.2f}ha", f"dist~{dist_m(g, pt):.1f}m")
    else:
        ref = shape(json.load(open(sys.argv[2]))["features"][0]["geometry"])
        for f in feats:
            p, g = f["properties"], shape(f["geometry"])
            if g.intersects(ref):
                print(p.get("year") or p.get("view_date"), f"intersecao {area_ha(g.intersection(ref)):.2f} ha")

if __name__ == "__main__":
    main()
