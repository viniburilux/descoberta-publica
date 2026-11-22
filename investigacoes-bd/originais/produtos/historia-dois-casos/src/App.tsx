import React from 'react';
import { Bullets, Callout, Caption, Closing, Facts, FileCard, Group, Header, KeySentence, Link, NavLink, Paragraph, Photos, Route, Routes, Row, Rows, TextLink } from '@instinct/files';

import rondon2011 from './photos/rondon-2011.png';
import rondon2017 from './photos/rondon-2017.png';

const rondonTimeline = [
    { date: '26/11/2015', event: 'Inscrição do micro #12, dentro do que depois seriam os dois CARs grandes. O micro tem hoje 8,98 m²; a geometria que ele tinha em 2015 não está documentada (não sabemos quando ficou minúsculo).' },
    { date: '01/12/2015', event: 'Inscrição do micro 2FA6A081 (onda 1).' },
    { date: '28/04/2016', event: 'Inscrição do CAR A (área declarada 1.350,22 ha).' },
    { date: '30/12/2016', event: 'Inscrição do micro A4DD4E93 (onda 1).' },
    { date: '07/05/2017', event: 'Inscrição do micro 34A1DD76 (onda 2).' },
    { date: '23/10/2020', event: 'Inscrição do micro 8A59FA27 (onda 1).' },
    { date: '27/10/2020', event: 'Inscrição do micro DAE50532 (onda 2).' },
    { date: '30/03/2021', event: 'Aprovação (campo data_aprovacao da camada SIGEF/INCRA) da parcela "Fazenda São Pedro - 001", cujo perímetro coincide com o do CAR A.' },
    { date: '06/06/2023', event: 'Última retificação do CAR A.' },
    { date: '04/11/2023', event: 'Último evento cadastral do micro #1 e de um segundo micro, hoje com 7 m², a 52,3 m dele (áreas atuais; quando ficaram minúsculos não está documentado). Os dois constam hoje como "Cancelado por decisão administrativa"; a data do ato de cancelamento em si não está documentada.' },
    { date: '02/04/2025', event: 'Retificação do micro 8A59FA27.' },
    { date: '03/04/2025', event: 'Retificação dos micros 2FA6A081 e A4DD4E93.' },
    { date: '15/04/2025', event: 'Retificação dos micros 34A1DD76 e DAE50532.' },
    { date: '16/04/2025', event: 'Retificação do micro #12.' },
    { date: '26/03/2026', event: 'Inscrição do CAR B (área declarada 1.288,09 ha), sem retificação posterior registrada.' },
];

const rondonTads = [
    { number: 1, name: 'TAD 127471 (auto de 31/03/2006)', detail: '725 ha declarados, mas a geometria oficial é apenas um ponto (polígono degenerado): nenhuma leitura espacial vale para os 725 ha. Micro #1 a 25,4-28,1 km; micro #12 a 2,6-3,8 km dos TADs.' },
    { number: 2, name: 'TAD 824790 (auto de 30/08/2010)', detail: '8,29 ha, 100% dentro do CAR A e do CAR B.' },
    { number: 3, name: 'TAD 836171 (auto de 23/12/2012)', detail: 'Campo oficial 376,2529 ha; o texto do auto diz "378,320 HA" (divergência registrada). O auto descreve vegetação nativa em regeneração. 370,6 ha dentro do CAR A e 344,8 ha dentro do CAR B (medida geodésica).' },
];

const sfcTimeline = [
    { date: '19/04/2002', event: 'Decreto sem número declara de interesse social a "Fazenda Bom Sucesso e outros" (1.519,6441 ha medidos) e autoriza a desapropriação. Autorizar não comprova conclusão. Processo INCRA/SR-05 nº 54160.001657/00-18.' },
    { date: '16/10/2003', event: 'Imissão de posse (consta da Portaria nº 40/2003).' },
    { date: '06/11/2003', event: 'Portaria INCRA/SR-05 (BA) nº 40 cria o "PA Faz Bom Sucesso e Outras", código SIPRA BA0369000, prevendo 34 unidades familiares. Processo de destinação 54160/002401/2003-41 (numeração distinta do processo de obtenção).' },
    { date: '18/11/2003', event: 'Publicação da Portaria nº 40 no DOU, Seção 1, nº 224, pág. 101. A edição de 06/11/2003 não contém o ato: 06/11 é a data da portaria, não a da publicação.' },
    { date: '06/03/2026', event: 'Relatório oficial INCRA/SIPRA nº 227 (p. 94): 1.519,6441 ha, 20 famílias de capacidade e 22 assentadas, Fase 04, ato nº 40 de 06/11/2003, obtenção por desapropriação em 19/04/2002.' },
];

function Overview() {
    return <>
        <Group label="O que foi investigado" heading>
            <Paragraph>Duas histórias de terra reconstruídas em fontes oficiais: o recorte de Rondon do Pará (PA), onde dois cadastros rurais grandes quase coincidentes convivem com micro-imóveis e três embargos do IBAMA, e o assentamento federal Bom Sucesso, em São Félix do Coribe (BA), cuja cadeia documental de 2002 a 2026 foi localizada ato a ato.</Paragraph>
            <KeySentence>Em Rondon, dois CARs de ~1.300 ha se sobrepõem 91-96% um ao outro; em SFC, o PA Bom Sucesso tem decreto, portaria de criação e relatório oficial de 2026 alinhados nos 1.519,6441 ha.</KeySentence>
        </Group>
        <Group label="Os dois casos">
            <Rows>
                <Row number={1} name="Rondon do Pará (PA)" detail="CAR A e CAR B quase coincidentes; micro #12, hoje de 8,98 m², 100% dentro dos dois; seis micros em duas ondas de retificação de abril/2025; três TADs IBAMA sobre a área, um deles sem polígono delimitado (só ponto)." />
                <Row number={2} name="Bom Sucesso, SFC (BA)" detail="PA federal SIPRA BA0369000: desapropriação autorizada em 2002, criação em 2003, relatório SIPRA de 2026 com 20 famílias de capacidade e 22 assentadas." />
            </Rows>
            <Link className="file-button is-compact" data-variant="secondary" to="/rondon">Rondon do Pará</Link>{' '}
            <Link className="file-button is-compact" data-variant="secondary" to="/sfc">Bom Sucesso (SFC)</Link>{' '}
            <Link className="file-button is-compact" data-variant="secondary" to="/vinte">Os 20 imóveis (tarde)</Link>
        </Group>
        <Group label="Perguntas em aberto" heading>
            <Bullets items={[
                'O que mudou em cada retificação dos micros e do CAR A (geometria? dados declarados?): os demonstrativos dizem quando, não o quê.',
                'A data exata do cancelamento do micro #1 e do vizinho de 7 m² (hoje só se sabe o último evento, 04/11/2023).',
                'O processo administrativo integral do INCRA e a geometria oficial do PA Bom Sucesso em fonte aberta.',
                'A tensão entre a queda de árvores na classificação automática de 10 m (CAR A) e o zero do PRODES de 2016 a 2025.',
                'O agregador aponta 43 imóveis sobrepostos ao perímetro do PA (lista nominal atrás de assinatura); cruzamento próprio nas camadas públicas conta 26 CARs com sobreposição de área e nenhuma parcela SIGEF (5 tangentes de borda), sem estabelecer o método do agregador.',
                'A rodada da tarde cobriu os 20 imóveis do TOP-20 em SIGEF, supressão, IBAMA e uso do solo: ver a página "Os 20 imóveis (tarde)".',
            ]} />
        </Group>
        <Callout title="Limites deste documento" tone="warning">É um documento de trabalho, não a história completa: cada caso lista suas pendências. PRODES só mede corte raso de vegetação primária acima de ~6,25 ha, então ausência de feição não prova ausência de supressão. Nenhum achado aqui é conclusão de irregularidade. O funil inicial (797.183 imóveis, TOP-20) é saída de chatbot de dados, não auditada.</Callout>
    </>;
}

function Rondon() {
    return <>
        <Group label="Linha do tempo cadastral" heading>
            <Rows>
                {rondonTimeline.map((t, i) => <Row key={t.date + i} number={i + 1} name={t.date} detail={t.event} />)}
            </Rows>
            <Caption>Fonte: demonstrativos oficiais car.gov.br/#/consultar (leitura da página oficial) e SICAR WFS. Nos 9 demonstrativos verificados, a data do WFS correspondeu ao último evento (inscrição ou retificação).</Caption>
        </Group>
        <Group label="Geometria" heading>
            <Bullets items={[
                'CAR A ∩ CAR B: 91,6% de A dentro de B e 96,1% de B dentro de A (medida geodésica WGS84, reproduzida por revisão independente).',
                'Micro #12 (geometria atual de 8,98 m²): 100% dentro de A e de B.',
                'Duas ondas de micros: trios a 5,0/5,1/10,1 m entre si (retificados em 02-03/04/2025) e 3,9/4,0/7,9 m (15-16/04/2025); os grupos a ~893 m um do outro.',
                'Os demonstrativos dizem "Nenhuma sobreposição encontrada" (texto literal); o que essa checagem do sistema abrange não está verificado.',
            ]} />
        </Group>
        <Group label="Registros fundiários (SIGEF/INCRA)" heading>
            <Bullets items={[
                'O CAR A está inteiro dentro da parcela SIGEF "FAZENDA SÃO PEDRO - 001" (1.347,8014 ha nominais, natureza "Particular"): interseção de 1.350,22 ha, ou 100% da geometria do CAR A e 100% da geometria medida da parcela (0,2% acima da área nominal). Perímetros coincidentes. Campos da camada: status "TITULACAO", situacao_informada "NAO_TITULADA", data_aprovacao 30/03/2021, sem matrícula registrada. São valores literais dos campos, não comprovação de titulação concluída.',
                'A interseção da mesma parcela com o CAR B é de 1.237,48 ha: 96,1% da geometria do CAR B (1.288,09 ha) e 91,8% da área nominal da parcela.',
                'A parcela "GLEBA RONDON A - Parte 1" (7.892,91 ha, natureza "Gleba Pública") tem os campos: status "APROVACAO_FISCAL", situacao_informada "REGISTRADA", matrícula 4081, CNS 06.735-5, data_aprovacao 20/05/2021. Ela sobrepõe o CAR A em 31,24 ha; o que essa sobreposição representa não está estabelecido.',
                'As demais parcelas SIGEF do recorte só tocam bordas (até 0,35 ha).',
            ]} />
            <Caption>Cruzamento próprio na camada geonode:sigef_geo (GeoNode INCRA, geoportal.incra.gov.br), consulta de 20/11/2026, interseção real de geometrias em UTM 22S.</Caption>
        </Group>
        <Group label="Embargos IBAMA (TADs)" heading>
            <Rows>
                {rondonTads.map((t) => <Row key={t.number} number={t.number} name={t.name} detail={t.detail} />)}
            </Rows>
            <Caption>Situação: os três constam "Lavrado", sem cancelamento e sem desembargo registrado; zero decisões localizadas. Nomes e CPF/CNPJ dos embargados ficam fora deste documento.</Caption>
        </Group>
        <Group label="Cobertura do território" heading>
            <Bullets items={[
                'PRODES Amazônia (corte raso de vegetação primária): 7 feições no recorte dos CARs (2008, 2009×2, 2010×2, 2013, 2015). Dessas, 6 intersectam os CARs A e B; a de 2013 está no recorte mas não toca nenhum dos dois. Soma dentro: A = 114,60 ha; B = 119,54 ha. Nenhuma feição de 2016 a 2025.',
                'DETER (alertas, 2016+): nenhuma feição detectada no recorte exato consultado dos CARs A/B.',
                'Classificação automática de uso do solo 10 m (Esri/Impact Observatory/Microsoft): a classe "Árvores" do CAR A cai de ~910 ha (2017) para ~653 ha (2024). É tendência de classificação, não desmate comprovado; a tensão com o zero do PRODES segue aberta.',
                'Comparativo visual por satélite: só existe 2011 × 2017 para esta área (o Wayback não tem capturas de 2020/2024 aqui).',
            ]} />
        </Group>
        <Photos label="Satélite sobre os CARs A/B" title="2011 × 2017" items={[
            { src: rondon2011, alt: 'Imagem de satélite da área dos CARs A/B, captura de 15/07/2011' },
            { src: rondon2017, alt: 'Mesma área, captura de 26/06/2017' },
        ]} />
        <Caption>Recortes reais da área dos CARs A/B em Rondon do Pará (centro ≈ -48,03, -4,70), capturas de 15/07/2011 e 26/06/2017 (Esri World Imagery Wayback; datas confirmadas no serviço de metadados). Ilustrativo: sensores e estações diferem.</Caption>
        <Group label="Fontes" heading>
            <Paragraph><TextLink href="https://geoserver.car.gov.br/geoserver/sicar/ows">SICAR WFS (status e geometrias)</TextLink></Paragraph>
            <Paragraph><TextLink href="https://car.gov.br/#/consultar/PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56">Demonstrativo oficial do CAR A (car.gov.br)</TextLink></Paragraph>
            <Paragraph><TextLink href="https://car.gov.br/#/consultar/PA-1506187-48EDE9CDCF3947959921871671228876">Demonstrativo oficial do CAR B (car.gov.br)</TextLink></Paragraph>
            <Paragraph><TextLink href="https://terrabrasilis.dpi.inpe.br/geoserver/ows">PRODES/DETER (terrabrasilis, INPE)</TextLink></Paragraph>
            <Paragraph><TextLink href="https://geoportal.incra.gov.br/geoserver/ows">SIGEF GeoNode INCRA, camada sigef_geo (geoportal.incra.gov.br)</TextLink></Paragraph>
        </Group>
        <Callout title="O que falta" tone="warning">Demonstrativos oficiais dos outros 18 alvos (rota com captcha, parada); conteúdo das retificações; dicionários SICAR/IBAMA; reconciliação LULC × PRODES.</Callout>
    </>;
}

const vinteResumo = [
    { number: 1, name: 'Rondon do Pará (PA): dois ambientes', detail: 'O micro #1 (cancelado) está dentro da parcela SIGEF "GLEBA RONDON C - Parte 1" (47.856 ha, natureza "Gleba Pública", matrícula 4078), e o CAR vizinho de 1.029 ha está 100% contido nela. Já os 6 micros das ondas 2015-2020 e os centróides dos CARs A/B caem dentro de parcelas de natureza "Particular" ("Fazenda São Pedro - 001", sem matrícula; "Fazenda Alto Bonito - Gleba A", matrícula 10603). Natureza e matrícula são campos da camada, não comprovação de titularidade.' },
    { number: 2, name: 'Ponta Porã (MS)', detail: 'O micro #2 está fora de qualquer parcela SIGEF (mais próxima a 1,7 m), mas dentro de 2 CARs. O CAR de 195,9 ha coincide, na medida calculada, com a união de duas parcelas registradas (matrículas 61.444 e 66.753); o CAR de 504,7 ha sobrepõe outras parcelas registradas do mesmo complexo.' },
    { number: 3, name: 'Tuparendi (RS): lotes coloniais', detail: 'Os 4 CARs pares dos micros estão na malha de lotes rurais da colônia Santo Cristo. Os pares de #15 e #19 coincidem 99,6-99,9% com frações certificadas (matrículas 4770 e 5058, áreas idênticas de 39,275 ha e 23,7 ha). Os pares de #10 e #14 não têm contraparte encontrada no recorte SIGEF consultado: tangenciam frações certificadas vizinhas sem sobrepor.' },
    { number: 4, name: 'Bahia (10 micros)', detail: '#5 a 0,1 m de parcela registrada (matrícula 18281). Em SFC: o CAR vizinho de #6 coincide 100% com a parcela certificada "Fazenda Barriguda - Parte 2" (matrícula 10395), e #9 fica a 21,3 m de parcela registrada (matrícula 18480). #3 Rio Maria (PA): interstício entre CARs grandes, sem parcela SIGEF a menos de 2,6 km.' },
];

function Vinte() {
    return <>
        <Group label="O que esta rodada cobriu" heading>
            <Paragraph>Levantamento da tarde de 20/11 sobre os 20 imóveis do TOP-20: consulta SIGEF/INCRA própria para cada um dos 18 que ainda não tinham recorte examinado (os outros 2 já tinham), supressão medida com o produto do bioma correto em cada ponto, embargos e autos do IBAMA por geometria completa, e classificação de uso do solo dos polígonos-chave. Tudo em fontes oficiais abertas, sem custo.</Paragraph>
            <KeySentence>Nenhum dos 20 pontos está dentro de polígono embargado do IBAMA (dos 60.327 TADs com geometria publicada; 57.075 sem geometria ficam fora dessa verificação), e nenhum está sobre feição recente de supressão mapeada.</KeySentence>
        </Group>
        <Group label="Registros fundiários por grupo" heading>
            <Rows>
                {vinteResumo.map((t) => <Row key={t.number} number={t.number} name={t.name} detail={t.detail} />)}
            </Rows>
            <Caption>Cruzamento próprio, geonode:sigef_geo (GeoNode INCRA), 20/11/2026, interseções e distâncias geodésicas de geometrias completas. Interseção SIGEF, matrícula ou certificação não provam titularidade atual, irregularidade ou vínculo com financiamento.</Caption>
        </Group>
        <Group label="Supressão (produto, resolução e alvo explícitos)" heading>
            <Bullets items={[
                'Mata Atlântica (PRODES-MA, Landsat ~30 m): nenhum dos 4 micros de Tuparendi sobre feição; as mais próximas a 511 m-1.324 m, anos 2010-2018.',
                'Caatinga (PRODES Caatinga): os pontos de #16 (Itapicuru) e #6 (SFC) caem dentro de feições cujo ano mapeado pelo produto é 2004; #9 (SFC) tem feição de 2024 a 83 m, a supressão recente mais próxima entre os 20; demais pontos a 28-582 m (anos 2004-2025). Ponto de 1 m² dentro de polígono de hectares não é medida do micro.',
                'Cerrado (PRODES Cerrado): #5 com feição de 2002 a 468 m; o trio SFC não tem feição nessa camada (o município é coberto pelo produto Caatinga). DETER-Cerrado: #5 com um alerta de 2019 a 888 m; #6/#9/#17 sem alerta num raio de ~1,1 km.',
                'Amazônia (#1, #3, #12): já cobertos na rodada anterior (nada sobre os micros; entorno com feições antigas).',
            ]} />
            <Caption>Controles positivos e negativos executados na mesma sessão de cada consulta (a ordem de eixos do serviço não é estável).</Caption>
        </Group>
        <Group label="IBAMA na vizinhança" heading>
            <Bullets items={[
                'Contenção completa: ponto-em-polígono dos 20 micros contra todos os 60.327 termos de embargo com geometria WKT no CSV oficial de dados abertos (de 117.403 registros): zero contenções.',
                'Vizinhança (centróide a até 5 km): 12 TADs perto de 5 micros (#1, #2, #5, #12, #20). Novos em relação à rodada da madrugada: um TAD de 05/02/2026 (387,24 ha, já desembargado) a 4,65 km de #1; um quarto TAD de Rondon (2008) a 1,87 km de #12; quatro TADs de 2022 perto de #5; um TAD de 2010 (100,8 ha) a 1,61 km de #20.',
                'Autos de infração: 27 únicos a até 5 km, incluindo um auto de 2026 (corte raso de 387,241 ha) a 4,65 km de #1, mesma área do TAD desembargado, e um conjunto de 10 autos em torno de #12 (carvão, cortes de 2008-2012, descumprimento de embargo em 2023, impedimento de regeneração até 2025).',
                'Fiscalização na vizinhança é contexto territorial; não demonstra vínculo com os micros, com os CARs ou com financiamento.',
            ]} />
            <Caption>Dados abertos IBAMA (baixados 20/11/2026). Nomes e CPF/CNPJ de autuados ficam fora deste documento.</Caption>
        </Group>
        <Group label="Uso do solo dos polígonos-chave (modelo 10 m)" heading>
            <Bullets items={[
                'Pares de Tuparendi: estáveis de 2017 a 2024, ~85-95% "Cultivo" com fração pequena e estável de "Árvores": compatível com lote agrícola colonial consolidado, sem sinal de conversão na série.',
                'CAR de 504,7 ha (Ponta Porã): "Árvores" de 221,1 ha para 200,2 ha, com degrau em 2022, e "Cultivo" +27 ha. É mudança de classe do modelo, não desmate comprovado; DETER-Cerrado não tem alerta sobre o micro e o PRODES-Cerrado não tem nada de 2008 em diante num raio de 1 km.',
                'CAR de 195,9 ha: "Cultivo" de 126 para 158 ha, "Árvores" estável ~36 ha (classe "Neve" de 35 ha em 2017 é artefato do modelo nos trópicos).',
            ]} />
            <Caption>Classificação automática Sentinel-2 10 m (Esri/Impact Observatory/Microsoft), série 2017-2024, método geodésico por linha de latitude.</Caption>
        </Group>
        <Group label="Inscrição × última modificação, os 18 restantes (Base dos Dados, noite)" heading>
            <Paragraph>Rota sugerida pelo autor do pedido: o chatbot da Base dos Dados consulta o dataset br_sfb_sicar (Serviço Florestal Brasileiro). A tabela area_imovel separa data_criacao (metadado: "Data de inscrição do imóvel no CAR") de data_atualizacao ("Data da última modificação dos dados do imóvel no CAR"). Snapshot mais recente por imóvel: 01 a 03/08/2026, por UF.</Paragraph>
            <Rows>
                <Row number={1} name="#1 PA: inscrito 20/11/2015" detail="Última modificação 03/11/2023. Status PE, aguardando análise." />
                <Row number={2} name="#2 MS: inscrito 21/12/2017" detail="Última modificação 03/04/2024. Status AT." />
                <Row number={3} name="#3 PA: inscrito 20/05/2016" detail="Última modificação 18/10/2025. Status PE, analisado, aguardando atendimento a notificação." />
                <Row number={4} name="#4 BA: inscrito 02/03/2023" detail="Última modificação 19/09/2025. AT." />
                <Row number={5} name="#5 BA: inscrito 18/06/2020" detail="Última modificação 29/07/2025. AT." />
                <Row number={6} name="#6 BA: inscrito 03/09/2019" detail="Última modificação 29/11/2024. AT." />
                <Row number={8} name="#8 BA: inscrito 09/10/2021" detail="Última modificação 11/10/2025. AT." />
                <Row number={9} name="#9 BA: inscrito 10/12/2019" detail="Última modificação 12/03/2025. AT." />
                <Row number={10} name="#10 RS: inscrito 17/12/2015" detail="Última modificação 10/05/2025. AT." />
                <Row number={11} name="#11 BA: inscrito 05/03/2020" detail="Última modificação 03/07/2024. AT." />
                <Row number={13} name="#13 BA: inscrito 23/06/2022" detail="Última modificação 26/04/2025. AT." />
                <Row number={14} name="#14 RS: inscrito 19/01/2016" detail="Última modificação 02/10/2024. AT." />
                <Row number={15} name="#15 RS: inscrito 05/03/2016" detail="Última modificação 07/05/2025. AT." />
                <Row number={16} name="#16 BA: inscrito 12/08/2018" detail="Última modificação 11/03/2024. AT." />
                <Row number={17} name="#17 BA: inscrito 22/04/2019" detail="Última modificação 10/11/2025. AT." />
                <Row number={18} name="#18 BA: inscrito 27/10/2017" detail="Última modificação 06/11/2025. AT." />
                <Row number={19} name="#19 RS: inscrito 27/01/2016" detail="Última modificação 16/07/2026. AT." />
                <Row number={20} name="#20 BA: inscrito 15/03/2023" detail="Última modificação 18/12/2024. AT." />
            </Rows>
            <Caption>Os 18 IDs restantes; #7 e #12 já tinham demonstrativo oficial e as datas batem. Todos IRU. Padrão nos 18: inscrições de 2015 a 2023; o campo dat_criacao do WFS consultado na madrugada correspondia à data da última modificação, não à da inscrição. "Última modificação" é um rótulo de campo do snapshot: não prova retificação formal nem revela histórico completo. Controle de qualidade na mesma sessão: 9 IDs com demonstrativo oficial da madrugada tiveram as duas datas idênticas na BD (9/9); única divergência foi de status, não de data: 8A59FA27 consta PE/aguardando análise no snapshot de 03/08/2026, mas seu demonstrativo de 20/11 dizia "Cancelado por decisão administrativa" (mudança posterior ao snapshot ou diferença de campo; não resolvido). As tabelas temáticas app e reserva_legal têm polígonos e áreas somáveis por imóvel (conferidos na seção seguinte); não há tabela de histórico de retificações. Buscas por INCRA/SIGEF/SIPRA/assentamentos não localizaram dataset no catálogo consultado. CSVs executados e resposta completa preservados no pacote de raws.</Caption>
        </Group>
        <Group label="Áreas ambientais declaradas: APP e Reserva Legal (Base dos Dados, noite)" heading>
            <Paragraph>Mesmas tabelas temáticas do dataset br_sfb_sicar (app e reserva_legal), snapshot mais recente por imóvel (01 a 03/08/2026), com SQL executado sobre as geometrias (ST_UNION_AGG e ST_INTERSECTION). Isto é declaração cadastral do próprio declarante no SICAR: não é condição ambiental observada nem comprovação de cobertura vegetal, e "proposta" não é averbada.</Paragraph>
            <Rows>
                <Row number={1} name="13 micros: só Reserva Legal proposta, 100% contida no imóvel" detail="#4 a #9, #11, #13, #14, #16, #17, #18 e #20. O polígono de RL está integralmente dentro do polígono do próprio imóvel (contenção medida na geometria, não igualdade de áreas arredondadas), com área geométrica de 0,6 a 1,8 m² contra ~1-2 m² declarados para o imóvel. Condição das geometrias: aguardando análise." />
                <Row number={2} name="#2 (MS): APP declarada inteiramente fora do imóvel" detail="APP a recompor de rios de até 10 m, 2,1251 ha, com interseção geométrica zero com o polígono do imóvel (que tem 1 m²). Inconsistência da declaração; causa não estabelecida." />
                <Row number={3} name="6 micros sem polígono ambiental no snapshot" detail="#1, #3, #10, #12, #15 e #19 não têm geometria nas tabelas app e reserva_legal no snapshot consultado." />
                <Row number={4} name="Rondon: as RLs dos dois CARs quase se coincidem" detail="CAR A declara RL proposta de 623,05 ha geométricos (621,48 declarados) mais 99 geometrias de APP (0,77 ha, nascentes); CAR B declara 653,35 ha geométricos (651,70 declarados) mais 15 APPs (1,82 ha, rios). A interseção entre as duas RLs é 583,74 ha: 93,7% da RL de A e 89,3% da de B. Condição das geometrias de B: analisado, aguardando atendimento a notificação; as de A: aguardando análise." />
            </Rows>
            <Caption>CSVs executados preservados no pacote de raws (4 arquivos). A narrativa do chatbot divergiu do CSV numa contagem (12 BA, não dez); vale sempre o CSV. Área declarada e área geométrica calculada divergem levemente nos CARs A/B. Sobreposição ou contenção de polígonos declarados não demonstra intenção, fraude ou vínculo com financiamento.</Caption>
        </Group>
        <Group label="Fonte desta seção" heading>
            <Paragraph><TextLink href="https://basedosdados.org/chatbot?t=430dfb1d-63f9-4901-b181-963177941355">Conversa real do chatbot BD com as consultas executadas (basedosdados.org)</TextLink></Paragraph>
        </Group>
        <Callout title="O que segue aberto" tone="warning">Conteúdo das retificações e o demonstrativo como documento oficial (rota car.gov.br testada e funcional de madrugada, instável à tarde; os 9 obtidos de madrugada seguem válidos); geometria primária do INCRA para o PA Bom Sucesso; processo administrativo integral; MapBiomas por polígono (rota raster via Google Earth Engine não testada; conta exigida, disponibilidade e custo não verificados); a leitura dos pares de Tuparendi (#10/#14 sem contraparte) é hipótese de leitura a confirmar no demonstrativo.</Callout>
    </>;
}

function Sfc() {
    return <>
        <Group label="Linha do tempo documental" heading>
            <Rows>
                {sfcTimeline.map((t, i) => <Row key={t.date + i} number={i + 1} name={t.date} detail={t.event} />)}
            </Rows>
            <Caption>Cadeia reconstruída em fontes primárias: Planalto (2002), Imprensa Nacional (2003) e INCRA/SIPRA (2026).</Caption>
        </Group>
        <Group label="Números que convivem" heading>
            <Bullets items={[
                'Famílias: 34 unidades previstas no ato de 2003 → 20 de capacidade e 22 assentadas no SIPRA de março/2026 (a tabela UFBA de 2020 dizia 20/20). Evolução documental registrada, causa não estabelecida.',
                'Área: 1.519,6441 ha no decreto (2002), na portaria (2003) e no SIPRA (2026). Um agregador mostra 1.514,39 ha, possivelmente a medida da geometria atual (hipótese, não causa provada).',
                'Fase: "Fase 04" no SIPRA oficial e no espelho geográfico; prevalece o SIPRA.',
            ]} />
        </Group>
        <Group label="Recorte territorial" heading>
            <Bullets items={[
                'PRODES Caatinga sobre o perímetro (espelho FUNAI): 90 feições, ~448,9 ha acumulados, com registros em 2004, 2006, 2008, 2010, 2013, 2014 e 2016-2024; nenhuma dentro do perímetro em 2025. Ausência de feição não prova ausência de supressão.',
                'Cruzamento próprio nas camadas públicas (SICAR + SIGEF GeoNode INCRA, 20/11, sobre o perímetro espelho): 55 CARs no entorno imediato; 26 com sobreposição de área real (>1 m²): 2 do tipo "AST" cobrindo ~100% do PA (1.519,53 ha, criado em 05/05/2016; 1.513,57 ha, criado em 21/05/2025; ambos com status AT, condição "Aguardando análise"), 18 IRU de 33-42 ha (escala de lote), 1 IRU de 336 ha e 5 toques marginais (<0,15 ha).',
                'SIGEF (GeoNode INCRA): nenhuma parcela com sobreposição de área; 5 parcelas com campo status "CERTIFICADA" apenas tangenciam o limite (0-2 m).',
                'Agregador (fonte secundária): 43 imóveis sobrepostos ao perímetro do PA (38 CAR + 5 SIGEF), lista nominal não acessada. O método do agregador não está estabelecido e a nossa contagem por área real difere da dele.',
                'Explicação possível, sem fonte normativa própria recuperada nesta execução: lotes de assentamento inscritos no CAR como fluxo regular de cadastro. Permanece hipótese de leitura.',
                'Micros do TOP-20 no município: centróide do #7 a ~14 m do limite do PA (inscrição 14/10/2019, retificação 01/07/2026); sem a geometria do micro, é proximidade de ponto representativo, não toque nem contenção; #6, #9 e #17 a poucos metros de CARs de 9 a 244 ha.',
            ]} />
        </Group>
        <Group label="Segundo espelho com fonte declarada (20/11, tarde)" heading>
            <Bullets items={[
                'A camada de assentamentos do GeoServer público do MapBiomas (WFS, camada mapbiomas-brasil:settlement, campos literais SOURCE="INCRA" e VERSION=2) tem o polígono "PA FAZ BOM SUCESSO E OUTRAS": 1.514,78 ha medidos sobre a geometria.',
                'Convergência: oficial SIPRA 1.519,6441 ha; este espelho 1.514,78 ha; o espelho anterior 1.514,39 ha. Os dois espelhos podem derivar da mesma base INCRA, então a convergência não demonstra geometrias independentes; a diferença de 0,3% explicada por simplificação de vértices é hipótese. Continua sem geometria primária do INCRA em fonte aberta: é corroboração limitada, não documento oficial.',
                'O centróide do micro #7 fica a 12,8 m do limite do PA nesta camada (14 m no espelho anterior): proximidade do ponto representativo, não medida polígono a polígono. Sem a geometria do micro, não se conclui toque nem sobreposição; e a área do assentamento não é a área de nenhum imóvel rural individual.',
            ]} />
            <Caption>Consulta WFS observada em 20/11/2026 ~16h47, recorte de ~10 km em torno do PA; a outra feição do recorte é o vizinho PA Pedra Branca.</Caption>
        </Group>
        <Group label="Fontes" heading>
            <Paragraph><TextLink href="https://www.planalto.gov.br/ccivil_03/dnn/2002/dnn9543.htm">Decreto de 19/04/2002 (planalto.gov.br)</TextLink></Paragraph>
            <Paragraph><TextLink href="https://pesquisa.in.gov.br/imprensa/jsp/visualiza/index.jsp?jornal=1&pagina=101&data=18/11/2003">Portaria nº 40, DOU 18/11/2003, Seção 1, p. 101 (Imprensa Nacional)</TextLink></Paragraph>
            <Paragraph><TextLink href="https://www.gov.br/incra/pt-br/assuntos/reforma-agraria/assentamentosgeral.pdf">Relatório SIPRA/INCRA, linha na p. 94 (gov.br)</TextLink></Paragraph>
            <Paragraph><TextLink href="https://geoserver.car.gov.br/geoserver/sicar/ows">SICAR WFS, camada BA (geoserver.car.gov.br)</TextLink></Paragraph>
            <Paragraph><TextLink href="https://geoportal.incra.gov.br/geoserver/ows">SIGEF GeoNode INCRA, camada sigef_geo (geoportal.incra.gov.br)</TextLink></Paragraph>
            <Paragraph><TextLink href="https://shared-geoserver.mapbiomas.org/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=mapbiomas-brasil:settlement&outputFormat=application/json&srsName=EPSG:4326&bbox=-44.12,-13.58,-43.98,-13.44,EPSG:4326">GeoServer MapBiomas, camada de assentamentos (WFS, fonte declarada INCRA): consulta real usada</TextLink></Paragraph>
        </Group>
        <Callout title="Homônimos e pendências" tone="warning">Há outro "Bom Sucesso" em Pedro Alexandre/BA e um processo de número-base idêntico em Itamaraju/BA; os cruzamentos usam o sufixo /00-18 + SFC. Falta: processo administrativo integral do INCRA, geometria primária do INCRA em fonte aberta (dois espelhos independentes convergem em ~1.514 ha; ver "Segundo espelho") e a lista nominal dos 43 do agregador.</Callout>
    </>;
}

export function App() {
    return <FileCard>
        <Header
            title="A história territorial dos dois casos"
            fact="20/11/2026 · documento privado de trabalho"
            intro="Duas histórias de terra em fontes oficiais: Rondon do Pará (PA) e o assentamento Bom Sucesso (BA). Com datas, documentos e o que ainda falta saber."
        />
        <nav className="file-nav" aria-label="File pages">
            <NavLink to="/" end>Visão geral</NavLink>
            <NavLink to="/rondon">Rondon do Pará</NavLink>
            <NavLink to="/sfc">Bom Sucesso (SFC)</NavLink>
            <NavLink to="/vinte">Os 20 imóveis</NavLink>
        </nav>
        <Routes>
            <Route path="/" element={<Overview />} />
            <Route path="/rondon" element={<Rondon />} />
            <Route path="/sfc" element={<Sfc />} />
            <Route path="/vinte" element={<Vinte />} />
        </Routes>
        <Closing>Documento de trabalho, 20/11/2026. Não é a história completa: as pendências estão listadas em cada caso. Nenhuma conclusão de irregularidade.</Closing>
    </FileCard>;
}
