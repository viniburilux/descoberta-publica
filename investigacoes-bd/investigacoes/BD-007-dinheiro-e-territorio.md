# BD-007: O Dinheiro e o Território (SICOR × CAR × PAM × MapBiomas)

- **Tema:** onde se concentra o crédito rural associado a imóveis CAR e como esse território se relaciona com produção agrícola e cobertura da terra.
- **Quando:** 19/11/2026, no chatbot da BD, com reconciliação em BD-008.
- **Pergunta:** onde o crédito rural associado a imóveis CAR se concentra e como se relaciona com produção e cobertura?
- **Como foi feito:** abordagem descritiva, não causal. SQL executado pelo chatbot com trilha de erros visível. Rateio igual do valor entre os imóveis de cada operação; município é o município do imóvel rural associado (CAR).
- **Resultados (cânone reconciliado):** recorte recurso público 2023, todas as finalidades: **R$ 112,1 bilhões territorializados em 5.380 municípios**, 92,56% do subtotal classificado (R$ 121,13 bi). O total de operações SICOR 2023 é R$ 406,4 bi. A fonte 0911 (FNDCT) não teve operações em 2023.
- **Resultados (funil original da primeira sessão):** R$ 126,66 bi mapeados; correlação crédito × agricultura de 0,691 contra 0,345 com pastagem; 14,9% dos imóveis com área financiada maior que a área do CAR (R$ 26,7 bi). A divergência com o cânone está explicada: recorte e filtro de recurso público.
- **O que aprendemos:** existe um mapa municipal do crédito rural público, com fronteiras claras de concentração (oeste da Bahia, norte do Mato Grosso, Matopiba). A anomalia "área financiada maior que a área do CAR" é sinal de qualidade de dado (há CARs de 0,0001 ha), não evidência de irregularidade.
- **Hipóteses abertas:** valor rateado não é valor pago nem local do benefício; o indicador de recurso público não teve verificação independente.
- **Produtos:** [app interativa O Dinheiro e o Território](https://files.instinct.com/0ge7iva44a3a-o-dinheiro-e-o-territorio) e [dossiê com método e SQL](https://files.instinct.com/5gs9dgjmfr9g-credito-rural-por-municipio-sicor-2023). CSV dos 5.380 municípios: query_ref qr_8a918dd1. Diretório de municípios: qr_0454ef447a7a4f19a728c259c9de78ae.
- **Maturidade:** Produto (6 de 6).
- **Rastreio:** conversa no chatbot da BD em 19/11/2026; query_refs qr_8a918dd1 e qr_0454ef447a7a4f19a728c259c9de78ae.

## Como reproduzir

O caminho completo, com o SQL verificado e as decisões de método, está no dossiê linkado acima e em [consultas/credito_rural_por_municipio.sql](../consultas/credito_rural_por_municipio.sql). Roda no chatbot da BD ou em qualquer BigQuery com as tabelas públicas. O CSV dos 5.380 municípios é recuperável pelo query_ref qr_8a918dd1.

## Saída pronta: esqueleto de história

- Gancho: para onde vai o crédito rural feito com dinheiro público.
- Figura central: o mapa dos 5.380 municípios (app aberta, link acima).
- Números: R$ 112,1 bi em 2023; concentração no oeste da Bahia, norte do Mato Grosso e Matopiba.
- Leitura honesta: valor rateado em partes iguais entre os imóveis da operação, não valor pago no município.
