# BD-009: Catálogo de reconciliação (4 relações medidas)

- **Tema:** cobertura medida de relacionamentos entre tabelas da BD, com chaves e normalizações documentadas.
- **Quando:** noite de 18/11 e sessões de 19 a 20/11/2026.
- **Pergunta:** quais cruzamentos entre bases públicas realmente fecham, com qual cobertura e qual tratamento de chave?
- **Como foi feito:** testes de cobertura por par de tabelas, com SQL executado e query_ref, incluindo um ciclo A/B (um par sem e um par com reparo) para medir a influência de experiência registrada.
- **Resultados:**
  - Embargo IBAMA × auto de infração: 96.293 de 96.353, ou 99,94% (query_ref qr_6cdff61d).
  - PRODES × MapBiomas: 6.437 de 6.536, ou 98,49% (qr_523383966).
  - RAIS × CNAE: 1.035.280 de 1.036.692, ou 99,86% (qr_7b381f10).
  - SICOR × CAR: ver BD-006 (0% a 99,999% após normalização do hífen).
- **O que aprendemos:** nenhum cruzamento é óbvio antes do teste. Quatro relações agora têm cobertura quantificada e tratamento de chave documentado, conhecimento técnico reutilizável por qualquer pessoa que cruze bases públicas.
- **Hipóteses abertas:** os resíduos (o que ficou fora de cada join) não foram caracterizados.
- **Maturidade:** Reprodução (3 de 6).
- **Rastreio:** query_refs qr_6cdff61d, qr_523383966 e qr_7b381f10.

## Como reproduzir

As consultas de cobertura estão prontas em [consultas/](../consultas/): uma por relação, cada uma medindo registros correspondentes, distintos e resíduos. Rodam no chatbot da BD ou no BigQuery.

## Saída pronta: nota metodológica

Os quatro pares com cobertura medida e chave documentada formam a espinha de uma nota de interoperabilidade entre bases públicas: método (medir antes de cruzar), tabela de coberturas e resíduos abertos.
