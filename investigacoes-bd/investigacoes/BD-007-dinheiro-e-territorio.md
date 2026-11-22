# BD-007: O Dinheiro e o Território
- **Tema:** onde se concentra o crédito rural associado a imóveis CAR e como esse território se relaciona com produção agrícola e cobertura da terra.
- **Quando:** 19/11/2026, no chatbot da BD, com reconciliação em BD-008.
- **Pergunta:** onde o crédito rural associado a imóveis CAR se concentra e como se relaciona com produção e cobertura?
- **Como foi feito:** SQL executado pelo chatbot com trilha de erros visível. Rateio igual do valor entre os imóveis de cada operação; município é o município do imóvel rural associado (CAR).
- **Resultados (cânone reconciliado):** recorte recurso público 2023, todas as finalidades: **R$ 112,1 bilhões territorializados em 5.380 municípios**, 92,56% do subtotal classificado (R$ 121,13 bi). O total de operações SICOR 2023 é R$ 406,4 bi. A fonte 0911 (FNDCT) não teve operações em 2023.
- **Resultados (funil original da primeira sessão):** R$ 126,66 bi mapeados; correlação crédito × agricultura de 0,691 contra 0,345 com pastagem; 14,9% dos imóveis com área financiada maior que a área do CAR (R$ 26,7 bi). A divergência com o cânone está explicada: recorte e filtro de recurso público.
- **Rastreio:** conversa no chatbot da BD em 19/11/2026; query_refs qr_8a918dd1 e qr_0454ef447a7a4f19a728c259c9de78ae.

## Sequência da investigação

Exploração SICOR × CAR × PAM × MapBiomas → funil original → reconciliação → CSV de 5.380 municípios → mapa e aplicação.

## A. Material bruto recuperado

Código, consultas, contagens, documentos e resultados originais no pacote abaixo. Os dois exports de conversa do pacote de reconciliação somam 14 mensagens; a recuperação das sessões completas está em andamento.

Último vestígio da sessão: `a6ea1581-9c4a-45e1-b6a7-1f00375baf57`, chatbot da BD.

## B. Consultas e código

[Código Python](../originais/bd_reconciliation/source/) · [SQLs originais](../originais/bd_reconciliation/outputs/sql/) · [Guia de reprodução](../REPRODUZIR.md).

## C. Resultados e arquivos

- [CSV de 5.380 municípios](../originais/bd_reconciliation/outputs/mapa_credito_rural_municipal_2023_nomeado.csv)
- [Mapa PNG](../originais/bd_reconciliation/outputs/mapa_entrega_canone_2023.png)
- [App HTML e gerador](../originais/bd_reconciliation/outputs/app/)
- [Fonte da aplicação publicada](../originais/produtos/dinheiro-territorio/)
- [SQL do dossiê](../consultas/credito_rural_por_municipio.sql)

## D. Reprodutibilidade

CSV, app HTML, gerador e mapa disponíveis. [Guia para abrir e reconstruir](../REPRODUZIR.md).

## E. Destinos possíveis

Pauta QPI, dataset municipal e aplicação de consulta ao crédito rural.

## F. Pendências e próximo passo

Abrir o CSV municipal, escolher os municípios da pauta e comparar as séries de crédito, produção agrícola e cobertura da terra.

Pendente: integrar a conversa completa com suas perguntas, respostas e chamadas originais.

## G. Pacote de trabalho

[Baixar o material recuperado (ZIP)](../pacotes/BD-007-material-recuperado-2026-11-22.zip). Versão 22/11/2026.

[Todos os materiais desta frente](#c-resultados-e-arquivos) · [Painel das 12 investigações](../PAINEL.md) · [Manifesto de arquivos e SHA-256](../manifesto-originais.json).
