# Consultas prontas

Consultas SQL executadas nas sessões de 18 a 20/11/2026. Todas rodam no chatbot da [Base dos Dados](https://basedosdados.org/chatbot) ou em qualquer projeto BigQuery com acesso às tabelas públicas da BD. Medem e cruzam apenas dados públicos.

| Arquivo | O que faz | Frente |
|---------|-----------|--------|
| [credito_rural_por_municipio.sql](credito_rural_por_municipio.sql) | Rateia o crédito rural com recurso público pelos municípios dos imóveis CAR (caso 2022 verificado; cânone 2023 no cabeçalho) | BD-007, BD-008 |
| [sicor_car_03_transformacoes.sql](sicor_car_03_transformacoes.sql) | Prova que o join literal SICOR × CAR dá 0% e que a normalização do código resolve | BD-006 |
| [sicor_car_04_cobertura.sql](sicor_car_04_cobertura.sql) | Mede a cobertura do join por ano | BD-006 |
| [ibama_autos_embargos_04_cobertura.sql](ibama_autos_embargos_04_cobertura.sql) | Cobertura embargo × auto de infração (99,94%) | BD-009 |
| [prodes_mapbiomas_04_cobertura.sql](prodes_mapbiomas_04_cobertura.sql) | Cobertura PRODES × MapBiomas (98,49%) | BD-009 |
| [rais_cnae_04_cobertura.sql](rais_cnae_04_cobertura.sql) | Cobertura RAIS × CNAE (99,86%) | BD-009 |


[Suítes originais e configurações](../originais/bd_reconciliation/) · [Reprodução local](../REPRODUZIR.md).
