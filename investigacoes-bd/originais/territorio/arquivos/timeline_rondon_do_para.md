# Linha do tempo — Rondon do Pará/PA (CARs A/B, micros das ondas, TADs IBAMA)
Versão 20/11/2026 ~04h -03 (rev. 2, pós-revisão independente). Documento de trabalho privado. Fatos com fonte; hipóteses marcadas; sem conclusão de irregularidade. NÃO é a história completa (§Pendências).
Identificadores: CAR A = PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56 · CAR B = PA-1506187-48EDE9CDCF3947959921871671228876 · micro #1 = PA-1506187-94551B72659E427F961D2F62CEBA7392 · micro #12 = PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98. Geometrias preservadas (rondon_nucleo_geometrias.geojson).

## Cronologia cadastral (fonte: demonstrativos oficiais car.gov.br/#/consultar — leitura da página oficial de consulta; status corrente via SICAR WFS)
- 26/11/2015 — Inscrição do micro #12 (8,98 m²).
- 01/12/2015 — Inscrição do micro 2FA6A081 (onda 1).
- 28/04/2016 — Inscrição do CAR A (área declarada 1.350,22 ha; o polígono atual no WFS mede 1.347,69 ha geodésicos — medida da geometria, não o atributo declarado).
- 30/12/2016 — Inscrição do micro A4DD4E93 (onda 1).
- 07/05/2017 — Inscrição do micro 34A1DD76 (onda 2).
- 23/10/2020 — Inscrição do micro 8A59FA27 (onda 1).
- 27/10/2020 — Inscrição do micro DAE50532 (onda 2).
- 06/06/2023 — Última retificação do CAR A.
- 04/11/2023 — Último evento cadastral (campo dat_criacao do WFS) do micro #1 e de um segundo micro de 7 m² a 52,3 m dele; os dois constam HOJE como "Cancelado por decisão administrativa". Fato: par com o mesmo último evento e o mesmo status corrente; a data do ato de cancelamento em si não está documentada.
- 02/04/2025 — Retificação do micro 8A59FA27.
- 03/04/2025 — Retificação dos micros 2FA6A081 e A4DD4E93.
- 15/04/2025 — Retificação dos micros 34A1DD76 e DAE50532.
- 16/04/2025 — Retificação do micro #12.
- 26/03/2026 — Inscrição do CAR B (demonstrativo com "Retificação: -"; única data do documento). Área declarada 1.288,09 ha; o polígono atual no WFS mede 1.285,67 ha geodésicos.
- 20/11/2026 — Status ao vivo dos 20 alvos (WFS): 17 AT / 2 PE (#3, #12) / 1 CA (#1).
- Regra de leitura: nos 9 demonstrativos oficiais verificados, a data do WFS correspondeu ao último evento (inscrição OU retificação); fora desses 9 casos, a correspondência não está demonstrada.

## Geometria (reproduzida por revisor independente, WGS84 geodésico)
- CAR A ∩ CAR B: sobreposição de 91,6% de A em B e 96,1% de B em A — dois CARs grandes quase coincidentes.
- Micro #12 (8,98 m²): 100% dentro de A e de B.
- Ondas: trios de micros a 5,0/5,1/10,1 m entre si (retificados em 02-03/04/2025) e 3,9/4,0/7,9 m (retificados em 15-16/04/2025); os dois grupos a ~893 m um do outro.
- "Nenhuma sobreposição encontrada" consta dos demonstrativos (verbatim); o escopo dessa checagem pelo sistema não está verificado.

## TADs IBAMA (autos de embargo; raws preservados, SEM propagar nomes/CPF/CNPJ)
- 31/03/2006 — data do auto do TAD 127471 (725 ha declarados). RESSALVA: a geometria oficial desse TAD é um ponto (polígono degenerado); qualquer leitura espacial é apenas sobre o ponto, não sobre os 725 ha.
- 30/08/2010 — data do auto do TAD 824790 (8,29 ha): 100% dentro de A e de B.
- 23/12/2012 — data do auto do TAD 836171: campo oficial 376,2529 ha; o texto do auto diz "378,320 HA" (divergência registrada, sem explicação). O auto descreve vegetação nativa em estado secundário de regeneração. Interseção geodésica: 370,6 ha dentro de A / 344,8 ha dentro de B.
- Distâncias: micro #1 → TADs: 25,4-28,1 km; micro #12 → TADs: 2,6-3,8 km.
- Situação: status "Lavrado" nos 3; SIT_CANCELADO = N; campos de desembargo vazios; zero decisões nos autos (tad_decisao.csv, 488 linhas); histórico com 10/14 eventos em raw (4 eventos de 2016 só transcritos). Datas dos autos lidas de campo da camada oficial, sem dicionário de dados IBAMA (não lido).

## Cobertura de supressão (terrabrasilis/INPE; método documentado T1-T11, controles positivo+negativo na mesma sessão)
- PRODES Amazônia, bbox dos CARs A/B: 7 feições (2008, 2009, 2009, 2010, 2010, 2013, 2015). Dessas, 6 intersectam os CARs A e B (as de 2008, 2009×2, 2010×2 e 2015); a feição de 2013 está dentro do bbox mas NÃO intersecta nenhum dos dois CARs. Interseções geodésicas: A = 114,60 ha; B = 119,54 ha. Nenhuma feição 2016-2025 (zero controlado). Ressalva de produto: PRODES mede corte raso de vegetação nativa primária acima de ~6,25 ha; ausência de feição não prova ausência de supressão.
- DETER (alertas 2016+): nenhuma feição detectada no bbox exato consultado dos CARs A/B (controles na mesma sessão).
- LULC 10 m (Esri/Impact Observatory/Microsoft; classificação automática de uso e cobertura): no CAR A, a classe "Árvores" cai de ~910 ha (2017) para ~653 ha (2024), de forma monotônica; a soma das classes é constante. Limite geométrico medido: pixels de borda podem contribuir até ~1-2 ha por classe por ano (limite de medição, não margem estatística); a queda de ~257 ha está duas ordens de magnitude acima desse limite. Isto NÃO é desmate comprovado — é tendência de classificação automática. TENSÃO ABERTA com o zero do PRODES 2016-2025: leituras concorrentes legítimas existem (escopo e unidade mínima do PRODES) e não foram verificadas; sem escolha.
- Comparativo visual por tiles: 2011 × 2017. Não existe série 2017/2020/2024 no Wayback para Rondon (as capturas dos releases 2020 e 2024 apontam para a mesma captura de 2017); a correção já entregue está apoiada.

## Pendências
1. Demonstrativos oficiais dos 18 alvos restantes (rota com captcha, parada) — só eles distinguem inscrição de retificação fora dos 9 já lidos.
2. O que mudou em cada retificação (geometria? dados declarados?) — sem presunção de redução.
3. Série LULC geodésica completa só existe para o CAR A; CAR B, TAD 836171 e assentamento SFC seguem com snapshots 2017/2020/2024 em método anterior.
4. Tensão LULC×PRODES sem reconciliação; funil BD (797.183 imóveis, R$ 112,1 bi, TOP-20) é saída do chatbot BD, não auditada.
5. Dicionários de dados SICAR e IBAMA não lidos.
