import React, { useMemo, useState } from 'react';
import { Callout, Caption, Closing, Facts, FileCard, Group, Header, Rows, Row, useLocalState } from '@instinct/files';
import municipios from './municipios_mapa.json';
import mapaCover from './photos/mapa_cover.png';

type Mun = { c: string; n: string; u: string; r: string; v: number | null; d: string };
const MUNS = municipios as Mun[];
const TOTAL = 112125325594.22;

const PALETTE = ['#123047', '#1d5f74', '#2e8b6f', '#7fb069', '#e0a458', '#d1495b'];
const NODATA = '#1a2129';
const comValor = MUNS.filter(m => m.v != null).map(m => m.v as number).sort((a, b) => a - b);
const logs = comValor.map(v => Math.log10(v + 1));
const qtile = (p: number) => logs[Math.min(logs.length - 1, Math.floor(p * logs.length))];
const BREAKS = [0.17, 0.34, 0.51, 0.68, 0.85].map(qtile);
const maxLog = logs[logs.length - 1];
function colorFor(v: number | null) {
    if (v == null) return NODATA;
    const l = Math.log10(v + 1);
    let i = 0; while (i < BREAKS.length && l > BREAKS[i]) i++;
    return PALETTE[Math.min(i, PALETTE.length - 1)];
}
function fmt(v: number) {
    if (v >= 1e9) return 'R$ ' + (v / 1e9).toLocaleString('pt-BR', { maximumFractionDigits: 2 }) + ' bi';
    if (v >= 1e6) return 'R$ ' + (v / 1e6).toLocaleString('pt-BR', { maximumFractionDigits: 1 }) + ' mi';
    if (v >= 1e3) return 'R$ ' + (v / 1e3).toLocaleString('pt-BR', { maximumFractionDigits: 0 }) + ' mil';
    return 'R$ ' + v.toLocaleString('pt-BR', { maximumFractionDigits: 0 });
}
const norm = (s: string) => s.normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase();

const UFS = [...new Set(MUNS.map(m => m.u))].sort();
const REGIOES = [...new Set(MUNS.map(m => m.r).filter(Boolean))].sort();
const byCode = new Map(MUNS.map(m => [m.c, m]));
const top20 = MUNS.filter(m => m.v != null).sort((a, b) => (b.v as number) - (a.v as number)).slice(0, 20);
const tmax = top20[0].v as number;

type Sel = { sel: string[]; uf: string; regiao: string };

function MapaInterativo() {
    const [st, setSt, saved] = useLocalState<Sel>('dinheiro-territorio.v1', { sel: [], uf: '', regiao: '' });
    const [busca, setBusca] = useState('');
    const [tooltip, setTooltip] = useState<Mun | null>(null);
    const selSet = useMemo(() => new Set(st.sel), [st.sel]);
    const update = (patch: Partial<Sel>) => { if (saved.ready) setSt({ ...st, ...patch }); };
    const toggle = (c: string) => {
        const next = new Set(selSet);
        if (next.has(c)) next.delete(c); else next.add(c);
        update({ sel: [...next] });
    };
    const sugestoes = useMemo(() => {
        const q = norm(busca.trim());
        if (q.length < 2) return [];
        return MUNS.filter(m => norm(m.n).includes(q)).slice(0, 12);
    }, [busca]);
    const selecionados = st.sel.map(c => byCode.get(c)!).filter(Boolean).sort((a, b) => (b.v ?? 0) - (a.v ?? 0));

    return <div className="dt-mapa">
        <div className="dt-controls">
            <div className="dt-busca">
                <input value={busca} onChange={e => setBusca(e.target.value)} placeholder="Buscar município…" aria-label="Buscar município" />
                {sugestoes.length > 0 && <div className="dt-sug" role="listbox">
                    {sugestoes.map(m => <button type="button" key={m.c} onClick={() => { toggle(m.c); setBusca(''); }}>{m.n} <span>{m.u}</span></button>)}
                </div>}
            </div>
            <select value={st.uf} onChange={e => update({ uf: e.target.value })} aria-label="Filtrar por UF">
                <option value="">Todas as UFs</option>
                {UFS.map(u => <option key={u} value={u}>{u}</option>)}
            </select>
            <select value={st.regiao} onChange={e => update({ regiao: e.target.value })} aria-label="Filtrar por região">
                <option value="">Todas as regiões</option>
                {REGIOES.map(r => <option key={r} value={r}>{r}</option>)}
            </select>
            <button type="button" onClick={() => update({ sel: [] })}>Limpar seleção</button>
        </div>
        <div className="dt-legend" aria-label="Escala de valores">
            <b>Escala (valor rateado 2023):</b>
            {PALETTE.map((c, i) => {
                const lo = i === 0 ? 1 : Math.pow(10, BREAKS[i - 1]);
                const hi = i < BREAKS.length ? Math.pow(10, BREAKS[i]) : Math.pow(10, maxLog);
                return <span key={c} className="dt-leg-item"><span className="dt-sw" style={{ background: c }} />{fmt(lo)} a {fmt(hi)}</span>;
            })}
            <span className="dt-leg-item"><span className="dt-sw" style={{ background: NODATA }} />Sem valor 2023</span>
        </div>
        <div className="dt-mapwrap">
            <svg viewBox="0 0 900 860" role="img" aria-label="Mapa coroplético do Brasil por município">
                {MUNS.map(m => {
                    const hide = (st.uf && m.u !== st.uf) || (st.regiao && m.r !== st.regiao);
                    if (hide) return null;
                    return <path key={m.c} d={m.d} fill={colorFor(m.v)}
                        className={'dt-mun' + (selSet.has(m.c) ? ' dt-sel' : '')}
                        onMouseEnter={() => setTooltip(m)} onMouseLeave={() => setTooltip(null)}
                        onClick={() => toggle(m.c)} />;
                })}
            </svg>
            {tooltip && <div className="dt-tip" role="status">
                <b>{tooltip.n}</b> ({tooltip.u})<br />
                {tooltip.v != null ? fmt(tooltip.v) : 'sem valor 2023'}<br />
                <span>{tooltip.r}</span>
            </div>}
        </div>
        <Caption>{saved.message}</Caption>
        <div className="dt-comparacao">
            <h3>Comparação ({selecionados.length})</h3>
            {selecionados.length === 0
                ? <p className="dt-muted">Clique em municípios no mapa ou na busca para comparar.</p>
                : <ul>{selecionados.map(m => <li key={m.c}>
                    <span><b>{m.n}</b> <span className="dt-muted">{m.u} · {m.r}</span></span>
                    <span>{m.v != null ? fmt(m.v) : 'sem valor'} <span className="dt-muted">{m.v != null ? (100 * (m.v as number) / TOTAL).toFixed(2) + '% do total' : ''}</span> <button type="button" className="dt-x" onClick={() => toggle(m.c)} aria-label={`Remover ${m.n}`}>✕</button></span>
                </li>)}</ul>}
        </div>
    </div>;
}

export function App() {
    return <FileCard>
        <Header
            title="O Dinheiro e o Território"
            fact="SICOR 2023 · Base dos Dados · 5.380 municípios"
            intro="Crédito rural com recurso público em 2023, todas as finalidades, territorializado por município do imóvel rural associado à operação (CAR): R$ 112,1 bilhões em 5.380 municípios. O valor de cada operação é rateado em partes iguais entre os imóveis associados a ela, hipótese neutra: o que aparece no mapa é valor rateado, não valor pago no município." />
        <Group label="O mapa interativo" heading>
            <MapaInterativo />
        </Group>
        <Group label="O mapa de uma vez" heading>
            <img src={mapaCover} alt="Mapa coroplético do Brasil com o valor rateado de crédito rural com recurso público em 2023 por município" className="dt-cover" />
            <Caption>Visão estática do mapa interativo acima, gerada do mesmo dado em 19/11/2026.</Caption>
        </Group>
        <Group label="Panorama 2023" heading>
            <Facts items={[
                { label: 'Total territorializado', value: 'R$ 112,1 bilhões (rateado)' },
                { label: 'Municípios com valor', value: '5.380 de 5.570' },
                { label: 'Cobertura do subtotal classificado', value: '92,56% de R$ 121,1 bilhões' },
                { label: 'Total de operações 2023', value: 'R$ 406,4 bilhões' },
                { label: 'Mediana por município', value: 'R$ 8,2 milhões' },
                { label: 'Maior valor', value: 'São Desidério-BA, R$ 622,6 milhões' },
                { label: 'Top 10 somam', value: 'R$ 4,4 bilhões (3,9% do total)' },
            ]} />
            <Callout title="Concentração" tone="info">O recurso público no crédito rural se concentra: metade dos municípios fica abaixo de R$ 8,2 milhões, enquanto o topo do ranking passa de R$ 600 milhões. Oeste da Bahia, norte do Mato Grosso e Matopiba aparecem como territórios de maior valor.</Callout>
        </Group>
        <Group label="Top 20" heading>
            <Rows>
                {top20.map((m, i) => <Row key={m.c} number={i + 1} name={m.n} detail={`${m.u} · ${m.r}`} value={fmt(m.v as number)} valueKnown />)}
            </Rows>
        </Group>
        <Group label="Fonte e método" heading>
            <Facts items={[
                { label: 'Fonte', value: 'SICOR/BCB via Base dos Dados (chatbot, executor oficial)' },
                { label: 'Recorte', value: "operações 2023 com indicador_recurso_publico = '1' (16 códigos: os 15 da lista oficial do BC + FNDCT/0911, sem operações em 2023)" },
                { label: 'Valor', value: 'operacao.valor_parcela_credito (id_referencia_bacen + numero_ordem)' },
                { label: 'Snapshot', value: 'mais recente por imóvel, nunca filtro global' },
                { label: 'Município', value: 'area_imovel.id_municipio (imóvel CAR associado à operação)' },
                { label: 'Rateio', value: 'igual entre os imóveis da operação (hipótese neutra)' },
                { label: 'Consultas', value: 'query_ref qr_8a918dd1 (mapa), qr_0ef8fb01 e qr_ceaa9c22 (cânone)' },
                { label: 'Mapa-base', value: 'malha municipal IBGE 2022' },
            ]} />
            <Callout title="Leitura honesta" tone="warning">Valor rateado ≠ valor pago ≠ local do benefício. O município é o do imóvel rural associado à operação, não necessariamente onde o recurso circula; a ligação operação-imóvel nos microdados é de associação ao financiamento, sem papel jurídico de garantia declarado. A seleção e os filtros ficam só neste dispositivo.</Callout>
        </Group>
        <Closing>Gerado em 19/11/2026 a partir do executor oficial da Base dos Dados. Nada é enviado ou alterado a partir desta página.</Closing>
    </FileCard>;
}
