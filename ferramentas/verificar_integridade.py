#!/usr/bin/env python3
"""Verificação de integridade do pacote v0.1.2 contra o manifest_v012.json.

Somente leitura: não modifica, reempacota nem move dados.
Cada arquivo listado no manifest é verificado por SHA-256 e tamanho em bytes.

Uso:
    python3 ferramentas/verificar_integridade.py            # a partir da raiz do repo
    python3 ferramentas/verificar_integridade.py --manifest caminho/do/manifest.json

Saída:
    0 = todos os arquivos conferem
    1 = há divergências ou arquivos ausentes
    2 = erro de uso/ambiente (manifest ilegível etc.)
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import sys

CHUNK = 1 << 20  # 1 MiB


def sha256_do_arquivo(caminho: str) -> str:
    h = hashlib.sha256()
    with open(caminho, "rb") as f:
        for bloco in iter(lambda: f.read(CHUNK), b""):
            h.update(bloco)
    return h.hexdigest()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    raiz_padrao = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    parser.add_argument(
        "--raiz",
        default=raiz_padrao,
        help="diretório raiz do pacote (padrão: raiz do repositório)",
    )
    parser.add_argument(
        "--manifest",
        default=None,
        help="caminho do manifest (padrão: <raiz>/manifest_v012.json)",
    )
    args = parser.parse_args(argv)

    caminho_manifest = args.manifest or os.path.join(args.raiz, "manifest_v012.json")
    try:
        with open(caminho_manifest, encoding="utf-8") as f:
            manifest = json.load(f)
    except (OSError, json.JSONDecodeError) as exc:
        print(f"[erro] não foi possível ler o manifest: {exc}", file=sys.stderr)
        return 2

    arquivos = manifest.get("arquivos", [])
    if not arquivos:
        print("[erro] manifest sem lista de arquivos.", file=sys.stderr)
        return 2

    ok = 0
    divergentes: list[tuple[str, str, str]] = []
    ausentes: list[str] = []
    informativas: list[str] = []

    for entrada in arquivos:
        rel = entrada["arquivo"]
        sha_declarado = entrada.get("sha256")
        # Entrada informativa (sem checksum verificável): conta como "informativa".
        if not isinstance(sha_declarado, str) or len(sha_declarado) < 32:
            informativas.append(rel)
            continue
        abs_path = os.path.join(args.raiz, rel)
        if not os.path.isfile(abs_path):
            ausentes.append(rel)
            continue
        atual = sha256_do_arquivo(abs_path)
        esperado_bytes = entrada.get("bytes")
        tamanho_ok = esperado_bytes is None or os.path.getsize(abs_path) == esperado_bytes
        if atual == sha_declarado and tamanho_ok:
            ok += 1
        else:
            divergentes.append((rel, sha_declarado, atual))

    total = len(arquivos)
    print(
        f"[integridade] verificados: {total} | ok: {ok} | divergentes: {len(divergentes)}"
        f"| ausentes: {len(ausentes)} | informativas (sem checksum): {len(informativas)}"
    )
    for rel, esperado, atual in divergentes:
        print(f"  DIVERGENTE {rel}")
        print(f"    esperado: {esperado}")
        print(f"    atual   : {atual}")
    for rel in ausentes:
        print(f"  AUSENTE   {rel}")
    for rel in informativas:
        print(f"  INFORMATIVA {rel} (não verificável por sha256)")

    if divergentes or ausentes:
        print("[resultado] FALHA — não distribuir/aceitar este pacote como íntegro.")
        return 1
    print("[resultado] PASSOU — conteúdo dos dados confere com o manifest v0.1.2.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
