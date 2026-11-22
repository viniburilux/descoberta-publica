# Aprofundamento dos 20 imóveis outlier — síntese consolidada
Data: 2026-11-20 ~01:30 (-03). Executor: task agent OPERAÇÃO BD. Escopo: pedido WhatsApp 20/11 00h36.
Documento de trabalho privado. Não é dossiê de pessoas: nomes/CPFs de embargados ficaram no staging local e fora de relatórios.

## 1. Funil corrigido (thread nova, chatbot BD, 20/11)
- Base: 797.183 imóveis / 5.380 municípios / R$ 112.125.325.594,22 (bate exato com o cânone T7).
- Razão APP+RL > 100%: 76.720-76.721 imóveis / R$ 18.299.202.226,50.
- Micros <1 ha dentro de >100%: 4.624 / R$ 542.158.616,68.
- TOP-20 refeito: os mesmos 20 imóveis, mesma ordem; nenhum excluído.
- Oscilação ±1 (76.720→76.721) entre execuções minutos apart; mesma família do ±N 138.032→138.034. Hipótese: append contínuo na base BD.
- Thread nova: https://basedosdados.org/chatbot?t=430dfb1d-63f9-4901-b181-963177941355 (original a6ea1581 intocada).

## 2. Errata de escala da thread original
- A thread rotulou razão-em-vezes como porcentagem (subestima 100×). Correto: #12 = 448.700 vezes = 44.870.000%; #1 = 3.189.295 vezes ≈ 318.929.464%.

## 3. Status ao vivo dos 20 no SICAR (consulta WFS 20/11/2026)
- 17 AT "Aguardando análise"; 2 PE "Analisado, aguardando atendimento a notificação" (#3, #12); 1 CA "Cancelado por decisão administrativa" (#1, atualizado 2026-08-29).
- Todos criados entre 2023-11 e 2026-07 — cadastros recentes; nenhum anterior a 2023.
- Evidência: status20_live.json.

## 4. Rondon do Pará-PA (micros #1 e #12 + 3 TADs IBAMA)
### 4.1 Reconciliação espacial
- Nenhum TAD toca o micro #1 (25,5-28,3 km de distância). Não há relação de entorno; menções anteriores a proximidade estavam erradas.
- Micro #12 (PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98, 0,0009 ha = 9 m², criado 2025-04-16, PE) tem 100% da geometria dentro de DOIS CARs grandes quase-gêmeos:
  - PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56: 1.350,22 ha, PE, criado 2023-06-06, atualizado 2026-09-03.
  - PA-1506187-48EDE9CDCF3947959921871671228876: 1.288,09 ha, SU, criado 2026-03-27, atualizado 2026-07-20.
  - Sobreposição entre eles: 91,7% de A em B; 96,1% de B em A.
- Os 3 TADs (geometrias oficiais pamgia) intersectam esse mesmo par: TAD 824790 (8,29 ha) 100% dentro dos dois; TAD 836171 (376,3 ha) com 373,0 ha e 347,0 ha dentro de cada um (+bordas em 5 CARs menores); TAD 127471 (pontual) dentro dos dois. Distância micro #12 ↔ TADs ≈ 4 km.

### 4.2 Ondas de micro-cadastros no mesmo ponto
- 2025-04-03: três CARs de 0,0025 ha (25 m²) lado a lado (~5 m entre centros), todos CA (cancelados): 8A59FA27..., 2FA6A081..., A4DD4E93...
- 2025-04-16 (13 dias depois): três CARs de 0,0009 ha (9 m²) lado a lado (~3-4 m), ~900 m a oeste, todos PE: 34A1DD76..., DAE50532..., CEAD1A3A... (este último = micro #12).
- Padrão territorial de micro-fragmentação cadastral em sequência; apenas observação geométrica, sem leitura jurídica.

### 4.3 TADs IBAMA (dados abertos oficiais, 20/11/2026)
- Situação nos arquivos consultados: DES_STATUS_FORMULARIO="Lavrado", SIT_CANCELADO="N" nos 3; campos SIT_DESEMBARGO/TIPO_DESEMBARGO/DAT_DESEMBARGO vazios; zero decisões judiciais na tabela de decisões. Formulação mantida: "nenhum desembargo ou cancelamento registrado nos arquivos oficiais consultados".
- Tutorial oficial IBAMA descreve a lista pública como "embargos vigentes": https://www.gov.br/ibama/pt-br/servicos/consultas/autuacoes-e-embargos/areas-embargadas/2025-03-14_tutorial_pesquisa_termos_de_embargo.pdf
- Lavraturas: 31/03/2006 (353599-C, 725 ha), 30/08/2010 (222609-C, 8,29 ha, Faz. Rio d'Ouro, Operação Arco de Fogo PA), 23/12/2012 (622619-C, 376,25 ha, Faz. Nova Jerusalem).
- Histórico (14 eventos): alterações em 2016 (2×), 15/12/2023 (3× por TAD, sem justificativa registrada), 22/01/2025 (justificativa: transferência de unidade administrativa para DIFIS-Belém). Nenhuma alterou o status. Coincidência 04/07/2016 com DAT_ULT_ALTER_GEOM: compatível com migração em lote — hipótese sem registro explícito.
- Dicionário de dados: não lido (POST + Cloudflare). Limitação declarada.
- Fontes: https://dadosabertos.ibama.gov.br/dataset/fiscalizacao-termo-de-embargo e CSVs stibamadadosabertosprd.blob.core.windows.net (termo_de_embargo.csv 215 MB; termo_embargo_historico.csv 736 MB; termo_embargo_decisao.csv 126 KB). Consulta pública: https://servicos.ibama.gov.br/ctf/publico/areasembargadas/ConsultaPublicaAreasEmbargadas.php

## 5. Assentamento PA FAZ BOM SUCESSO E OUTRAS × micro #7
- Micro #7 = BA-2929057-C5D11EE026A64399A6EF36764E8739E9 (0,0001 ha = 1 m², criado 2026-07-01, AT).
- Relação: ADJACÊNCIA (14 m do limite NE do assentamento). ZERO micros <1 ha dentro do polígono. Não é contenção.
- Ato oficial primário: Decreto de 19/04/2002 (sem número), https://www.planalto.gov.br/ccivil_03/dnn/2002/dnn9543.htm — declara de interesse social para reforma agrária a "Fazenda Bom Sucesso e outros" (área medida 1.519,6441 ha, São Félix do Coribe, Processo INCRA/SR-05/nº 54160.001657/00-18) e autoriza o INCRA a desapropriar. Autorizar não comprova conclusão da desapropriação; a data do decreto não é data de obtenção efetiva. Geometria do polígono, criação do PA (06/11/2003), fase 4 e 20 famílias: apenas espelho geo.ambientare.com.br (camada 8, cd_sipra BA0369000).
- Rotas INCRA diretas esgotadas: geoservicos.incra.gov.br e certificacao.incra.gov.br sem DNS; GeoNode só Sigef; dados.gov.br com metadados 2023 "atualização não verificável" apontando para host morto; archive.org offline na madrugada.
- Imagens (mosaico): cenas 2014-08-27/2014-09-12 × 2023-05-19 (datas de captura por footprint; releases Wayback 2017-11-16 e 2024-12-12). Ilustrativo (sensor/estação diferem).
- PRODES: a região é coberta pelo produto PRODES Caatinga (651 polígonos anuais 2004-2025 na caixa ±0,06°; 48 acumulados). Polígonos anuais tocam o assentamento em todos os anos 2004-2024 (nenhum em 2025); soma fracionada dentro ≈ 4,49 km² (~30% dos 1.514 ha). O produto Cerrado tem zero feições na caixa. Cobertura/ausência de produto não prova divergência de limites de bioma: questão metodológica aberta (minha classificação por malha IBGE deu Cerrado no ponto).

## 6. Biomas (malha IBGE C04_bioma_2010 + point-in-polygon, 5 controles OK)
- Amazônia: #1, #3, #12. Cerrado: #2, #5, #6, #7, #9, #17. Caatinga: #4, #8, #11, #13, #16, #18, #20. Mata Atlântica: #10, #14, #15, #19.

## 7. Quirks de qualidade de dado (observação, não acusação)
- SICAR: os 222 micros <0,01 ha da consulta a "São Félix do Coribe" trazem cod_imovel com código de Coribe (2929057) e campo municipio="São Félix do Coribe".
- SICAR: par de CARs grandes de Rondon do Pará com 91,7-96,1% de sobreposição mútua (criados 2023 e 2026).
- BD: ±1-±2 imóveis entre execuções minutos apart do mesmo funil.
- Thread original: razão×100 aplicada duplamente na legenda de %.

## 8. Preservação durável
- GitHub Lux-Lab bd_reconciliation/: dossiê T7, SQL cânone, README (63 arquivos).
- Drive "bd_reconciliation_pacote_v7_exclusivos": 8 arquivos exclusivos do tar + pacote v7 completo (2.727.548 B). https://drive.google.com/drive/folders/1yMDRXzf8BGsVF-VOrl2o99bcDvHBfjWb
- Evidências deste aprofundamento: status20_live.json, tad_main_3.txt, tad_hist_3.txt, tad_decisao.csv, assent_geom.json, prodes_caat_m7.json, mosaicos PNG.

## 9. Limites do método (uma vez só)
Executor SQL = chatbot BD gratuito; sem BigQuery próprio. Sem contato externo. Sem dossiê pessoal (nomes/CPFs minimizados). Sem inferência de fraude nem conclusão jurídica: duplo cadastro, saneamento e tipificação são decisões fora deste escopo. Proximidade ≠ causa; contenção ≠ titularidade; ausência em coleção ≠ ausência de evento; espelho ≠ fonte oficial; snapshot BD ≠ cadastro corrente SICAR.
