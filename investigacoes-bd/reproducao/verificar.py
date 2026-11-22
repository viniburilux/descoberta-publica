#!/usr/bin/env python3
"""Reproduz a geração local sem alterar os arquivos originais."""
from pathlib import Path
import ast
import hashlib
import json
import shutil
import subprocess
import sys
import tempfile

root = Path(__file__).resolve().parents[1]
base = root / 'originais' / 'bd_reconciliation'
out = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else root / 'reproducao-local'
out.mkdir(parents=True, exist_ok=True)
checks = []
for config in sorted((base / 'configs/relationships').glob('*.json')):
    family = config.stem
    subprocess.run([sys.executable, str(base / 'source/reconcile.py'), '--config', str(config), '--out', str(out / 'sql' / family)], check=True)
    subprocess.run([sys.executable, str(base / 'source/report.py'), '--config', str(config), '--recorded', str(base / 'inputs/recorded' / (family + '.json')), '--out', str(out / 'reports')], check=True)
    for sql in sorted((out / 'sql' / family).glob('*.sql')):
        original = base / 'outputs/sql' / family / sql.name
        equal = sql.read_bytes() == original.read_bytes()
        checks.append({'arquivo': str(sql.relative_to(out)), 'igual_ao_original': equal})
        if not equal:
            raise RuntimeError(f'SQL diferente: {sql.name}')
# O gerador original usa um caminho absoluto. A cópia de execução troca somente BASE.
appbase = out / 'app-inputs'
appbase.mkdir(exist_ok=True)
(appbase / 'app').mkdir(exist_ok=True)
for name in ['brasil_municipios_ibge2022.topojson', 'mapa_credito_rural_municipal_2023_nomeado.csv']:
    shutil.copyfile(base / 'outputs' / name, appbase / name)
builder = base / 'outputs/app/build_app.py'
tree = ast.parse(builder.read_text())
for node in tree.body:
    if isinstance(node, ast.Assign) and any(isinstance(t, ast.Name) and t.id == 'BASE' for t in node.targets):
        node.value = ast.Constant(str(appbase))
ast.fix_missing_locations(tree)
exec(compile(tree, str(builder), 'exec'), {'__name__': '__main__'})
app = appbase / 'app/index.html'
original = base / 'outputs/app/index.html'
app_equal = app.read_bytes() == original.read_bytes()
result = {'sqls': checks, 'sqls_identicos': len(checks), 'app_html_identico': app_equal, 'app_sha256': hashlib.sha256(app.read_bytes()).hexdigest()}
(out / 'verificacao.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({k:v for k,v in result.items() if k != 'sqls'}, ensure_ascii=False))
