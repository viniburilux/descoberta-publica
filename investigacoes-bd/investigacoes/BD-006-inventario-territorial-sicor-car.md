# BD-006: Inventário territorial e SICOR × CAR
- **Tema:** as bases territoriais da BD (imóveis rurais, cobertura, desmatamento, fogo, fiscalização, unidades de conservação) e a junção entre crédito rural (SICOR) e imóveis (CAR).
- **Quando:** 19/11/2026, no chatbot da BD.
- **Pergunta:** o que o catálogo oferece para investigação territorial e como conectar crédito rural a imóveis?
- **Como foi feito:** inventário das tabelas territoriais e das chaves, e teste de join SICOR × CAR com medição de cobertura.
- **Resultados:** o join literal pelo código do CAR deu 0% de cobertura. Depois de normalizar o hífen no código, 99,999% (2019/2023) e 99,708% (2026).
- **Rastreio:** query_ref qr_374c2380; conversa no chatbot da BD em 19/11/2026.

## Sequência da investigação

Inventário territorial → join literal com cobertura zero → normalização → cobertura medida por período.

## A. Material bruto recuperado

- [BD-006: JSON de 12 mensagens](../conversas/BD-006_c3e3f115-4ee9-48ca-a0f6-46daa03b50a5.json) · [leitura cronológica](../conversas/extraidos/BD-006/mensagens.md) · [SQL, chamadas e respostas](../conversas/extraidos/BD-006/)

## B. Consultas e código

33 consultas SQL extraídas das conversas. Chamadas e respostas originais, com identificadores e argumentos, estão nas pastas ligadas acima. Os SQLs estão separados em `sql/` dentro de cada pasta.

[Código da reconciliação](../originais/bd_reconciliation/source/) · [21 SQLs parametrizados](../originais/bd_reconciliation/outputs/sql/) · [Reprodução local](../REPRODUZIR.md).

## C. Resultados e arquivos

9 tabelas CSV das linhas registradas nas respostas do chatbot; respostas completas e índices com a consulta e a mensagem de origem.

- [Config SICOR × CAR](../originais/bd_reconciliation/configs/relationships/sicor_car.json)
- [6 SQLs originais](../originais/bd_reconciliation/outputs/sql/sicor_car/)
- [Contagens registradas](../originais/bd_reconciliation/inputs/recorded/sicor_car.json)
- [Diagnóstico original](../originais/bd_reconciliation/outputs/runs/2026-11-19/sicor_car_diagnostico.md)

## D. Reprodutibilidade

Geração local dos 21 SQLs conferida em 22/11/2026: 21/21 idênticos aos originais. Regressão das métricas: 8/8 checks aprovados. [Comandos e resultados](../REPRODUZIR.md).

## E. Destinos possíveis

Tutorial técnico e caso de uso BD sobre normalização de chaves territoriais.

## F. Pendências e próximo passo

Os exports nativos apenas referenciados em `downloads-referenciados.json` ainda não foram baixados neste lote. As respostas e linhas registradas já estão nos arquivos extraídos.

Reexecutar a suíte SICOR × CAR no recorte desejado e comparar o relatório com as contagens registradas.


## G. Pacote de trabalho

[Baixar o material recuperado (ZIP)](../pacotes/BD-006-material-recuperado-2026-11-22.zip). Versão 22/11/2026.

[Todos os materiais desta frente](#c-resultados-e-arquivos) · [Painel das 12 investigações](../PAINEL.md) · [Manifesto de arquivos e SHA-256](../manifesto-originais.json).
