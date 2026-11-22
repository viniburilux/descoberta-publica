# bd_reconciliation

Linha de reconciliação Base dos Dados × dados oficiais (OPERAÇÃO BD, 19/11/2026).

## O que há aqui

- `docs/`: método, dossiê T7 (rateio municipal SICOR × CAR), resultados dos pares A/B, desenho do experimento, ponteiros de integração LuxMemory/LuxOS.
- `experiencias/`: registros estruturados das experiências (T7, IBAMA, PRODES/MapBiomas, RAIS).
- `catalog/relationships/`: catálogo de relacionamentos entre tabelas (chaves, normalizações, cobertura).
- `configs/relationships/`: configs declarativas por família de reconciliação.
- `outputs/sql/`: suites SQL por família (estrutura, chaves, duplicidade, transformações, cobertura, resíduos).
- `outputs/`: cânones e mapas 2023 (CSV por município, PNG de entrega), app interativa "O Dinheiro e o Território" (`outputs/app/`).
- `outputs/runs/`: registros das execuções no executor oficial (chatbot BD).
- `inputs/`: exports das threads do executor BD (proveniência).
- `source/`: código-fonte da linha (recuperação de experiências, reconciliação, consulta ao catálogo, relatório).

## Fatos centrais (19/11/2026)

- Cânone 2023 (todas as finalidades, recurso público): R$ 112.125.325.594,22 territorializados em 5.380 municípios = 92,56% do subtotal classificado (R$ 121,13 bi); total de operações 2023 = R$ 406,40 bi.
- Recorte público: `indicador_recurso_publico = '1'` no catálogo de fontes da BD (16 códigos: os 15 da lista oficial do BC + FNDCT/0911, sem operações em 2023).
- Método: valor em `operacao.valor_parcela_credito` (id_referencia_bacen + numero_ordem); snapshot mais recente por imóvel; município via `area_imovel.id_municipio`; rateio igual entre imóveis da operação.
- Caso 2022 (investimento): R$ 48,29 bi conectados de R$ 52,42 bi (92,12%), 5.241 mun, 489.138 imóveis.
- Execução: chatbot Base dos Dados (executor oficial), query_refs qr_0ef8fb01 / qr_ceaa9c22 / qr_8a918dd1; thread 35bbb638.

## Leitura honesta

Valor rateado ≠ valor pago ≠ local do benefício. Município é o do imóvel rural associado à operação (CAR); os microdados SICOR descrevem essa tabela como propriedades relacionadas ao financiamento, sem papel jurídico de garantia declarado (fonte: documentação geo-credito-rural, seção Propriedades). Baselines em contexto separado não são auditoria independente.
