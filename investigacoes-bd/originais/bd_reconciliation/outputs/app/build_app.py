#!/usr/bin/env python3
"""Gera o app interativo 'O Dinheiro e o Territorio' (HTML unico, self-contained).

Dados: credito rural com recurso publico em 2023 (TODAS as finalidades), rateado
por municipio do imovel CAR associado a operacao (microdados: imoveis relacionados ao financiamento). Canone: R$ 112.125.325.594,22 em 5.380
municipios = 92,56% do subtotal classificado (R$ 121,13 bi); total de operacoes
2023 = R$ 406,40 bi. (Investimento foi o caso 2022 do par A/B, nao este recorte.)
Mapa-base: malha municipal IBGE 2022 (BR_Municipios_2022.zip, geoftp.ibge.gov.br),
simplificada com mapshaper (1,5%, keep-shapes) para topojson — cobre os 5.380 ids.
Sem dependencias externas em tempo de visualizacao.
"""
import json, csv

BASE = '/home/sandbox/operacao-bd/Lux-Lab/bd_reconciliation/outputs'

topo = json.load(open(f'{BASE}/brasil_municipios_ibge2022.topojson'))

rows = list(csv.DictReader(open(f'{BASE}/mapa_credito_rural_municipal_2023_nomeado.csv')))
total = sum(float(r['valor_financiado_rateado']) for r in rows)
assert abs(total - 112125325594.22) < 0.01, total
assert len(rows) == 5380, len(rows)

data = {r['id_municipio']: {'v': round(float(r['valor_financiado_rateado']), 2), 'n': r['nome']}
        for r in rows}

payload = {'topo': topo, 'valores': data}
payload_json = json.dumps(payload, separators=(',', ':'), ensure_ascii=False)

HTML = r"""<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>O Dinheiro e o Território — Crédito rural com recurso público 2023 por município</title>
<style>
  :root { --bg:#0f1216; --panel:#171c23; --ink:#e8ecf1; --muted:#9aa7b4; --accent:#e0a458; --line:#2a323d; }
  * { box-sizing: border-box; }
  body { margin:0; background:var(--bg); color:var(--ink); font:15px/1.5 system-ui,-apple-system,"Segoe UI",sans-serif; }
  header { padding:20px 24px 8px; }
  h1 { font-size:22px; margin:0 0 4px; }
  header p { color:var(--muted); margin:0 0 4px; max-width:70ch; }
  main { display:grid; grid-template-columns: minmax(0,1fr) 340px; gap:16px; padding:12px 24px 24px; }
  @media (max-width: 980px) { main { grid-template-columns: 1fr; } }
  .panel { background:var(--panel); border:1px solid var(--line); border-radius:10px; padding:14px; }
  #mapwrap { position:relative; }
  svg { width:100%; height:auto; display:block; touch-action:manipulation; }
  path.mun { stroke:#0f1216; stroke-width:.15; cursor:pointer; }
  path.mun:hover { stroke:#fff; stroke-width:.6; }
  path.mun.sel { stroke:#fff; stroke-width:1; }
  #tip { position:absolute; pointer-events:none; background:#000d; border:1px solid var(--line); border-radius:6px;
         padding:6px 9px; font-size:13px; display:none; max-width:260px; z-index:6; }
  .controls { display:flex; flex-wrap:wrap; gap:8px; margin-bottom:10px; align-items:center; }
  input, select, button { background:#0f1216; color:var(--ink); border:1px solid var(--line); border-radius:6px; padding:7px 10px; font-size:14px; }
  button { cursor:pointer; }
  button:hover { border-color:var(--accent); }
  #search { width:100%; }
  #sug { position:absolute; z-index:5; background:#0f1216; border:1px solid var(--line); border-radius:6px; max-height:220px; overflow:auto; display:none; min-width:280px; }
  #sug div { padding:6px 10px; cursor:pointer; }
  #sug div:hover { background:#1d2530; }
  .legend { display:flex; align-items:center; gap:6px; font-size:12px; color:var(--muted); margin:0 0 10px; flex-wrap:wrap; }
  .legend b { color:var(--ink); font-weight:600; margin-right:2px; }
  .sw { width:26px; height:12px; border-radius:2px; display:inline-block; }
  h2 { font-size:15px; margin:0 0 8px; color:var(--accent); }
  #sel-list { list-style:none; margin:0; padding:0; }
  #sel-list li { display:flex; justify-content:space-between; gap:8px; padding:6px 0; border-bottom:1px solid var(--line); font-size:14px; }
  #sel-list .x { cursor:pointer; color:var(--muted); }
  #sel-list .x:hover { color:#fff; }
  #rank { list-style:none; margin:0; padding:0; font-size:13px; }
  #rank li { display:grid; grid-template-columns: 26px 1fr auto; gap:6px; align-items:center; padding:4px 0; border-bottom:1px solid var(--line); cursor:pointer; }
  #rank li:hover { background:#1d2530; }
  #rank .bar { grid-column:1/4; height:5px; background:#223040; border-radius:3px; margin-top:-2px; }
  #rank .bar i { display:block; height:100%; background:var(--accent); border-radius:3px; }
  .stat { display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:10px; }
  .stat div { background:#0f1216; border:1px solid var(--line); border-radius:8px; padding:8px 10px; }
  .stat b { display:block; font-size:16px; }
  .stat span { color:var(--muted); font-size:12px; }
  footer { padding:0 24px 24px; color:var(--muted); font-size:12.5px; max-width:100ch; }
  .narr { font-size:14px; color:var(--ink); }
  .narr p { margin:0 0 8px; }
</style>
</head>
<body>
<header>
  <h1>O Dinheiro e o Território</h1>
  <p>Crédito rural com <b>recurso público</b> em <b>2023</b> (todas as finalidades: custeio, investimento, comercialização e industrialização), territorializado por município do imóvel rural associado à operação (CAR), com rateio igual entre os imóveis de cada operação. A tabela de propriedades dos microdados SICOR registra imóveis relacionados ao financiamento, sem papel jurídico de garantia declarado.</p>
  <p>Total: <b>R$ 112,1 bilhões</b> em <b>5.380 municípios</b>, 92,56% do subtotal classificado de R$ 121,1 bilhões. O total de operações de crédito rural em 2023 foi R$ 406,4 bilhões.</p>
  <p>Explore o mapa, busque um município, filtre por UF e monte sua própria comparação, o que o chatbot não deixa fazer.</p>
</header>
<main>
  <section class="panel" id="mapwrap">
    <div class="controls">
      <div style="position:relative; flex:1; min-width:180px;">
        <input id="search" placeholder="Buscar município…" autocomplete="off">
        <div id="sug"></div>
      </div>
      <select id="uf"><option value="">Todas as UFs</option></select>
      <select id="regiao"><option value="">Todas as regiões</option></select>
      <button id="clear">Limpar seleção</button>
    </div>
    <div class="legend" id="legend"></div>
    <svg id="map" viewBox="0 0 900 860" role="img" aria-label="Mapa coroplético do Brasil por município"></svg>
    <div id="tip"></div>
  </section>
  <aside>
    <div class="panel" style="margin-bottom:16px;">
      <h2>Panorama 2023</h2>
      <div class="stat">
        <div><b>R$ 112,1 bi</b><span>territorializado (rateado)</span></div>
        <div><b>5.380</b><span>municípios com valor</span></div>
        <div><b>R$ 8,2 mi</b><span>mediana por município*</span></div>
        <div><b>São Desidério-BA</b><span>maior valor: R$ 622,6 mi</span></div>
      </div>
      <div class="narr">
        <p>O recurso público no crédito rural se concentra: os 10 municípios do topo somam <b>R$ 4,4 bilhões</b> (3,9% do total), e metade dos municípios fica abaixo de R$ 8,2 milhões.</p>
        <p>Oeste da Bahia, norte do Mato Grosso e Matopiba aparecem como territórios de maior valor; clique nos municípios para comparar.</p>
      </div>
    </div>
    <div class="panel" style="margin-bottom:16px;">
      <h2>Comparação (<span id="sel-n">0</span>)</h2>
      <ul id="sel-list"><li style="color:var(--muted)">Clique em municípios no mapa ou na busca.</li></ul>
    </div>
    <div class="panel">
      <h2>Top 20</h2>
      <ul id="rank"></ul>
    </div>
  </aside>
</main>
<footer>
  <p><b>Fonte e método.</b> SICOR/BCB via Base dos Dados (chatbot, executor oficial): operações de 2023 marcadas com
  <code>indicador_recurso_publico = '1'</code> no catálogo de fontes da BD (16 códigos: os 15 da lista oficial de fontes públicas do BC mais o FNDCT/0911, que não tem operação em 2023),
  valor em <code>operacao.valor_parcela_credito</code> (id_referencia_bacen + numero_ordem), snapshot mais recente por imóvel,
  município via <code>area_imovel.id_municipio</code>, rateio igual entre os imóveis da operação.
  Consultas de referência: query_ref qr_8a918dd1 (mapa) e qr_0ef8fb01/qr_ceaa9c22 (cânone). Mapa-base: malha municipal IBGE 2022.
  Gerado em 19/11/2026. *Mediana calculada sobre os 5.380 municípios com valor.</p>
  <p><b>Leitura honesta:</b> valor rateado ≠ valor pago ≠ local do benefício. O município é o do imóvel rural associado à operação, não necessariamente onde o recurso circula. O rateio igual é a hipótese neutra; rateio por área é análise de sensibilidade possível.</p>
</footer>
<script id="payload" type="application/json">__PAYLOAD__</script>
<script>
"use strict";
const P = JSON.parse(document.getElementById('payload').textContent);
const TOPO = P.topo, VALS = P.valores;
const LAYER = Object.keys(TOPO.objects)[0];
const REGIOES = {'1':'Norte','2':'Nordeste','3':'Sudeste','4':'Sul','5':'Centro-Oeste'};

// ---------- topojson decode ----------
const T = TOPO.transform, SX = T.scale[0], SY = T.scale[1], TX = T.translate[0], TY = T.translate[1];
const arcs = TOPO.arcs.map(arc => {
  let x = 0, y = 0; const pts = new Array(arc.length);
  for (let i = 0; i < arc.length; i++) {
    x += arc[i][0]; y += arc[i][1];
    pts[i] = [x * SX + TX, y * SY + TY];
  }
  return pts;
});
function arcPath(idx, first) {
  const a = idx >= 0 ? arcs[idx] : arcs[~idx].slice().reverse();
  return first ? a.slice() : a.slice(1);
}
function geomRings(g) {
  const polys = [];
  const conv = (ringIdx) => {
    const pts = [];
    ringIdx.forEach((ai, k) => { arcPath(ai, k === 0).forEach(p => pts.push(p)); });
    return pts;
  };
  if (g.type === 'Polygon') polys.push(g.arcs.map(conv));
  else if (g.type === 'MultiPolygon') g.arcs.forEach(p => polys.push(p.map(conv)));
  return polys;
}

// ---------- projection ----------
// mapshaper nao emite bbox no layer: calcular dos arcos decodificados
const bbox = [Infinity, Infinity, -Infinity, -Infinity];
arcs.forEach(a => a.forEach(p => {
  if (p[0] < bbox[0]) bbox[0] = p[0]; if (p[1] < bbox[1]) bbox[1] = p[1];
  if (p[0] > bbox[2]) bbox[2] = p[0]; if (p[1] > bbox[3]) bbox[3] = p[1];
}));
const lat0 = (bbox[1] + bbox[3]) / 2 * Math.PI / 180;
const cos0 = Math.cos(lat0);
const W = 900, H = 860, PAD = 10;
const spanX = (bbox[2] - bbox[0]) * cos0, spanY = bbox[3] - bbox[1];
const k = Math.min((W - 2 * PAD) / spanX, (H - 2 * PAD) / spanY);
const ox = PAD + ((W - 2 * PAD) - spanX * k) / 2, oy = PAD + ((H - 2 * PAD) - spanY * k) / 2;
const proj = p => [ox + (p[0] - bbox[0]) * cos0 * k, H - (oy + (p[1] - bbox[1]) * k)];

// ---------- color scale ----------
const entries = Object.entries(VALS).map(([id, o]) => ({ id, v: o.v, n: o.n }));
entries.sort((a, b) => a.v - b.v);
const logs = entries.map(e => Math.log10(e.v + 1));
const PALETTE = ['#123047', '#1d5f74', '#2e8b6f', '#7fb069', '#e0a458', '#d1495b'];
const NODATA = '#1a2129';
function qtile(p) { return logs[Math.min(logs.length - 1, Math.floor(p * logs.length))]; }
const BREAKS = [0.17, 0.34, 0.51, 0.68, 0.85].map(qtile); // 5 quebras para 6 cores
const maxLog = logs[logs.length - 1];
function colorFor(v) {
  if (v == null) return NODATA;
  const l = Math.log10(v + 1);
  let i = 0; while (i < BREAKS.length && l > BREAKS[i]) i++;
  return PALETTE[Math.min(i, PALETTE.length - 1)];
}
function fmt(v) {
  if (v >= 1e9) return 'R$ ' + (v / 1e9).toLocaleString('pt-BR', { maximumFractionDigits: 2 }) + ' bi';
  if (v >= 1e6) return 'R$ ' + (v / 1e6).toLocaleString('pt-BR', { maximumFractionDigits: 1 }) + ' mi';
  if (v >= 1e3) return 'R$ ' + (v / 1e3).toLocaleString('pt-BR', { maximumFractionDigits: 0 }) + ' mil';
  return 'R$ ' + v.toLocaleString('pt-BR', { maximumFractionDigits: 0 });
}

// ---------- render ----------
const svg = document.getElementById('map');
const NS = 'http://www.w3.org/2000/svg';
const byId = {};
TOPO.objects[LAYER].geometries.forEach(g => {
  const code = String(g.properties.CD_MUN);
  const val = VALS[code];
  const regiao = REGIOES[code[0]] || '';
  const d = geomRings(g).map(poly =>
    poly.map(ring => ring.map((p, i) => { const q = proj(p); return (i ? 'L' : 'M') + q[0].toFixed(1) + ' ' + q[1].toFixed(1); }).join('') + 'Z').join('')
  ).join('');
  const path = document.createElementNS(NS, 'path');
  path.setAttribute('d', d);
  path.setAttribute('fill', colorFor(val && val.v));
  path.classList.add('mun');
  path.dataset.code = code;
  svg.appendChild(path);
  byId[code] = { path, props: { codigo: code, uf: g.properties.SIGLA_UF, regiao }, val: val && val.v, nome: (val && val.n) || g.properties.NM_MUN };
});

// legend (sempre visivel, com escala e "sem dados")
const leg = document.getElementById('legend');
leg.innerHTML = '<b>Escala (valor rateado 2023):</b>' +
  PALETTE.map((c, i) => {
    const lo = i === 0 ? 1 : Math.pow(10, BREAKS[i - 1]);
    const hi = i < BREAKS.length ? Math.pow(10, BREAKS[i]) : Math.pow(10, maxLog);
    return `<span class="sw" style="background:${c}"></span><span>${fmt(lo)} a ${fmt(hi)}</span>`;
  }).join('') +
  `<span class="sw" style="background:${NODATA}"></span><span>Sem valor 2023</span>`;

// ---------- state ----------
const sel = new Set();
const tip = document.getElementById('tip');
const wrap = document.getElementById('mapwrap');

function saveState() {
  const st = { sel: [...sel], uf: ufSel.value, regiao: regSel.value };
  try { localStorage.setItem('dinheiro-territorio', JSON.stringify(st)); } catch (e) {}
  history.replaceState(null, '', '#' + encodeURIComponent(JSON.stringify(st)));
}
function loadState() {
  let raw = null;
  if (location.hash.length > 1) { try { raw = decodeURIComponent(location.hash.slice(1)); } catch (e) {} }
  if (!raw) { try { raw = localStorage.getItem('dinheiro-territorio'); } catch (e) {} }
  if (!raw) return null;
  try { return JSON.parse(raw); } catch (e) { return null; }
}

function renderSel() {
  const ul = document.getElementById('sel-list');
  document.getElementById('sel-n').textContent = sel.size;
  if (!sel.size) { ul.innerHTML = '<li style="color:var(--muted)">Clique em municípios no mapa ou na busca.</li>'; return; }
  const arr = [...sel].map(c => byId[c]).sort((a, b) => (b.val || 0) - (a.val || 0));
  ul.innerHTML = arr.map(o =>
    `<li><span><b>${o.nome}</b> <span style="color:var(--muted)">${o.props.uf} · ${o.props.regiao}</span></span>
     <span style="text-align:right">${o.val != null ? fmt(o.val) : 'sem valor'}<br>
     <span style="color:var(--muted);font-size:12px">${o.val != null ? (100 * o.val / 112125325594.22).toFixed(2) + '% do total' : ''}</span>
     <span class="x" data-c="${o.props.codigo}">✕</span></span></li>`).join('');
  ul.querySelectorAll('.x').forEach(x => x.onclick = () => { toggleSel(x.dataset.c); });
}

function toggleSel(code) {
  const o = byId[code]; if (!o) return;
  if (sel.has(code)) { sel.delete(code); o.path.classList.remove('sel'); }
  else { sel.add(code); o.path.classList.add('sel'); }
  renderSel(); saveState();
}

function showTip(o, x, y) {
  tip.innerHTML = `<b>${o.nome}</b> (${o.props.uf})<br>${o.val != null ? fmt(o.val) : 'sem valor 2023'}<br>
    <span style="color:var(--muted)">${o.props.regiao}</span>`;
  const r = wrap.getBoundingClientRect();
  tip.style.display = 'block';
  tip.style.left = (x - r.left + 14) + 'px';
  tip.style.top = (y - r.top + 10) + 'px';
}
svg.addEventListener('mousemove', e => {
  const t = e.target;
  if (!t.classList || !t.classList.contains('mun')) { tip.style.display = 'none'; return; }
  showTip(byId[t.dataset.code], e.clientX, e.clientY);
});
svg.addEventListener('mouseleave', () => tip.style.display = 'none');
svg.addEventListener('click', e => {
  const t = e.target;
  if (t.classList && t.classList.contains('mun')) toggleSel(t.dataset.code);
});

// ---------- filters ----------
const ufSel = document.getElementById('uf'), regSel = document.getElementById('regiao');
const ufs = [...new Set(Object.values(byId).map(o => o.props.uf))].sort();
ufs.forEach(u => { const op = document.createElement('option'); op.value = u; op.textContent = u; ufSel.appendChild(op); });
const regs = [...new Set(Object.values(byId).map(o => o.props.regiao).filter(Boolean))].sort();
regs.forEach(r => { const op = document.createElement('option'); op.value = r; op.textContent = r; regSel.appendChild(op); });
function applyFilter() {
  Object.values(byId).forEach(o => {
    const hide = (ufSel.value && o.props.uf !== ufSel.value) || (regSel.value && o.props.regiao !== regSel.value);
    o.path.style.display = hide ? 'none' : '';
  });
  saveState();
}
ufSel.onchange = applyFilter; regSel.onchange = applyFilter;
document.getElementById('clear').onclick = () => { [...sel].forEach(c => toggleSel(c)); };

// ---------- search ----------
const search = document.getElementById('search'), sug = document.getElementById('sug');
const norm = s => s.normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase();
const nameIdx = Object.entries(byId).map(([c, o]) => ({ c, n: o.nome, uf: o.props.uf, key: norm(o.nome) }));
search.oninput = () => {
  const q = norm(search.value.trim());
  if (q.length < 2) { sug.style.display = 'none'; return; }
  const hits = nameIdx.filter(x => x.key.includes(q)).slice(0, 12);
  if (!hits.length) { sug.style.display = 'none'; return; }
  sug.innerHTML = hits.map(h => `<div data-c="${h.c}">${h.n} <span style="color:var(--muted)">${h.uf}</span></div>`).join('');
  sug.style.display = 'block';
  sug.querySelectorAll('div').forEach(d => d.onclick = () => {
    toggleSel(d.dataset.c); sug.style.display = 'none'; search.value = '';
  });
};
document.addEventListener('click', e => { if (!sug.contains(e.target) && e.target !== search) sug.style.display = 'none'; });

// ---------- top 20 ----------
const top20 = entries.slice(-20).reverse();
const tmax = top20[0].v;
document.getElementById('rank').innerHTML = top20.map((e, i) => {
  return `<li data-c="${e.id}"><span>${i + 1}.</span><span>${e.n}</span><span>${fmt(e.v)}</span>
    <span class="bar"><i style="width:${(100 * e.v / tmax).toFixed(1)}%"></i></span></li>`;
}).join('');
document.querySelectorAll('#rank li').forEach(li => li.onclick = () => toggleSel(li.dataset.c));

// restore state
const st = loadState();
if (st) {
  if (st.uf) ufSel.value = st.uf;
  if (st.regiao) regSel.value = st.regiao;
  applyFilter();
  (st.sel || []).forEach(c => { if (byId[c] && !sel.has(c)) { sel.add(c); byId[c].path.classList.add('sel'); } });
  renderSel();
}
</script>
</body>
</html>
"""

html_out = HTML.replace('__PAYLOAD__', payload_json)
with open(f'{BASE}/app/index.html', 'w', encoding='utf-8') as f:
    f.write(html_out)
print('index.html bytes:', len(html_out.encode('utf-8')))
