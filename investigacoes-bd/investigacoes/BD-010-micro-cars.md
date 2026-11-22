# BD-010: Micro-CARs, Rondon do Pará e Bom Sucesso
- **Tema:** imóveis CAR minúsculos com área financiada maior que a área declarada, e a história territorial de dois recortes: Rondon do Pará (PA) e Bom Sucesso, em São Félix do Coribe (BA).
- **Quando:** 20/11/2026, no chatbot da BD e em fontes oficiais complementares.
- **Pergunta:** o que as datas, as áreas ambientais declaradas e as sobreposições dizem sobre 20 imóveis fora da curva?
- **Como foi feito:** consultas ao snapshot SICAR na BD (extrações de 01 a 03/08/2026): datas de inscrição × última modificação dos CARs, tabelas temáticas de APP e reserva legal com SQL sobre geometrias (ST_UNION_AGG, ST_INTERSECTION). Complementos fora da BD: SICAR, IBAMA, INCRA, Diário Oficial e MapBiomas.
- **Resultados:**
  - Em Rondon do Pará, as Reservas Legais propostas de dois CARs se sobrepõem em 583,74 ha (93,7% da RL de um, 89,3% da do outro). O CAR maior coincide com uma parcela do INCRA registrada em camada pública, com cerca de 31 ha sobre gleba pública registrada.
  - No micro de São Félix, uma APP de 2,1251 ha está declarada inteiramente fora do imóvel.
  - 13 micros têm reserva legal proposta 100% contida no imóvel, com geometrias de 0,6 a 1,8 m²; 6 micros não têm polígono ambiental no snapshot; 1 CAR foi cancelado depois do snapshot.
  - Nenhum dos 20 pontos está dentro de polígono embargado do IBAMA nem sobre feição recente de supressão mapeada.
- **Rastreio:** conversa no chatbot da BD em 20/11/2026; fontes oficiais listadas no documento.

## Sequência da investigação

Vinte micro-CARs → datas de inscrição e retificação → APP e reserva legal → SIGEF, INCRA e IBAMA → PRODES/DETER e séries de cobertura → timelines dos dois casos.

## A. Material bruto recuperado

- [BD-007: JSON de 34 mensagens](../conversas/BD-007_a6ea1581-9c4a-45e1-b6a7-1f00375baf57.json) · [leitura cronológica](../conversas/extraidos/BD-007/mensagens.md) · [SQL, chamadas e respostas](../conversas/extraidos/BD-007/)
- [BD-010: JSON de 18 mensagens](../conversas/BD-010_430dfb1d-63f9-4901-b181-963177941355.json) · [leitura cronológica](../conversas/extraidos/BD-010/mensagens.md) · [SQL, chamadas e respostas](../conversas/extraidos/BD-010/)

BD-007 contém a origem dos 20 micro-CARs e a frente de Sátiro Dias. No JSON publicado, 36 ocorrências de números de CPF foram substituídas por `[CPF_OCULTADO]`; o original integral permanece no arquivo privado.

## B. Consultas e código

150 consultas SQL extraídas das conversas. Chamadas e respostas originais, com identificadores e argumentos, estão nas pastas ligadas acima. Os SQLs estão separados em `sql/` dentro de cada pasta.

[Verificador espacial](../originais/pacote_evidencias_20261120/verificar.py) · [Método SIGEF](../originais/sigef_cruzamentos_20261120/nota_sigef_cruzamentos_20261120.md).

## C. Resultados e arquivos

56 tabelas CSV das linhas registradas nas respostas do chatbot; respostas completas e índices com a consulta e a mensagem de origem.

- [Timeline Rondon do Pará](../originais/drive-2026-11-20/timeline_rondon_do_para.md)
- [Timeline Bom Sucesso](../originais/drive-2026-11-20/timeline_sfc_bom_sucesso.md)
- [Síntese v2](../originais/drive-2026-11-20/sintese_aprofundamento_2026-11-20_v2.md)
- [38 arquivos de evidências](../originais/pacote_evidencias_20261120/)
- [5 arquivos SIGEF](../originais/sigef_cruzamentos_20261120/)
- [10 arquivos de vizinhanças BA](../originais/ba_vizinhancas_20261120/)
- [TIFFs e séries de cobertura](../originais/versoes/lulc_10m_evidencias_v2/)
- [DOU original](../originais/drive-2026-11-20/dou_20031118_s1_p101_oficial.pdf)
- [Imagem das ondas de retificação](../originais/drive-2026-11-20/ondas_micros_rondon_v2_datas_corrigidas.png)
- [Fontes e imagens do dossiê](../originais/produtos/historia-dois-casos/)

## D. Reprodutibilidade

Respostas originais e verificador espacial disponíveis. Dependências: Shapely e pyproj. Os comandos estão no cabeçalho do verificador e nos métodos originais.

## E. Destinos possíveis

Duas pautas territoriais QPI, dossiê documental e pacote geoespacial.

## F. Pendências e próximo passo

Os exports nativos apenas referenciados em `downloads-referenciados.json` ainda não foram baixados neste lote. As respostas e linhas registradas já estão nos arquivos extraídos.

Continuar pelas pendências das timelines: demonstrativos CAR, processo do INCRA, geometria do assentamento e cruzamento dos imóveis vizinhos.


## G. Pacote de trabalho

[Baixar o material recuperado (ZIP)](../pacotes/BD-010-material-recuperado-2026-11-22.zip). Versão 22/11/2026.

[Todos os materiais desta frente](#c-resultados-e-arquivos) · [Painel das 12 investigações](../PAINEL.md) · [Manifesto de arquivos e SHA-256](../manifesto-originais.json).
