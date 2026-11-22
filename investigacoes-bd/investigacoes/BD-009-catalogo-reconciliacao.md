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

- [validacao: JSON de 10 mensagens](../conversas/validacao_5d4bd8d9-338c-4330-9ea0-74230674b27a.json) · [leitura cronológica](../conversas/extraidos/validacao/mensagens.md) · [SQL, chamadas e respostas](../conversas/extraidos/validacao/)
- [validacao-suites: JSON de 8 mensagens](../conversas/validacao-suites_23340b3d-36ca-478c-8a85-7b3db0ed4e3d.json) · [leitura cronológica](../conversas/extraidos/validacao-suites/mensagens.md) · [SQL, chamadas e respostas](../conversas/extraidos/validacao-suites/)

## B. Consultas e código

22 consultas SQL extraídas das conversas. Chamadas e respostas originais, com identificadores e argumentos, estão nas pastas ligadas acima. Os SQLs estão separados em `sql/` dentro de cada pasta.

[Código da reconciliação](../originais/bd_reconciliation/source/) · [21 SQLs parametrizados](../originais/bd_reconciliation/outputs/sql/) · [Reprodução local](../REPRODUZIR.md).

## C. Resultados e arquivos

21 tabelas CSV das linhas registradas nas respostas do chatbot; respostas completas e índices com a consulta e a mensagem de origem.

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

Os exports nativos apenas referenciados em `downloads-referenciados.json` ainda não foram baixados neste lote. As respostas e linhas registradas já estão nos arquivos extraídos.

Adicionar um quinto relacionamento com config, export registrado e relatório no mesmo formato.

## G. Pacote de trabalho

[Baixar o material recuperado (ZIP)](../pacotes/BD-009-material-recuperado-2026-11-22.zip). Versão 22/11/2026.

[Todos os materiais desta frente](#c-resultados-e-arquivos) · [Painel das 12 investigações](../PAINEL.md) · [Manifesto de arquivos e SHA-256](../manifesto-originais.json).
