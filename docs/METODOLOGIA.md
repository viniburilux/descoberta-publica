# Metodologia

## Coleta

- Fonte: API pública de dados abertos do PNCP (`/api/consulta/v1/contratacoes/publicacao`), por UF, janela de datas e modalidade 9, sem cadastro.
- Coleta por UF ao longo de horas (não é snapshot atômico). Acervo principal em agosto/2026; complemento de setembro–início de novembro/2026 em coleta posterior, incorporado antes desta versão.
- 621 arquivos brutos, todos com SHA256 conferido contra os manifestos de coleta (`ferramentas/manifest_consolidacao.json`, `ferramentas/auditoria_arquivos.json`). Originais preservados sem alteração no acervo privado.

## Consolidação

- 494.496 linhas brutas → 494.446 registros únicos após remoção de 50 repetições de `numero_controle`.
- Critério de deduplicação: manter a atualização mais recente, depois snapshot e arquivo. Os 50 grupos estão em `ferramentas/duplicatas_auditoria.parquet`. Nenhum grupo variou valor estimado, objeto ou UF nos campos-chave conferidos — não significa que todos os campos eram idênticos.
- 100% dos registros casados com código IBGE (`sem_join_ibge: 0` em `qualidade.json`).

## Dimensão de municípios

- Localidades IBGE; população SIDRA 6579 (2025); PIB SIDRA 5938 (2023).
- Receita: Siconfi RREO Anexo 03 (RCL 2025) e DCA (receitas correntes 2025). Cobertura parcial por desenho — ver dicionário de dados.
- A dimensão fica em tabela separada dos fatos e é cruzada por `cod_ibge` na consulta (`consultar.py` monta a visão `compras_contexto`).

## Classificação por categorias (derivado)

- Regras determinísticas sobre o texto do objeto, destiladas de um esquema anterior de rótulos (processo anterior de classificação registro a registro). Não é o mesmo método nem o reproduz integralmente.
- Referência de fidelidade: 87,8% de concordância com os rótulos anteriores na base rotulada da Bahia (28.306 registros). É medida de fidelidade a rótulos que contêm erros próprios, não de correção nem de precisão nacional.
- Validação amostral lida uma a uma e histórico de correções (v6.2 → v6.3) documentados em `derivados/VALIDACAO_AMOSTRAL.md` e `derivados/README_CATEGORIZACAO.md`.

## Esta cópia pública (v0.1)

- Idêntica ao acervo em conteúdo, com duas higienizações: remoção da coluna interna `url_drive_origem` (links de armazenamento restrito) dos registros e remoção do mesmo campo dos arquivos derivados. Contagens por UF/ano conferidas após a transformação.
- Ajuste de texto do `consultar.py` (docstring dizia "consulta privada"; a ferramenta é a mesma).
