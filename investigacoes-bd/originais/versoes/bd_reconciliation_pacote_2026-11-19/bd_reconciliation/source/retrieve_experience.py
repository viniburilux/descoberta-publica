#!/usr/bin/env python3
"""Recuperacao programatica SIMPLES de experiencias (NAO semantica).

Mecanismo: acervo local (experiencias/*.json) + scoring deterministico por
sobreposicao de tokens (tags peso 3, titulo peso 2, corpo peso 1).
Entrada: texto do caso novo (stdin ou argv). Saida: JSON com scores por
registro e o(s) registro(s) selecionado(s) verbatim + log auditavel.

Essa selecao e o unico ponto de decisao do mecanismo: nenhum humano escolhe
qual experiencia entra no contexto da condicao B. O log torna a selecao
reproduzivel. Limitacao declarada: overlap lexical simples nao e
reconhecimento semantico; mede transferencia proxima (mesma familia de
metodo), nao generalizacao ampla.
"""
import json, re, sys, glob, os

BASE = os.path.join(os.path.dirname(__file__), '..', 'experiencias')
STOP = set('de da do em para com por que nao sim um uma o a os as e ou ao aos as no na nos nas seu sua seus suas como mais menos entre sobre ate apos'.split())

def tokens(text):
    return [t for t in re.findall(r'[a-z0-9_]+', (text or '').lower()) if len(t) > 2 and t not in STOP]

def score(case_tokens, rec):
    ct = set(case_tokens)
    s = 0
    s += 3 * len(ct & set(t for tag in rec.get('tags', []) for t in tokens(tag)))
    s += 2 * len(ct & set(tokens(rec.get('titulo', ''))))
    body = ' '.join(rec.get('armadilhas_validadas', [])) + ' ' + rec.get('familia_metodo', '')
    s += 1 * len(ct & set(tokens(body)))
    return s

def main():
    case_text = sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read()
    ct = tokens(case_text)
    recs = []
    for path in sorted(glob.glob(os.path.join(BASE, '*.json'))):
        rec = json.load(open(path))
        recs.append((score(ct, rec), path, rec))
    recs.sort(key=lambda x: -x[0])
    MIN_SCORE = 10  # discriminacao: abaixo disso e overlap acidental (tags genericas)
    selected = [r for s, p, r in recs if s >= MIN_SCORE][:2]
    out = {
        'mecanismo': 'overlap_lexical_tags3_titulo2_corpo1_minscore10_top2',
        'limitacao': 'selecao programatica simples, NAO reconhecimento semantico',
        'caso': case_text[:300],
        'scores': [{'id': r['id'], 'score': s, 'arquivo': os.path.basename(p)} for s, p, r in recs],
        'selecionados': [r['id'] for r in selected],
        'contexto_para_injetar': [
            {'titulo': r['titulo'], 'familia_metodo': r['familia_metodo'],
             'armadilhas_validadas': r['armadilhas_validadas'],
             'disclaimers': r.get('disclaimers', [])} for r in selected
        ]
    }
    print(json.dumps(out, ensure_ascii=False, indent=2))

if __name__ == '__main__':
    main()
