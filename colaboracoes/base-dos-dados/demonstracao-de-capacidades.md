---
id: demonstracao-capacidades-bd
type: demonstracao
---
# Demonstração de capacidades: o caso SICOR x CAR (BD-007)

Caso completo executado sobre a infraestrutura da Base dos Dados: da pergunta de investigação ao dataset validado e à produção científica.

## A pergunta

Onde está, territorialmente, o crédito rural contratado com recursos públicos no Brasil? A estatística oficial (MDCR, Banco Central) registra o município do contrato. Nós construímos a representação alternativa: o município do imóvel rural (CAR) associado a cada operação.

## O que foi produzido (tudo público neste repositório)

| Artefato | Onde |
|---|---|
| Consulta canônica 2023 (SQL parametrizado) | `investigacoes-bd/consultas/credito_rural_por_municipio.sql` |
| Dossiê da investigação BD-007 | `investigacoes-bd/investigacoes/BD-007-dinheiro-e-territorio.md` |
| Métodos e protocolo de reconciliação | `investigacoes-bd/metodos.md` |
| Mapa interativo municipal (HTML) | `investigacoes-bd/originais/bd_reconciliation/outputs/app/index.html` |
| CSV municipal nomeado | `investigacoes-bd/originais/bd_reconciliation/outputs/mapa_credito_rural_municipal_2023_nomeado.csv` |
| Manifesto de proveniência SHA-256 | `investigacoes-bd/manifesto-originais.json` |
| Guia de reprodução | `investigacoes-bd/REPRODUZIR.md` |

## Números principais (2023, cânone)

- R$ 406,4 bi: total SICOR 2023 (todos os recursos), reconciliado com o MDCR oficial (diferença de 0,05%).
- R$ 121,13 bi: recursos públicos classificados (MDCR oficial: R$ 121,05 bi; diferença de 0,07%).
- R$ 112,13 bi territorializados em 5.380 municípios via CAR (92,56% do total público).
- Dos 7,44% não territorializados (R$ 9,01 bi): 6,95 p.p. têm identificador CAR nulo (28.749 operações, R$ 8,42 bi) e 0,49 p.p. estão ausentes da tabela de ligação (1.577 operações, R$ 0,59 bi).
- Join SICOR-CAR: 0% literal -> 99,999% após normalização documentada do identificador.
- Série 2019-2025 pelo mesmo método: R$ 52,7 bi -> R$ 128,7 bi (+144%).
- Correlação municipal crédito x agricultura (MapBiomas): 0,68-0,80 por ano; crédito x pastagem: 0,35-0,47.

## O que o caso demonstra sobre a infraestrutura da BD

1. O catálogo público (SICOR, SICAR, PAM, MapBiomas) sustenta uma cadeia completa de produção: pergunta -> SQL reproduzível -> integração -> dataset derivado -> validação contra fonte oficial -> aplicação -> manuscrito científico.
2. As consultas foram executadas pelo chatbot da BD sobre BigQuery, com referências de query registradas para auditoria.
3. Lacunas observadas viram insumo para a BD: o agregado oficial MDCR não está no catálogo (fonte externa usada só para validação), e o histórico de extrações do SICAR na BD cobre apenas a janela recente (jun-ago/2026).

## Produção científica associada

- Manuscrito em preparação para Data in Brief (descrição do dataset, método e validação).
- Depósito Zenodo do dataset em rascunho (DOI reservado 10.5281/zenodo.24453249; publicação mediante decisão do autor).
