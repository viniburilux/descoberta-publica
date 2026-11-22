import React from 'react';
import { Bullets, Callout, Caption, Closing, Facts, FileCard, Group, Header, NumberedList, Paragraph, Photos, Row, Rows, Text, TextLink } from '@instinct/files';
import mapa from './photos/mapa_entrega_canone_2023.png';

const sqlVerificado = `WITH operacoes AS (
  SELECT
    o.id_referencia_bacen,
    o.numero_ordem,
    o.valor_parcela_credito,
    CONCAT(SUBSTR(p.id_car, 1, 2), '-', SUBSTR(p.id_car, 3, 7), '-', SUBSTR(p.id_car, 10)) AS id_car
  FROM basedosdados.br_bcb_sicor.operacao AS o
  JOIN basedosdados.br_bcb_sicor.empreendimento AS e
    ON o.id_empreendimento = e.id_empreendimento
  JOIN basedosdados.br_bcb_sicor.fonte_recurso AS f
    ON o.id_fonte_recurso = f.id_fonte_recurso
  JOIN basedosdados.br_bcb_sicor.recurso_publico_propriedade AS p
    ON o.id_referencia_bacen = p.id_referencia_bacen
   AND o.numero_ordem = p.numero_ordem
   AND p.ano_emissao = 2022
  WHERE o.ano_emissao = 2022
    AND e.finalidade = 'Investimento'
    AND f.indicador_recurso_publico = '1'
    AND p.id_car IS NOT NULL
), operacoes_car AS (
  SELECT DISTINCT id_referencia_bacen, numero_ordem, valor_parcela_credito, id_car
  FROM operacoes
), rateio AS (
  SELECT
    oc.id_referencia_bacen,
    oc.numero_ordem,
    oc.id_car,
    SAFE_DIVIDE(oc.valor_parcela_credito, COUNT(*) OVER (PARTITION BY oc.id_referencia_bacen, oc.numero_ordem)) AS valor_rateado
  FROM operacoes_car AS oc
), car_atual AS (
  SELECT id_imovel, id_municipio
  FROM basedosdados.br_sfb_sicar.area_imovel
  WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
  QUALIFY ROW_NUMBER() OVER (PARTITION BY id_imovel ORDER BY data_extracao DESC) = 1
), por_municipio AS (
  SELECT
    m.id_municipio,
    m.nome,
    SUM(r.valor_rateado) AS valor_credito
  FROM rateio AS r
  JOIN car_atual AS c ON r.id_car = c.id_imovel
  JOIN basedosdados.br_bd_diretorios_brasil.municipio AS m USING (id_municipio)
  GROUP BY m.id_municipio, m.nome
), ranking AS (
  SELECT
    ROW_NUMBER() OVER (ORDER BY valor_credito DESC, nome) AS posicao,
    nome AS municipio,
    valor_credito,
    COUNT(*) OVER () AS numero_municipios,
    SUM(valor_credito) OVER () AS total_geral
  FROM por_municipio
)
SELECT 'TOTAL_GERAL' AS tipo_resultado, NULL AS posicao, NULL AS municipio,
       total_geral AS valor_credito, numero_municipios
FROM ranking WHERE posicao = 1
UNION ALL
SELECT 'TOP_10', posicao, municipio, valor_credito, numero_municipios
FROM ranking WHERE posicao <= 10
ORDER BY tipo_resultado, posicao`;

const numeros = [
    { label: 'Total rateado em 2023', value: 'R$ 112.125.325.594,22' },
    { label: 'Municípios com valor', value: '5.380' },
    { label: 'Cobertura do subtotal classificado', value: '92,56% de R$ 121,13 bi' },
    { label: 'Total SICOR 2023 (todas as fontes)', value: 'R$ 406,40 bi' },
    { label: 'Município com maior valor', value: 'São Desidério (BA), R$ 622,6 mi' },
];

const metodo = [
    'A tabela-ponte recurso_publico_propriedade liga operações a imóveis CAR, mas não tem coluna de valor.',
    'O valor está em operacao.valor_parcela_credito, ligado pela chave id_referencia_bacen + numero_ordem (única no SICOR 2023: 2.129.134 linhas = chaves).',
    'O id_car da ponte precisa de normalização (maiúsculas, sem hífens) para casar com area_imovel.id_imovel; equivalência das duas formas comprovada com 0 divergências em 489.138 imóveis.',
    'area_imovel tem vários snapshots por imóvel: usa-se o mais recente de cada imóvel dentro da janela (ROW_NUMBER por imóvel), nunca um filtro global pela data máxima.',
    'O valor da operação é dividido igualmente entre os imóveis CAR distintos ligados a ela; o município vem de area_imovel.id_municipio.',
];

const validacao = [
    { number: 1, name: 'Baseline em contexto separado correta', detail: 'Em thread separada, sem acesso à experiência registrada, a execução convergiu para o mesmo método: caso 2022 (investimento) R$ 48,29 bi, 5.241 municípios, 489.138 imóveis. Diagnósticos na mesma thread e executor não são auditoria independente.' },
    { number: 2, name: 'Erro de snapshot quantificado', detail: 'A leitura literal da regra de snapshot descartou 378.322 de 489.138 imóveis (-77%); o erro foi reproduzido, medido e corrigido no registro.' },
    { number: 3, name: 'Reparo confirmado', detail: 'Com o registro corrigido, a nova execução reproduziu a referência ao centavo (R$ 48.292.622.454,52) e o mesmo top-10.' },
];

const lacunas = [
    'Verificado item a item: os 15 códigos oficiais do FonteRecursosPublicos.csv (Banco Central) estão todos no recorte; o catálogo da Base dos Dados marca ainda o FNDCT (MP 1374) como recurso público, fonte sem nenhuma operação em 2023 — sem efeito nos valores desta página.',
    'Há uma discrepância de 1 no denominador da reconciliação SICOR × CAR, mantida aberta sem harmonização forçada.',
    'O rateio igual entre imóveis é a hipótese neutra; não usa área nem valor declarado de cada imóvel.',
    'CARs que cruzam limites municipais não receberam análise de sensibilidade.',
];

export function App() {
    return <FileCard lang="pt">
        <Header
            title="Crédito rural por município — SICOR 2023"
            fact="R$ 112,1 bi rateados · 5.380 municípios"
            factKnown
            intro="Rateio das operações de crédito rural de 2023 com fontes marcadas como recurso público no catálogo da Base dos Dados (indicador_recurso_publico = 1) pelos municípios dos imóveis rurais ligados às operações no CAR. Calculado no chatbot da Base dos Dados em 19 nov 2026."
        />
        <Photos label="Mapa do rateio por município" items={[{ src: mapa, alt: "Mapa coroplético do Brasil com o valor rateado de crédito rural por município em 2023, em escala logarítmica de verde" }]} />
        <Caption>Valor registrado rateado igualmente entre os imóveis CAR vinculados; não é valor pago nem local exato do benefício.</Caption>

        <Group label="Os números" heading>
            <Facts items={numeros} />
        </Group>

        <Group label="Como foi calculado" heading>
            <NumberedList items={metodo} />
        </Group>

        <Group label="Validação" heading>
            <Rows>{validacao.map(v => <Row key={v.number} number={v.number} name={v.name} detail={v.detail} />)}</Rows>
        </Group>

        <Group label="Lacunas abertas" heading>
            <Callout title="Antes de usar" tone="warning">
                O recorte foi verificado item a item contra a lista oficial do Banco Central: cobre os 15 códigos oficiais mais o FNDCT, fonte sem operações em 2023. Ainda assim, trate os valores como rateio desse recorte, não como “crédito público” oficial.
            </Callout>
            <Bullets items={lacunas} />
        </Group>

        <Group label="SQL verificado" heading>
            <Text>
                <Paragraph>Query executada e verificada no caso 2022 (investimento), thread de referência. O cânone 2023 usa o mesmo padrão com ano_emissao = 2023 e sem o filtro de finalidade.</Paragraph>
            </Text>
            <pre className="dossie-sql">{sqlVerificado}</pre>
        </Group>

        <Group label="Fontes e rastreio" heading>
            <Text>
                <Paragraph>Executor: <TextLink href="https://basedosdados.org/chatbot?t=35bbb638-d45b-425b-8d06-3b463679a9e4">thread do chatbot da Base dos Dados</TextLink> (query_refs qr_0ef8fb01, qr_ceaa9c22, qr_8a918dd1).</Paragraph>
                <Paragraph>Documentação das fontes de recurso: <TextLink href="https://geo-credito-rural.github.io/sicor/microdados/fontes-recursos.html">geo-credito-rural, Fontes de Recursos</TextLink>.</Paragraph>
                <Paragraph>Norma oficial do catálogo: <TextLink href="https://www.bcb.gov.br/estabilidadefinanceira/exibenormativo?numero=4901&tipo=Resolu%C3%A7%C3%A3o+CMN">Resolução CMN 4.901, Banco Central</TextLink>.</Paragraph>
            </Text>
        </Group>

        <Closing>Calculado em 19 nov 2026 no chatbot da Base dos Dados, a custo zero. Nada foi enviado ou publicado fora desta página.</Closing>
    </FileCard>;
}
