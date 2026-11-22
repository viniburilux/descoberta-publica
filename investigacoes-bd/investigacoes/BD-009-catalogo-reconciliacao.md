# BD-009: Catálogo de reconciliação
- **Tema:** cobertura medida de relacionamentos entre tabelas da BD, com chaves e normalizações documentadas.
- **Quando:** noite de 18/11 e sessões de 19 a 20/11/2026.
- **Pergunta:** quais cruzamentos entre bases públicas realmente fecham, com qual cobertura e qual tratamento de chave?
- **Como foi feito:** testes de cobertura por par de tabelas, com SQL executado e query_ref, incluindo um ciclo A/B (um par sem e um par com reparo) para medir a influência de experiência registrada.
- **Resultados:**
  - Embargo IBAMA × auto de infração: 96.293 de 96.353, ou 99,94% (query_ref qr_6cdff61d).
  - PRODES × MapBiomas: 6.437 de 6.536, ou 98,49% (qr_523383966).
  - RAIS × CNAE: 1.035.280 de 1.036.692, ou 99,86% (qr_7b381f10).
  - SICOR × CAR: ver BD-006 (0% a 99,999% após normalização do hífen).
- **Rastreio:** query_refs qr_6cdff61d, qr_523383966 e qr_7b381f10.

## Sequência da investigação

Quatro pares de tabelas → nulos e duplicidade → transformações → cobertura → resíduos → catálogo consultável.

## A. Material bruto recuperado

Código, consultas, contagens, documentos e resultados originais no pacote abaixo. Os dois exports de conversa do pacote de reconciliação somam 14 mensagens; a recuperação das sessões completas está em andamento.

## B. Consultas e código

[Código Python](../originais/bd_reconciliation/source/) · [SQLs originais](../originais/bd_reconciliation/outputs/sql/) · [Guia de reprodução](../REPRODUZIR.md).

## C. Resultados e arquivos

- [Catálogo original](../originais/bd_reconciliation/catalog/)
- [4 configurações](../originais/bd_reconciliation/configs/)
- [21 SQLs originais](../originais/bd_reconciliation/outputs/sql/)
- [4 scripts Python](../originais/bd_reconciliation/source/)
- [4 exports registrados](../originais/bd_reconciliation/inputs/recorded/)

## D. Reprodutibilidade

Geração local dos 21 SQLs conferida em 22/11/2026: 21/21 idênticos aos originais. Regressão das métricas: 8/8 checks aprovados. [Comandos e resultados](../REPRODUZIR.md).

## E. Destinos possíveis

Catálogo reutilizável, dataset de relacionamentos e biblioteca de diagnóstico SQL.

## F. Pendências e próximo passo

Adicionar um quinto relacionamento com config, export registrado e relatório no mesmo formato.

## G. Pacote de trabalho

[Todos os materiais desta frente](#c-resultados-e-arquivos) · [Painel das 12 investigações](../PAINEL.md) · [Manifesto de arquivos e SHA-256](../manifesto-originais.json).
