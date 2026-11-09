# Dicionário de dados

## Registros de contratação (`dados/PNCP_UF_XX.zip`, Parquet)

Um registro por `numero_controle` (identificador PNCP da contratação). Tipos conforme o Parquet.

| Coluna | Tipo | Significado |
|---|---|---|
| numero_controle | texto | Identificador único do registro no PNCP (ex.: `01622882000190-1-000097/2026`). |
| cod_ibge | texto | Código IBGE do município do órgão. Chave do cruzamento com a dimensão. |
| municipio_pncp | texto | Nome do município como vem no PNCP. |
| cnpj_orgao | texto | CNPJ do órgão contratante. |
| orgao | texto | Nome do órgão, como publicado. |
| esfera | texto | Código de esfera conforme a API do PNCP. Valores observados: M (municipal), E (estadual), F (federal), D (distrital) e N (código presente na fonte; significado exato não confirmado nesta documentação). |
| poder | texto | Código de poder conforme a API. Valores observados: E, L, J, N (mesma ressalva). |
| objeto | texto | Descrição do objeto, como publicada. |
| modalidade | inteiro | Sempre 9 (Inexigibilidade) neste recorte. |
| situacao | texto | Domínio observado: "Divulgada no PNCP" (491.693), "Anulada" (1.498), "Revogada" (1.140), "Suspensa" (115). |
| publicacao | texto (data-hora) | Data/hora de publicação no PNCP, sem indicador de fuso na fonte (aparenta horário de Brasília; não confirmado). É o eixo do recorte. |
| atualizacao | texto (data-hora) | Última atualização do registro, mesmo formato sem fuso da fonte. |
| ano_compra | inteiro | Ano do ato declarado na fonte. Pode divergir do ano de publicação e contém valores inválidos óbvios (ex.: 20252025) preservados como vieram. |
| valor_estimado | decimal | Valor estimado do campo de publicação. **Não é valor pago nem gasto.** Contém inconsistências extremas preservadas (ver `derivados/anomalias_para_validar.csv`). |
| valor_homologado | decimal | Valor homologado do campo de publicação. Mesma ressalva. |
| amparo_legal | texto | Fundamento legal declarado. |
| link_origem | texto | Link de sistema de origem declarado pelo órgão na publicação. Em geral aponta para o registro no PNCP, mas órgãos também publicam links para sistemas próprios ou páginas externas. Preservado como dado da fonte, não verificado um a um. |
| arquivo_origem | texto | Nome do arquivo bruto de coleta de onde o registro veio. |
| sha256_origem | texto | Hash do arquivo bruto de origem (integridade, ver `ferramentas/manifest_consolidacao.json`). |
| lote | texto | Identificador do lote de coleta. |
| snapshot | texto | Identificador do snapshot de coleta. |
| ano_publicacao | inteiro | Ano derivado de `publicacao`. Partição física dos arquivos. |
| uf | texto | UF derivada de `cod_ibge`. Partição física dos arquivos. |

Nota: a cópia pública remove a coluna `url_drive_origem` do acervo original (referências internas de armazenamento, sem utilidade para reúso externo). Nenhum outro campo foi alterado.

## Dimensão de municípios (`ferramentas/dim_municipios.parquet`)

| Coluna | Tipo | Significado |
|---|---|---|
| cod_ibge | texto | Chave do município (5.571 localidades IBGE, incluindo Fernando de Noronha). |
| municipio_ibge | texto | Nome oficial IBGE. |
| pop_2025 | inteiro | População residente estimada, IBGE SIDRA 6579, ano 2025. |
| pib_2023_mil_reais | inteiro | PIB municipal 2023, em MIL reais, IBGE SIDRA 5938. Uma localidade sem valor. |
| rcl_2025 | decimal | Receita Corrente Líquida, exercício 2025, Siconfi RREO Anexo 03 (período 6, últimos 12 meses). Válida para 3.216 entes. |
| receitas_correntes_dca_2025 | decimal | Receitas correntes brutas realizadas (NÃO é RCL), Siconfi DCA 2025. Válida para 2.318 dos entes sem Anexo 03. |
| em_siconfi | lógico | Ente consta no universo Siconfi consultado (5.570). |
| status_receita | texto | Qual medida de receita está presente (`rcl_2025`, `dca_2025` ou ausência). 5.534/5.570 têm alguma medida — não 99,4% de RCL. |

Cruzamentos entre conceitos e anos diferentes (ex.: valor estimado sobre RCL) são escala contextual, não parcela de orçamento paga. Só registros de esfera municipal recebem razão contra receita do município.

## Classificação por categorias (`derivados/sidecar_categorias_v63.csv`)

| Coluna | Significado |
|---|---|
| numero_controle | Chave do registro (junta com os Parquet). |
| categoria | Uma de: artistico, capacitacao, aquisicao, saude, locacao, consultoria, manutencao, agua, credenciamento, transporte, outros. |
| subcategoria | Preenchida só em parte de `artistico` (ex.: show, carnaval, forro_sao_joao). |

Classificação por regras determinísticas sobre o texto do objeto. Fidelidade de 87,8% medida contra rótulos anteriores na base rotulada da Bahia (28.306 registros) — medida de fidelidade, não de correção nem de precisão nacional. Metodologia e validação em `derivados/README_CATEGORIZACAO.md` e `derivados/VALIDACAO_AMOSTRAL.md`.
