# Investigações na Base dos Dados

Acervo de trabalho das 12 frentes BD do Descoberta Pública. Perguntas, código, consultas, resultados, mapas, documentos e versões originais.

[**Abrir o painel das 12 investigações**](PAINEL.md) · [Reproduzir os pacotes](REPRODUZIR.md) · [Arquivos originais](originais/) · [Manifesto SHA-256](manifesto-originais.json)

## Começar pelo material

- **Conversas:** [15 threads, 174 mensagens, perguntas e respostas integrais](conversas/), com leitura cronológica, SQL separado e tabelas registradas.

- **Crédito rural:** [CSV de 5.380 municípios](originais/bd_reconciliation/outputs/mapa_credito_rural_municipal_2023_nomeado.csv), [mapa PNG](originais/bd_reconciliation/outputs/mapa_entrega_canone_2023.png), [app HTML](originais/bd_reconciliation/outputs/app/index.html) e [SQL](consultas/credito_rural_por_municipio.sql).
- **Reconciliação:** [21 SQLs](originais/bd_reconciliation/outputs/sql/), [4 configs](originais/bd_reconciliation/configs/relationships/), [Python](originais/bd_reconciliation/source/) e [catálogo](originais/bd_reconciliation/catalog/).
- **Rondon do Pará e Bom Sucesso:** [timeline Rondon](originais/drive-2026-11-20/timeline_rondon_do_para.md), [timeline Bom Sucesso](originais/drive-2026-11-20/timeline_sfc_bom_sucesso.md), [síntese v2](originais/drive-2026-11-20/sintese_aprofundamento_2026-11-20_v2.md), [evidências geoespaciais](originais/pacote_evidencias_20261120/) e [séries TIFF](originais/versoes/lulc_10m_evidencias_v2/).
- **Experiência da máquina:** [desenho A/B](originais/bd_reconciliation/docs/experimento_ab_desenho.md), [par 1](originais/bd_reconciliation/docs/ab_resultado_par1.md), [par 2](originais/bd_reconciliation/docs/ab_resultado_par2_reparo.md) e [recuperador](originais/bd_reconciliation/source/retrieve_experience.py).

## Investigações

- [BD-001: Garimpo PNCP: festas e eventos](investigacoes/BD-001-pncp-festas.md)
- [BD-002: Reconhecimento do catálogo](investigacoes/BD-002-reconhecimento-catalogo.md)
- [BD-003: Infraestrutura, emendas e internações](investigacoes/BD-003-reconhecimento-infra-emendas-saude.md)
- [BD-004: Vinte cruzamentos exploratórios](investigacoes/BD-004-vinte-cruzamentos.md)
- [BD-005: Mapa de entidades em seis camadas](investigacoes/BD-005-mapa-entidades.md)
- [BD-006: Inventário territorial e SICOR × CAR](investigacoes/BD-006-inventario-territorial-sicor-car.md)
- [BD-007: O Dinheiro e o Território](investigacoes/BD-007-dinheiro-e-territorio.md)
- [BD-008: Executor de reconciliação](investigacoes/BD-008-executor-reconciliacao.md)
- [BD-009: Catálogo de reconciliação](investigacoes/BD-009-catalogo-reconciliacao.md)
- [BD-010: Micro-CARs, Rondon do Pará e Bom Sucesso](investigacoes/BD-010-micro-cars.md)
- [BD-011: Ciclo de experiência da máquina](investigacoes/BD-011-ciclo-experiencia-maquina.md)
- [BD-012: Mapa do MCP da BD](investigacoes/BD-012-mcp-mapa-proposta.md)

## Documentos e aplicações

- [O Dinheiro e o Território](https://files.instinct.com/0ge7iva44a3a-o-dinheiro-e-o-territorio).
- [Crédito rural por município, SICOR 2023](https://files.instinct.com/5gs9dgjmfr9g-credito-rural-por-municipio-sicor-2023).
- [A história territorial dos dois casos](https://files.instinct.com/5upblg04u1v8-a-historia-territorial-dos-dois-casos).
- [Mapa do MCP da BD](https://files.instinct.com/pl7nm8txk6ks-mcp-de-gestao-da-bd-mapa).

## Origem e versão

Originais recuperados dos pacotes BD de 19 e 20/11/2026, dos arquivos de trabalho no Drive e dos três produtos cujas fontes estão em `originais/produtos/`. [Inventário de origem](origens-drive.json). Os identificadores `query_ref` e os identificadores de sessão permanecem nos arquivos originais. Conversas recuperadas: [15 threads e 174 mensagens](conversas/), com SQLs, chamadas e respostas extraídos. Os arquivos nativos apenas referenciados nos downloads seguem identificados no painel.
