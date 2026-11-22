# BD-010: Micro-CARs: datas, APP e reserva legal declaradas, e sobreposições

- **Tema:** imóveis CAR minúsculos com área financiada maior que a área declarada, e a história territorial de dois recortes: Rondon do Pará (PA) e Bom Sucesso, em São Félix do Coribe (BA).
- **Quando:** 20/11/2026, no chatbot da BD e em fontes oficiais complementares.
- **Pergunta:** o que as datas, as áreas ambientais declaradas e as sobreposições dizem sobre 20 imóveis fora da curva?
- **Como foi feito:** consultas ao snapshot SICAR na BD (extrações de 01 a 03/08/2026): datas de inscrição × última modificação dos CARs, tabelas temáticas de APP e reserva legal com SQL sobre geometrias (ST_UNION_AGG, ST_INTERSECTION). Complementos fora da BD: SICAR, IBAMA, INCRA, Diário Oficial e MapBiomas.
- **Resultados (inconsistências cadastrais documentadas, sempre como declarações, não como condição observada):**
  - Em Rondon do Pará, as Reservas Legais propostas de dois CARs se sobrepõem em 583,74 ha (93,7% da RL de um, 89,3% da do outro). O CAR maior coincide com uma parcela do INCRA registrada em camada pública, com cerca de 31 ha sobre gleba pública registrada.
  - No micro de São Félix, uma APP de 2,1251 ha está declarada inteiramente fora do imóvel.
  - 13 micros têm reserva legal proposta 100% contida no imóvel, com geometrias de 0,6 a 1,8 m²; 6 micros não têm polígono ambiental no snapshot; 1 CAR foi cancelado depois do snapshot.
  - Nenhum dos 20 pontos está dentro de polígono embargado do IBAMA nem sobre feição recente de supressão mapeada.
- **O que aprendemos:** a "data" de um CAR exige cuidado (as datas vistas eram de retificações, não de inscrições originais; rótulos de imagem eram versão de mapa, não data de captura). E o cruzamento de camadas oficiais reconstrói a história territorial de um imóvel ato a ato, sem custo.
- **Hipóteses abertas:** 43 imóveis apontados por um agregador como sobrepostos ao perímetro do assentamento aguardam o processo oficial; demonstrativos do car.gov.br; geometria primária do INCRA. Frente pausada em 20/11, com guia de continuação.
- **Produto:** [A história territorial dos dois casos](https://files.instinct.com/5upblg04u1v8-a-historia-territorial-dos-dois-casos), documento completo com linhas do tempo, cruzamentos geométricos e fontes. Nomes de pessoas e CPF/CNPJ ficam de fora por decisão editorial; os códigos públicos de CAR e parcela estão lá.
- **Maturidade:** Investigação (2 de 6).
- **Rastreio:** conversa no chatbot da BD em 20/11/2026; fontes oficiais listadas no documento.

## Como reproduzir e continuar

As fontes e o passo a passo estão no documento linkado acima: demonstrativos oficiais no car.gov.br e camadas abertas de SICAR, IBAMA, INCRA e INPE. Pendências listadas lá: demonstrativos dos demais imóveis, processo INCRA integral e geometria oficial do assentamento.
