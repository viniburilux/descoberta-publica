# BD-006: Inventário territorial e o join SICOR × CAR

- **Tema:** as bases territoriais da BD (imóveis rurais, cobertura, desmatamento, fogo, fiscalização, unidades de conservação) e a junção entre crédito rural (SICOR) e imóveis (CAR).
- **Quando:** 19/11/2026, no chatbot da BD.
- **Pergunta:** o que o catálogo oferece para investigação territorial e como conectar crédito rural a imóveis?
- **Como foi feito:** inventário das tabelas territoriais e das chaves, e teste de join SICOR × CAR com medição de cobertura.
- **Resultados:** o join literal pelo código do CAR deu 0% de cobertura. Depois de normalizar o hífen no código, 99,999% (2019/2023) e 99,708% (2026).
- **O que aprendemos:** a chave SICOR × CAR exige normalização de formato. É um achado de qualidade de dados com valor direto para qualquer pessoa que use a BD: sem o teste, o cruzamento parece simplesmente impossível.
- **Hipóteses abertas:** os cerca de 0,3% que ficaram fora do join em 2026 não foram caracterizados.
- **Maturidade:** Reprodução (3 de 6).
- **Rastreio:** query_ref qr_374c2380; conversa no chatbot da BD em 19/11/2026.

## Como reproduzir

1. Abra o chatbot da BD ou um BigQuery com as tabelas públicas br_bcb_sicor.recurso_publico_propriedade e br_sfb_sicar.area_imovel.
2. Rode o join literal e meça a cobertura: 0%.
3. Rode a versão normalizada (maiúsculas, sem hífen) e meça de novo: 99,999% (2019/2023) e 99,708% (2026).

Consultas prontas: [sicor_car_03_transformacoes.sql](../consultas/sicor_car_03_transformacoes.sql) e [sicor_car_04_cobertura.sql](../consultas/sicor_car_04_cobertura.sql).

## Saída pronta: contribuição de documentação para a BD

Texto pronto: a chave SICOR × CAR existe, mas exige normalização de formato; sem isso, o join retorna vazio. Cobertura medida por ano, com consulta pública reproduzível.
