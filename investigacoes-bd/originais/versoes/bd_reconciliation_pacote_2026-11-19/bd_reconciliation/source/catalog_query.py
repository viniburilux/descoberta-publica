#!/usr/bin/env python3
"""catalog_query.py - consulta ao catalogo de relacionamentos (missao 3).

Exemplos:
  python3 catalog_query.py --list
  python3 catalog_query.py --relationship sicor_car
  python3 catalog_query.py --relationship sicor_car --field cobertura_observada
  python3 catalog_query.py --table br_bcb_sicor
"""
import argparse
import glob
import json
import os
import sys

CAT_DIR = os.path.join(os.path.dirname(__file__), "..", "catalog", "relationships")


def load_all():
    regs = {}
    for p in sorted(glob.glob(os.path.join(CAT_DIR, "*.json"))):
        with open(p, encoding="utf-8") as f:
            r = json.load(f)
        regs[r["id"]] = r
    return regs


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--relationship")
    ap.add_argument("--field")
    ap.add_argument("--table", help="substringa de tabela (ex.: br_bcb_sicor)")
    args = ap.parse_args()

    regs = load_all()
    if args.list:
        for rid, r in regs.items():
            print(f"{rid:24s} {r['titulo']}  [{r['status_validacao']}]")
        return 0
    if args.table:
        for rid, r in regs.items():
            tabelas = " ".join(r.get("bases", {}).values())
            if args.table in tabelas:
                print(f"{rid:24s} {tabelas}")
        return 0
    if args.relationship:
        r = regs.get(args.relationship)
        if not r:
            print(f"desconhecido: {args.relationship}", file=sys.stderr)
            return 1
        if args.field:
            print(json.dumps(r.get(args.field), ensure_ascii=False, indent=2))
        else:
            print(json.dumps(r, ensure_ascii=False, indent=2))
        return 0
    ap.print_help()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
