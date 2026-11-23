# SCR.data (Banco Central) e PAM (IBGE) com o SICOR

Sugestao de Angelo Ozelame (Lucro Rural) no post de credito rural: cruzar o SICOR com o SCR.data do Banco Central e com a Producao Agricola Municipal (PAM). Esta pasta registra o que a Base dos Dados (BD) tem, o que o BCB publica e como reproduzir.

Data da verificacao: 23/11/2026.

## O que existe, por fonte

| Fonte | Existe na BD? | Granularidade | Cruza com SICOR por municipio? |
|---|---|---|---|
| PAM/IBGE | Sim: `br_ibge_pam.lavoura_temporaria` e `br_ibge_pam.lavoura_permanente`, 1974 a 2024 segundo o chat da BD | municipio x ano x produto (`id_municipio`, 7 digitos) | Sim, por `id_municipio` |
| SCR.data (BCB) | Nao encontrado. O chat da BD so achou `br_bcb_estban.municipio` e `br_bcb_ifdata.relatorio`, que nao sao SCR | n/a | n/a |
| SCR.data direto no BCB | Sim | **UF**, nao municipio | So no nivel UF |

## SCR.data: o que o BCB publica

- Pagina: https://dadosabertos.bcb.gov.br/dataset/scr_data
- Metodologia: https://www.bcb.gov.br/pda/desig/metodologia_versao2.pdf
- Download: um ZIP por ano em `https://www.bcb.gov.br/pda/desig/scrdata_{ANO}.zip`, com um CSV por mes (`;` como separador, decimal com virgula). Sem login. O ZIP de 2024 tem cerca de 176 MB.
- Periodicidade: mensal, publicado no ultimo dia util do mes com 30 dias de defasagem (metodologia do BCB).
- Colunas (conferidas no CSV de dez/2024): `data_base, uf, segmento, cliente, cnae_ocupacao, porte, modalidade, submodalidade, origem, indexador, numero_de_operacoes`, faixas `a_vencer_*`, `carteira_a_vencer`, `vencido_de_15_ate_90_dias`, `vencido_acima_de_90_dias`, `carteira_vencida`, `carteira_ativa`, `carteira_inadimplencia`, `ativo_problematico`.
- **UF e a do tomador, nao do imovel nem da operacao.** Segundo a metodologia, vem do CEP de residencia da pessoa fisica ou da sede da pessoa juridica. Para SICOR x CAR (municipio do imovel) isso e uma diferenca de unidade de analise.
- Rural: nao ha coluna "rural" em `origem` (so "Com/Sem destinacao especifica"). O recorte rural e `modalidade` que comeca com "Financiamentos rurais" (submodalidades Custeio, Investimento, Comercializacao, Industrializacao em 2024). Em outros anos, conferir o nome.
- `numero_de_operacoes` traz -1 em celulas pequenas (valor sigiloso). Por isso o script nao soma esse campo.

## Definicoes usadas aqui

- **Credito (SICOR, cruzamento com PAM):** soma de `valor_parcela_credito` (tabela `br_bcb_sicor.operacao`, em BRL) por municipio, para operacoes de `ano_emissao = 2023` ligadas por `id_referencia_bacen` + `numero_ordem` ao `recurso_publico_complemento_operacao`. Nao e "valor contratado" literal, e so cobre operacoes com recursos publicos e municipio informado.
- **Inadimplencia (SCR):** `carteira_inadimplencia / carteira_ativa`. A coluna `carteira_inadimplencia` e a carteira com parcela vencida ha mais de 90 dias (metodologia do BCB). A razao calculada aqui e nossa conta sobre as linhas do CSV, nao um indicador publicado.

## Arquivos

- `scr_rural_por_uf.py`: baixa o ZIP do ano, filtra a modalidade rural, agrega por mes x UF x submodalidade e apaga o ZIP. Apenas biblioteca padrao. Uso: `python3 scr_rural_por_uf.py 2024 saida.csv`.
- `scr_rural_uf_2024.csv`: saida do script para 2024 (1.257 linhas, cerca de 170 KB), baixada em 23/11/2026 (coluna `baixado_em`). O BCB reprocessa meses antigos (datas de modificacao dentro do ZIP vao ate 20/11/2026), entao rode de novo antes de citar.
- `sicor_x_pam_2023_cobertura.sql`: consulta BigQuery (executada no chat da BD, somente leitura) que conta municipios do SICOR 2023, da PAM 2023 e os casados.

## Resultados verificados

**SCR rural, dez/2024** (recalculado do CSV baixado em 23/11/2026; soma das linhas da modalidade rural):

- Carteira ativa: R$ 766,9 bi. Inadimplencia nacional pela definicao acima: 1,93%.
- Maiores UFs por carteira: RS 103,4 bi (0,80%), PR 100,9 bi (1,31%), SP 91,3 bi (1,51%), MG 87,2 bi (1,82%), MT 83,6 bi (2,42%).

**Cobertura municipal SICOR x PAM, 2023** (numeros retornados pelo chat da BD ao executar o SQL desta pasta; nao foram reexecutados de forma independente):

| Metrica | Municipios |
|---|---|
| SICOR (complemento de recurso publico, 2023) | 5.440 |
| PAM lavoura temporaria | 5.563 |
| PAM lavoura permanente | 5.539 |
| Casados SICOR e PAM | 5.438 |
| So no SICOR | 2 |
| So na PAM | 125 |
| Diretorio de municipios da BD | 5.571 |

## Limites

- O SCR nao tem municipio. Ele nao responde "inadimplencia rural por municipio".
- O recorte rural do SCR e por modalidade de financiamento, nao por finalidade do tomador.
- O SICOR municipal vem de uma tabela de recursos publicos; os totais nao sao todo o credito rural do municipio.
- Cruzar credito (anual por emissao, ou saldo) com producao (PAM, anual por produto) exige decidir a medida antes. Cobertura de municipios nao e prova de relacao entre as duas.
- Nenhum dado individual ou CPF nesta pasta.
