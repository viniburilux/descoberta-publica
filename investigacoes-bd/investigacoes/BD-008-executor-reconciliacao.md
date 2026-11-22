# BD-008: Executor de reconciliação
- **Tema:** execução oficial das consultas de reconciliação no chatbot da BD para fechar o número defensável de BD-007.
- **Quando:** 19 a 20/11/2026.
- **Pergunta:** qual é o número fechado e defensável do crédito rural com recurso público em 2023, por município?
- **Como foi feito:** consultas no executor oficial da BD; decisões de método explícitas (valor em valor_parcela_credito; snapshot mais recente por imóvel; rateio igual entre imóveis); resolução da fonte 0911 como FNDCT (zero operações em 2023); download do CSV pelo endpoint de exports do próprio chatbot.
- **Resultados:** cânone de R$ 112.125.325.594,22 em 5.380 municípios (92,56% do subtotal classificado). Caso 2022 (finalidade investimento): R$ 48,29 bi conectados de R$ 52,42 bi (92,12%), 5.241 municípios, 489.138 imóveis.
- **Rastreio:** query_refs qr_0ef8fb01, qr_ceaa9c22 e qr_8a918dd1.

## Sequência da investigação

Inspeção de valor e chaves → snapshot por imóvel → classificação do recurso → rateio → cânone 2023 de R$ 112.125.325.594,22.

## A. Material bruto recuperado

Código, consultas, contagens, documentos e resultados originais no pacote abaixo. Os dois exports de conversa do pacote de reconciliação somam 14 mensagens; a recuperação das sessões completas está em andamento.

Último vestígio da sessão: `35bbb638-d45b-425b-8d06-3b463679a9e4`, chatbot da BD.

## B. Consultas e código

[Código Python](../originais/bd_reconciliation/source/) · [SQLs originais](../originais/bd_reconciliation/outputs/sql/) · [Guia de reprodução](../REPRODUZIR.md).

## C. Resultados e arquivos

- [Dossiê T7 original](../originais/bd_reconciliation/docs/dossie_t7.md)
- [Validação no chatbot](../originais/bd_reconciliation/outputs/runs/2026-11-19/validacao_real_chatbot.md)
- [Export de 4 mensagens](../originais/bd_reconciliation/inputs/bd_msgs_missao1_ciclo1.json)
- [Export de 10 mensagens](../originais/bd_reconciliation/inputs/bd_msgs_validacao.json)
- [CSVs e resultados](../originais/bd_reconciliation/outputs/)

## D. Reprodutibilidade

Geração local dos 21 SQLs conferida em 22/11/2026: 21/21 idênticos aos originais. Regressão das métricas: 8/8 checks aprovados. [Comandos e resultados](../REPRODUZIR.md).

## E. Destinos possíveis

Dossiê técnico reproduzível do rateio municipal do crédito rural.

## F. Pendências e próximo passo

Reexecutar o SQL do dossiê no executor BD e guardar os novos exports em uma pasta de execução datada.

Pendente: integrar a conversa completa com suas perguntas, respostas e chamadas originais.

## G. Pacote de trabalho

[Todos os materiais desta frente](#c-resultados-e-arquivos) · [Painel das 12 investigações](../PAINEL.md) · [Manifesto de arquivos e SHA-256](../manifesto-originais.json).
