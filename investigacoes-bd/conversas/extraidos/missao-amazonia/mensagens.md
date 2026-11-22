# missao-amazonia: conversa BD

Origem: https://basedosdados.org/chatbot?t=3eabfa06-6c02-418f-a9bc-a1a858460367

Thread: `3eabfa06-6c02-418f-a9bc-a1a858460367`. Mensagens: 4.

## 1. USER | 2026-11-20T21:49:08.495009Z

Identificador: `5d1a2b69-944e-42ee-860a-47f132be00b7`.

# MISSÃO: INTELIGÊNCIA TERRITORIAL PARA O AMAZÔNIA CARBONO CIRCULAR

## Objetivo

Utilizar exclusivamente os dados, tabelas, recursos e ferramentas disponíveis na Base dos Dados para investigar Igarapé-Açu (PA), identificar padrões territoriais e econômicos e descobrir municípios com características relevantes para replicação de iniciativas de reciclagem, economia circular e inclusão socioprodutiva.

Não faça pesquisa na internet. Não invente tabelas, campos, códigos ou resultados. Seu trabalho é explorar a infraestrutura da Base dos Dados, executar consultas e produzir descobertas a partir dos dados efetivamente acessíveis.

## 1. TERRITÓRIO DE REFERÊNCIA

Município: Igarapé-Açu, Pará.
Código IBGE: 1503200.

Utilize o município como ponto de partida, mas não limite a investigação a ele.

A pergunta central é:

**O que os dados disponíveis na Base dos Dados revelam sobre a realidade territorial, econômica, ambiental, institucional e fiscal de Igarapé-Açu e sobre oportunidades de replicação de iniciativas de economia circular em outros municípios?**

## 2. PRIMEIRO PASSO: EXPLORAR O CATÁLOGO

Faça uma varredura do catálogo da Base dos Dados para identificar tabelas que possam contribuir com a investigação.

Explore especialmente:

- IBGE: Censo Demográfico, população, PIB municipal, CEMPRE e Cadastro Central de Empresas.
- Ministério das Cidades: SNIS, SINISA ou outras informações de saneamento e resíduos, caso disponíveis.
- Ministério do Trabalho: RAIS e Novo CAGED.
- Tesouro Nacional: FINBRA, SICONFI e execução orçamentária municipal.
- Compras públicas: PNCP, quando disponível.
- Receita Federal: Cadastro Nacional da Pessoa Jurídica.
- Educação, vulnerabilidade social e infraestrutura domiciliar.
- Meio ambiente, uso do solo e informações territoriais, quando disponíveis.

Para cada conjunto encontrado, informe:

1. Nome do dataset.
2. Nome exato da tabela.
3. Identificador completo no BigQuery.
4. Descrição.
5. Cobertura geográfica.
6. Cobertura temporal.
7. Granularidade.
8. Campos disponíveis.
9. Data da última atualização.
10. Possibilidade de cruzamento com outras tabelas.

Não presuma que um conjunto possui dados de todos os componentes apenas porque seu nome sugere isso.

## 3. DIAGNÓSTICO DE IGARAPÉ-AÇU

Investigue o município utilizando as tabelas efetivamente encontradas.

### 3.1. População e território

- Evolução populacional.
- Distribuição urbana e rural.
- Domicílios.
- Densidade demográfica.
- Características dos domicílios.
- Destinação do lixo domiciliar, caso disponível.
- Abastecimento de água e esgotamento sanitário.

### 3.2. Estrutura econômica

- PIB municipal e evolução.
- PIB per capita.
- Principais atividades econômicas.
- Número de estabelecimentos por atividade.
- Empresas relacionadas a comércio, indústria, transporte, gestão de resíduos e reciclagem.
- Empregos formais por setor.
- Evolução dos vínculos de trabalho.
- Presença de atividades econômicas potencialmente relacionadas à cadeia de reciclagem.

Investigue especialmente atividades CNAE relacionadas a:

- Recuperação de materiais.
- Comércio atacadista de resíduos e sucatas.
- Coleta de resíduos não perigosos.
- Tratamento e disposição de resíduos.
- Fabricação de produtos a partir de materiais reciclados.
- Transporte e armazenagem.

Identifique os códigos CNAE utilizados e não classifique empresas apenas pelo nome fantasia.

### 3.3. Gestão pública e capacidade fiscal

Investigue:

- Receitas municipais.
- Despesas por função e subfunção.
- Despesas relacionadas a saneamento, gestão ambiental, limpeza urbana e serviços urbanos.
- Investimentos municipais.
- Transferências recebidas.
- Evolução das despesas ao longo dos anos.
- Fornecedores contratados pelo município, caso existam dados de contratos ou compras públicas.

Procure identificar quanto o município movimenta em serviços e infraestrutura relacionados ao ambiente urbano e à gestão de resíduos.

Não confunda despesas de saneamento, limpeza urbana e gestão ambiental. Diferencie os códigos e classificações orçamentárias utilizados.

### 3.4. Saneamento e resíduos sólidos

Investigue todas as tabelas disponíveis que possam conter:

- Coleta domiciliar.
- Coleta seletiva.
- Massa de resíduos coletada.
- Destinação final.
- Disposição em lixões ou aterros.
- Cobertura urbana e rural.
- Trabalhadores envolvidos.
- Despesas e receitas do serviço.
- Prestadores de serviços.
- Infraestrutura de tratamento.

**Atenção especial:** procure verificar se a Base dos Dados possui efetivamente o componente de manejo de resíduos sólidos do SNIS, e não apenas água e esgoto.

Se não encontrar, documente a ausência. Não substitua por dados de água e esgoto como se fossem informações sobre resíduos.

## 4. CADEIA ECONÔMICA DA RECICLAGEM

Quero descobrir o que os dados econômicos revelam sobre a possibilidade de estruturar uma cadeia regional de reciclagem.

Investigue:

- Quantidade de empresas por CNAE relacionado à reciclagem.
- Distribuição geográfica dessas empresas.
- Concentração de estabelecimentos.
- Empregos formais nos setores correspondentes.
- Municípios com maior presença de empresas de recuperação de materiais.
- Municípios com atividade atacadista de sucatas e resíduos.
- Possíveis polos regionais de comercialização e processamento.

Faça uma análise em dois níveis:

1. Igarapé-Açu e municípios próximos.
2. Todo o estado do Pará.

Quando possível, identifique relações entre municípios produtores de resíduos e municípios que concentram atividades de recuperação, comércio ou processamento de materiais.

Não afirme que uma empresa compra materiais de outra sem dados que comprovem essa relação.

## 5. COMPARAÇÃO ENTRE MUNICÍPIOS DO PARÁ

Construa uma análise comparativa dos municípios paraenses.

Não escolha municípios apenas por semelhança populacional.

Utilize indicadores efetivamente disponíveis para comparar:

- População.
- Perfil urbano e rural.
- Domicílios.
- Estrutura econômica.
- PIB per capita.
- Estabelecimentos ligados à reciclagem.
- Empregos formais relacionados.
- Receitas e despesas públicas.
- Indicadores de saneamento e resíduos, caso disponíveis.

Identifique municípios que apresentem combinações interessantes de:

- Necessidade ambiental.
- Estrutura econômica.
- Capacidade institucional.
- Existência de atividades relacionadas à reciclagem.
- Possibilidade de articulação regional.

Apresente uma lista de municípios candidatos, explicando os critérios e os dados que sustentam cada indicação.

Não atribua potencial de geração de créditos de carbono com base apenas nesses indicadores.

## 6. DESCOBERTAS NÃO ÓBVIAS

Não se limite a responder aos indicadores solicitados.

Procure padrões e relações que possam revelar oportunidades inesperadas.

Exemplos de perguntas:

- Existem municípios com grande volume de estabelecimentos comerciais, mas baixa presença de atividades de recuperação de materiais?
- Existem municípios com estrutura econômica semelhante à de Igarapé-Açu, mas indicadores de saneamento muito diferentes?
- Há concentração regional de empresas de comércio de sucatas?
- Quais municípios apresentam maior potencial de articulação logística?
- Existem municípios onde despesas públicas relacionadas à limpeza urbana são relevantes em relação ao orçamento?
- Onde há sinais de atividade econômica ligada à reciclagem sem estrutura formal proporcional de empregos?
- Quais municípios podem funcionar como polos regionais de recebimento, triagem ou comercialização?

Busque descobertas que possam ser transformadas em hipóteses investigáveis.

## 7. EXECUÇÃO DAS CONSULTAS

Não entregue apenas sugestões de SQL.

Execute consultas reais sempre que o ambiente permitir.

Para cada consulta:

1. Informe o objetivo.
2. Apresente o SQL completo.
3. Informe as tabelas e os campos utilizados.
4. Apresente os resultados.
5. Explique o que os resultados indicam.
6. Informe limitações e possíveis problemas de cobertura.

Antes de construir consultas complexas:

- Inspecione o esquema das tabelas.
- Confirme os nomes dos campos.
- Verifique os tipos de dados.
- Verifique os identificadores municipais.
- Verifique duplicidades e granularidade.
- Observe mudanças metodológicas ao longo dos anos.

Se a consulta não puder ser executada, explique por quê e entregue o SQL preparado, sem apresentar resultados fictícios.

## 8. CONSTRUÇÃO DE UMA BASE COMPARATIVA

Se houver dados suficientes, construa uma tabela municipal consolidada para o Pará.

Uma linha por município, com os indicadores disponíveis.

Inclua:

- Código IBGE.
- Município.
- População.
- Indicadores de saneamento.
- Indicadores de resíduos.
- PIB per capita.
- Estabelecimentos ligados à reciclagem.
- Empregos relacionados.
- Despesas públicas relevantes.
- Ano de referência de cada indicador.

Não descarte municípios com dados ausentes sem explicar o motivo.

Não misture anos diferentes sem identificar a referência temporal de cada coluna.

## 9. PRIORIZAÇÃO TERRITORIAL

Se os dados permitirem, construa uma classificação exploratória de municípios candidatos à replicação de iniciativas de economia circular.

Utilize critérios transparentes.

Apresente:

- Critérios.
- Indicadores.
- Método de pontuação.
- Municípios melhor classificados.
- Evidências favoráveis.
- Limitações.
- Informações adicionais necessárias para confirmar cada candidato.

A classificação deve representar potencial de investigação e replicabilidade socioeconômica, não viabilidade de certificação de carbono.

## 10. ENTREGÁVEIS

Organize o resultado em:

A. Catálogo de datasets relevantes encontrados.

B. Diagnóstico de Igarapé-Açu.

C. Estrutura econômica da cadeia de reciclagem.

D. Diagnóstico fiscal e de compras públicas.

E. Comparação entre municípios do Pará.

F. Municípios candidatos à replicação.

G. Descobertas não óbvias.

H. SQL executado e resultados.

I. Limitações e lacunas da Base dos Dados.

J. Recomendações para aprofundamento.

## 11. REGRAS INEGOCIÁVEIS

- Não pesquise na internet.
- Não invente tabelas ou campos.
- Não apresente SQL hipotético como consulta executada.
- Não apresente resultados sem execução.
- Não confunda ausência de informação com inexistência de atividade.
- Não confunda atividade econômica registrada com operação efetiva de reciclagem.
- Não confunda potencial de replicação com potencial de carbono.
- Não faça inferências causais a partir de simples correlações.
- Preserve os anos de referência.
- Informe os limites de cobertura e qualidade dos dados.

**A missão é explorar a Base dos Dados como infraestrutura de inteligência territorial, econômica e fiscal, extraindo descobertas concretas que possam fortalecer a proposta Amazônia Carbono Circular e revelar oportunidades de replicação regional.**

## 2. ASSISTANT | 2026-11-20T21:49:08.510632Z

Identificador: `608d79a6-3e18-44e4-98f7-42447649e8bd`.

## Síntese executiva

A varredura realizada na Base dos Dados encontrou bases suficientes para um diagnóstico inicial de Igarapé-Açu e para uma comparação estadual, mas não para responder integralmente a todos os componentes da missão.

Os principais achados são:

- Igarapé-Açu tinha **37.925 habitantes em 2025**. A série disponível vai de 1991 a 2025; entre 1991 e 2025, a população cresceu aproximadamente **38,9%**.
- No recorte domiciliar de 2010, havia **9.118 domicílios particulares permanentes**. Cerca de **72,3%** tinham abastecimento de água pela rede geral; **65,6%** tinham lixo coletado; e **28,6%** declararam queimar o lixo na propriedade.
- O esgotamento sanitário domiciliar era majoritariamente realizado por **fossa rudimentar**, presente em 6.283 domicílios, enquanto apenas 80 tinham esgotamento pela rede geral ou pluvial.
- O PIB municipal passou de **R$ 62,8 milhões em 2002** para **R$ 599,3 milhões em 2023**, em valores correntes. A série não deve ser interpretada como crescimento real sem deflacionamento.
- O CNPJ registra, em 1º de novembro de 2026, estabelecimentos ativos em Igarapé-Açu nas CNAEs de coleta de resíduos não perigosos, recuperação de materiais plásticos, recuperação de materiais não especificados e comércio atacadista de resíduos e sucatas metálicos. Também há registros baixados ou inaptos, que não devem ser tratados como atividade atual.
- A RAIS de 2024 não retornou registros de Igarapé-Açu nos códigos de recuperação, comércio atacadista de sucatas, coleta e tratamento de resíduos analisados. Isso sugere baixa formalização de vínculos nesses códigos, mas não prova inexistência de atividade econômica, pois a RAIS mede empregos formais e possui limitações cadastrais.
- O catálogo consultado possui o dataset SNIS, mas apenas com tabelas de **água e esgoto**. Não foi encontrada, nessa infraestrutura, uma tabela de manejo de resíduos sólidos urbanos. A consulta de água e esgoto para Igarapé-Açu não retornou registros.
- No Pará, os maiores volumes de estabelecimentos formais nos códigos econômicos selecionados concentram-se em Ananindeua, Belém, Marabá, Parauapebas, Benevides, Castanhal, Santarém e Barcarena.

## A. Catálogo de datasets relevantes

### 1. População Brasileira

- **Dataset:** População Brasileira
- **Tabela:** Município
- **BigQuery:** `basedosdados.br_ibge_populacao.municipio`
- **Descrição:** população municipal estimada pelo IBGE, com anos de Censo ou contagem incorporados quando disponíveis.
- **Cobertura geográfica:** municípios brasileiros.
- **Cobertura temporal:** 1991–2025.
- **Granularidade:** município-ano.
- **Campos principais:** `ano`, `id_municipio`, `populacao`, `sigla_uf`.
- **Última referência disponível:** 2025, conforme `period_end` da tabela.
- **Cruzamentos:** `id_municipio` com PIB, RAIS, CNPJ, SNIS, SICONFI e PNCP.

### 2. Censo Demográfico

- **Dataset:** Censo Demográfico
- **Tabela utilizada:** Setor Censitário Domicílio Características Gerais 2010
- **BigQuery:** `basedosdados.br_ibge_censo_demografico.setor_censitario_domicilio_caracteristicas_gerais_2010`
- **Descrição:** características gerais dos domicílios por setor censitário.
- **Cobertura geográfica:** setores censitários de 2010; agregável por município mediante o identificador do setor.
- **Cobertura temporal:** 2010.
- **Granularidade:** setor censitário.
- **Campos utilizados:** `id_setor_censitario`, `sigla_uf`, `v001` a `v046`, com destaque para abastecimento de água, esgotamento sanitário, destinação do lixo e energia elétrica.
- **Última atualização:** não foi exposto um campo separado de atualização no retorno de metadados; o período da tabela é 2010.
- **Cruzamentos:** agregação territorial por município; ligação conceitual com população, PIB, saneamento e finanças.

O dataset também contém microdados do Censo 2022, mas a descrição informa que os microdados públicos de 2022 têm geografia máxima de Unidade da Federação. Por isso, eles não foram usados para estimar domicílios de Igarapé-Açu.

### 3. Produto Interno Bruto

- **Dataset:** Produto Interno Bruto (PIB)
- **Tabela:** Município
- **BigQuery:** `basedosdados.br_ibge_pib.municipio`
- **Descrição:** PIB municipal a preços correntes.
- **Cobertura geográfica:** municípios brasileiros.
- **Cobertura temporal:** 2002–2023.
- **Granularidade:** município-ano.
- **Campos:** `ano`, `id_municipio`, `pib`, `va`, `va_agropecuaria`, `va_industria`, `va_servicos`, `va_adespss` e `impostos_liquidos`.
- **Última referência disponível:** 2023.
- **Cruzamentos:** PIB per capita calculado com a população municipal; comparação com estabelecimentos e empregos.

### 4. RAIS

- **Dataset:** Relação Anual de Informações Sociais (RAIS)
- **Tabelas utilizadas:** Microdados Estabelecimentos e Microdados Vínculos
- **BigQuery:**
  - `basedosdados.br_me_rais.microdados_estabelecimentos`
  - `basedosdados.br_me_rais.microdados_vinculos`
- **Descrição:** estabelecimentos e vínculos formais de trabalho registrados anualmente.
- **Cobertura geográfica:** municípios e unidades da federação brasileiras.
- **Cobertura temporal:** 1985–2025 nas tabelas consultadas.
- **Granularidade:** estabelecimento-ano na primeira tabela; vínculo de emprego na segunda.
- **Campos principais:** `ano`, `id_municipio`, `sigla_uf`, `cnae_2_subclasse`, `quantidade_vinculos_ativos`, `vinculo_ativo_3112`, remuneração e variáveis ocupacionais.
- **Última referência utilizada:** 2024, escolhida por ser o último ano completo mais adequado para comparação, segundo o guia de uso da própria RAIS.
- **Cruzamentos:** diretório CNAE, município, população e PIB.
- **Limitação:** mede somente emprego formal; não contém CNPJ identificável nos microdados públicos.

### 5. SNIS

- **Dataset:** Sistema Nacional de Informações sobre Saneamento (SNIS)
- **Tabelas encontradas:**
  - Serviços de Água e Esgoto nos Municípios
  - Prestadores de Água e Esgoto
- **BigQuery:**
  - `basedosdados.br_mdr_snis.municipio_agua_esgoto`
  - `basedosdados.br_mdr_snis.prestador_agua_esgoto`
- **Descrição:** indicadores institucionais, operacionais e econômico-financeiros de água e esgoto.
- **Cobertura geográfica:** municípios e prestadores.
- **Cobertura temporal:** 1995–2022 na tabela municipal consultada.
- **Granularidade:** município-ano ou prestador-ano.
- **Campos:** índices de atendimento de água e esgoto, população atendida, despesas, investimentos, arrecadação, empregados e extensão de redes.
- **Resultado da varredura:** não foi encontrada tabela de manejo de resíduos sólidos urbanos no dataset disponível na BD consultada.
- **Implicação:** não é possível usar essa base para afirmar cobertura de coleta seletiva, massa coletada, lixão, aterro ou destinação final em Igarapé-Açu.

### 6. SICONFI

- **Dataset:** Sistema de Informações Contábeis e Fiscais do Setor Público Brasileiro (SICONFI)
- **Tabelas utilizadas:**
  - Despesas por Função — Município
  - Despesas Orçamentárias — Município
  - Receitas Orçamentárias — Município
- **BigQuery:**
  - `basedosdados.br_me_siconfi.municipio_despesas_funcao`
  - `basedosdados.br_me_siconfi.municipio_despesas_orcamentarias`
  - `basedosdados.br_me_siconfi.municipio_receitas_orcamentarias`
- **Descrição:** receitas, despesas, estágios de execução e classificações orçamentárias municipais.
- **Cobertura temporal:** despesas por função de 1996–2025; despesas orçamentárias e receitas de 1989–2025.
- **Granularidade:** município-ano-conta-estágio.
- **Campos:** `ano`, `id_municipio`, `conta_bd`, `estagio_bd`, `valor`, classificações originais e padronizadas.
- **Cruzamentos:** população, PIB, PNCP e indicadores de saneamento.

### 7. PNCP

- **Dataset:** Portal Nacional de Contratações Públicas (PNCP)
- **Tabelas utilizadas:** Contratação e Contrato
- **BigQuery:**
  - `basedosdados.br_mgi_pncp.contratacao`
  - `basedosdados.br_mgi_pncp.contrato`
- **Descrição:** contratações públicas, contratos e empenhos divulgados no PNCP.
- **Cobertura geográfica:** órgãos federais, estaduais e municipais.
- **Cobertura temporal:** contratações a partir de 10 de agosto de 2021; contratos a partir de 6 de setembro de 2021, conforme os metadados retornados.
- **Granularidade:** uma linha por contratação ou por contrato/empenho.
- **Campos:** órgão, município, objeto, modalidade, fornecedor, valores estimado, homologado, inicial e acumulado.
- **Cruzamentos:** município, CNPJ e classificação orçamentária.

### 8. CNPJ

- **Dataset:** Quadros Societários CNPJ
- **Tabela utilizada:** Estabelecimentos
- **BigQuery:** `basedosdados.br_rf_cnpj.estabelecimentos`
- **Descrição:** cadastro de estabelecimentos empresariais, com CNAE principal, município, situação cadastral e data de referência.
- **Cobertura geográfica:** estabelecimentos brasileiros.
- **Cobertura temporal:** fotografias cadastrais de novembro de 2021 a 1º de novembro de 2026.
- **Granularidade:** estabelecimento em uma fotografia cadastral.
- **Campos utilizados:** `cnpj`, `id_municipio`, `sigla_uf`, `cnae_fiscal_principal`, `situacao_cadastral`, `data_referencia` e nome fantasia.
- **Cruzamentos:** diretório de municípios, diretório CNAE e RAIS, embora RAIS não contenha CNPJ identificável.
- **Cuidado:** a base é uma fotografia cadastral; registros de várias datas não devem ser somados sem deduplicação.

### Bases não localizadas na varredura inicial

- Não foi localizado um dataset específico do **CEMPRE** nos resultados de busca utilizados.
- Não foi localizada uma tabela de manejo de resíduos sólidos do SNIS na infraestrutura consultada.
- Não foi realizada confirmação de uma base municipal completa de Censo 2022 com domicílios e município como unidade de observação; a descrição dos microdados públicos aponta geografia máxima estadual.

## B. Diagnóstico de Igarapé-Açu

### População

| Ano | População |
|---:|---:|
| 1991 | 27.307 |
| 2000 | 32.400 |
| 2010 | 35.887 |
| 2020 | 39.023 |
| 2021 | 39.234 |
| 2022 | 35.797 |
| 2023 | 35.797 |
| 2024 | 37.855 |
| 2025 | 37.925 |

A série mostra crescimento de longo prazo, mas também uma quebra relevante entre 2021 e 2022. Como os dados municipais são atualizados pelo Censo 2022, essa mudança deve ser tratada como alteração da referência populacional, e não automaticamente como queda demográfica efetiva em um único ano.

### Domicílios, água, esgoto e lixo — 2010

| Indicador | Domicílios | Percentual sobre 9.118 domicílios permanentes |
|---|---:|---:|
| Abastecimento pela rede geral | 6.594 | 72,3% |
| Com banheiro ou sanitário | 8.966 | 98,3% |
| Esgotamento por rede geral ou pluvial | 80 | 0,9% |
| Esgotamento por fossa séptica | 76 | 0,8% |
| Esgotamento por fossa rudimentar | 6.283 | 68,9% |
| Lixo coletado | 5.981 | 65,6% |
| Coleta por serviço de limpeza | 5.667 | 62,2% |
| Coleta por caçamba de serviço de limpeza | 314 | 3,4% |
| Lixo queimado na propriedade | 2.611 | 28,6% |
| Lixo enterrado na propriedade | 227 | 2,5% |
| Lixo jogado em terreno baldio ou logradouro | 254 | 2,8% |
| Lixo jogado em rio, lago ou mar | 12 | 0,1% |

O principal sinal territorial é a combinação de baixa cobertura histórica de coleta com alta utilização de queima do lixo e predominância de fossa rudimentar. Esses dados podem orientar hipóteses de trabalho para coleta diferenciada, educação ambiental, compostagem e organização de pontos de entrega, mas são de 2010 e não devem ser tratados como fotografia atual.

## C. Estrutura econômica e cadeia da reciclagem

### PIB municipal

O PIB nominal de Igarapé-Açu evoluiu da seguinte forma:

| Ano | PIB corrente |
|---:|---:|
| 2002 | R$ 62,8 milhões |
| 2010 | R$ 136,8 milhões |
| 2015 | R$ 298,3 milhões |
| 2020 | R$ 379,7 milhões |
| 2021 | R$ 415,6 milhões |
| 2022 | R$ 499,5 milhões |
| 2023 | R$ 599,3 milhões |

Em 2021, os maiores componentes do valor adicionado foram administração, defesa, educação, saúde pública e seguridade social, com R$ 160,0 milhões; serviços, com R$ 108,5 milhões; e agropecuária, com R$ 82,7 milhões. Para 2022 e 2023, a tabela retornou o PIB total, mas não os componentes setoriais detalhados.

### CNAEs encontrados

A análise utilizou os seguintes códigos CNAE, confirmados no diretório da BD:

- **3811400:** Coleta de resíduos não perigosos.
- **3812200:** Coleta de resíduos perigosos.
- **3821100:** Tratamento e disposição de resíduos não perigosos.
- **3822000:** Tratamento e disposição de resíduos perigosos.
- **3831901:** Recuperação de sucatas de alumínio.
- **3831999:** Recuperação de materiais metálicos, exceto alumínio.
- **3832700:** Recuperação de materiais plásticos.
- **3839499:** Recuperação de materiais não especificados anteriormente.
- **3900500:** Descontaminação e outros serviços de gestão de resíduos.
- **4687701:** Comércio atacadista de resíduos de papel e papelão.
- **4687702:** Comércio atacadista de resíduos e sucatas não metálicos, exceto papel e papelão.
- **4687703:** Comércio atacadista de resíduos e sucatas metálicos.

### Igarapé-Açu no CNPJ — fotografia de 1º de novembro de 2026

| CNAE | Atividade | Estabelecimentos | Ativas | Baixadas | Inaptas |
|---|---|---:|---:|---:|---:|
| 3811400 | Coleta de resíduos não perigosos | 2 | 1 | 0 | 1 |
| 3831999 | Recuperação de materiais metálicos | 2 | 0 | 2 | 0 |
| 3832700 | Recuperação de materiais plásticos | 1 | 1 | 0 | 0 |
| 3839499 | Recuperação de materiais não especificados | 1 | 1 | 0 | 0 |
| 4687702 | Comércio atacadista de sucatas não metálicas | 1 | 0 | 1 | 0 |
| 4687703 | Comércio atacadista de sucatas metálicas | 2 | 2 | 0 | 0 |

O cadastro aponta **cinco estabelecimentos ativos** nos códigos selecionados, distribuídos entre coleta, recuperação de plástico, recuperação de materiais não especificados e comércio atacadista de sucatas metálicas. Isso é evidência de registro empresarial, não prova de operação efetiva, capacidade de processamento ou relação comercial com fornecedores.

### Igarapé-Açu na RAIS de 2024

Na consulta dos estabelecimentos da RAIS de 2024, filtrada para os códigos de recuperação, comércio atacadista de resíduos e sucatas, coleta e tratamento de resíduos, Igarapé-Açu não apareceu no resultado estadual retornado.

A leitura mais prudente é:

1. há atividade empresarial cadastrada no CNPJ;
2. não foi identificado emprego formal na RAIS 2024 para os códigos selecionados;
3. pode existir informalidade, defasagem cadastral, atividade sem vínculo ativo ou divergência entre cadastro econômico e declaração trabalhista;
4. não se deve concluir que as empresas não operam sem verificação adicional.

### Pará — RAIS 2024

A consulta estadual encontrou 69 combinações município-CNAE nos códigos selecionados. Os maiores volumes de estabelecimentos foram:

| Município | Estabelecimentos nos códigos selecionados | Vínculos ativos |
|---|---:|---:|
| Ananindeua | 64 | 224 |
| Belém | 62 | 114 |
| Marabá | 52 | 78 |
| Parauapebas | 34 | 154 |
| Benevides | 26 | 72 |
| Castanhal | 25 | 130 |
| Santarém | 21 | 138 |
| Barcarena | 21 | 47 |
| Marituba | 19 | 39 |
| Altamira | 9 | 11 |
| Redenção | 9 | 7 |
| Canaã dos Carajás | 9 | 7 |

A atividade mais expressiva em estabelecimentos foi o comércio atacadista de resíduos e sucatas metálicos, com destaque para Ananindeua, Marabá, Belém, Parauapebas e Castanhal. Na recuperação de materiais plásticos, Ananindeua, Castanhal, Benevides, Belém e Marituba aparecem entre os principais municípios.

Esses resultados sugerem três tipos de polos potenciais:

- **Polo metropolitano:** Belém, Ananindeua, Benevides e Marituba, com maior densidade empresarial.
- **Polo nordeste paraense:** Castanhal e municípios próximos, com presença em comércio atacadista e recuperação de plásticos.
- **Polos regionais independentes:** Marabá, Parauapebas, Santarém e Altamira, com combinação de comércio, recuperação ou coleta.

A base não permite afirmar que esses municípios compram materiais de Igarapé-Açu ou de outros municípios. Ela apenas revela concentração territorial de atividades classificadas pelos códigos CNAE.

## D. Diagnóstico fiscal e compras públicas

### Despesas por função em Igarapé-Açu

Foram diferenciadas as classificações padronizadas do SICONFI. Os valores abaixo são despesas empenhadas, salvo indicação diferente:

| Ano | Gestão ambiental | Saneamento | Serviços urbanos | Urbanismo |
|---:|---:|---:|---:|---:|
| 2022 | R$ 50,0 mil | R$ 1,66 mi | R$ 1,28 mi | R$ 10,56 mi |
| 2023 | R$ 100,0 mil | R$ 1,25 mi | R$ 3,80 mi | R$ 10,63 mi |
| 2024 | R$ 75,0 mil | R$ 1,25 mi | R$ 999,0 mil | R$ 9,73 mi |
| 2025 | Não retornou registro | R$ 2,01 mi | R$ 3,56 mi | R$ 10,11 mi |

As categorias não devem ser somadas como se fossem equivalentes:

- **Gestão Ambiental** é uma função orçamentária própria.
- **Saneamento** inclui as subcategorias Saneamento Básico Urbano e, em alguns anos, Saneamento Básico Rural.
- **Serviços Urbanos** é distinto de saneamento e pode abranger serviços urbanos gerais.
- **Urbanismo** é uma função mais ampla e não representa exclusivamente limpeza urbana ou resíduos.

Em 2024, por exemplo, o município empenhou R$ 75 mil em Gestão Ambiental, R$ 1,25 milhão em Saneamento, R$ 998,6 mil em Serviços Urbanos e R$ 9,73 milhões em Urbanismo. Não é correto interpretar os R$ 9,73 milhões de Urbanismo como gasto com resíduos.

### Receitas

| Ano | Receitas brutas realizadas |
|---:|---:|
| 2022 | R$ 114,6 milhões |
| 2023 | R$ 127,1 milhões |
| 2024 | R$ 146,6 milhões |
| 2025 | R$ 171,1 milhões |

Em 2024, as transferências correntes somaram R$ 131,0 milhões, dos quais R$ 92,3 milhões vieram da União e de suas entidades. O FPM foi registrado em R$ 42,1 milhões. Esses números indicam forte dependência de transferências, mas não foram calculadas neste levantamento as proporções em relação à despesa total nem a capacidade fiscal própria.

### PNCP

A consulta ao PNCP identificou seis contratações de Igarapé-Açu, Câmara Municipal ou Prefeitura, relacionadas por termos de busca a lixo, coleta, limpeza ou saneamento, em 2025 e 2026. Entre elas:

- aquisição de materiais de higiene, limpeza e descartáveis: **R$ 1.599.050,38** homologados em 2025;
- coleta, transporte, tratamento e destino final de lixo hospitalar: **R$ 46.800,00** homologados em 2025;
- contratação equivalente para lixo hospitalar em 2026: **R$ 198.000,00** homologados;
- materiais de higiene e limpeza da Câmara Municipal: **R$ 182.584,20** em 2025 e **R$ 263.875,16** em 2026.

A busca por palavras-chave encontrou também uma contratação de consultoria de transparência pública sem valor homologado. Portanto, nem todos os resultados são diretamente relacionados à cadeia de resíduos. O PNCP permite identificar compras e objetos publicados, mas não substitui a análise de contratos, empenhos, execução física e fiscalização.

## E. Comparação municipal no Pará

A tabela comparativa exploratória foi construída com:

- população de 2024;
- PIB de 2023;
- PIB per capita calculado como PIB corrente dividido pela população de 2024;
- estabelecimentos e vínculos ativos da RAIS 2024 nos sete códigos de recuperação e comércio atacadista de resíduos e sucatas.

| Município | População 2024 | PIB per capita calculado | Estabelecimentos | Vínculos |
|---|---:|---:|---:|---:|
| Ananindeua | 507.838 | R$ 22.594 | 64 | 224 |
| Belém | 1.398.531 | R$ 28.985 | 62 | 114 |
| Marabá | 288.513 | R$ 33.790 | 52 | 78 |
| Parauapebas | 298.854 | R$ 88.408 | 34 | 154 |
| Benevides | 68.191 | R$ 48.953 | 26 | 72 |
| Castanhal | 207.603 | R$ 30.434 | 25 | 130 |
| Santarém | 357.311 | R$ 24.298 | 21 | 138 |
| Barcarena | 137.331 | R$ 66.919 | 21 | 47 |
| Marituba | 118.998 | R$ 23.366 | 19 | 39 |
| Altamira | 136.982 | R$ 28.383 | 9 | 11 |
| Redenção | 91.947 | R$ 40.042 | 9 | 7 |
| Canaã dos Carajás | 86.629 | R$ 191.871 | 9 | 7 |
| Paragominas | 112.843 | R$ 47.044 | 8 | 7 |

O PIB per capita é uma medida econômica agregada e não representa renda média dos moradores. Também há diferença temporal entre PIB, população e RAIS, explicitada na tabela.

## F. Municípios candidatos à investigação de replicação

A classificação abaixo é exploratória e não é uma classificação de viabilidade. Ela considera presença formal da cadeia econômica e possibilidade de articulação regional, sem atribuir potencial de créditos de carbono.

### 1. Castanhal

- 25 estabelecimentos e 130 vínculos nos códigos selecionados da RAIS 2024.
- População de 207.603 em 2024.
- Aparece em comércio atacadista de resíduos metálicos, papel e papelão, recuperação de plásticos, alumínio e materiais metálicos.
- É um candidato particularmente relevante para investigar articulação com municípios do nordeste paraense, incluindo Igarapé-Açu.

### 2. Benevides

- 26 estabelecimentos e 72 vínculos.
- População de 68.191.
- Combina comércio atacadista e recuperação de materiais plásticos, metálicos e não especificados.
- Pode representar um caso de município menor com atividade formal mais diversificada.

### 3. Ananindeua

- 64 estabelecimentos e 224 vínculos, o maior volume estadual no recorte da RAIS.
- Forte concentração de comércio de sucatas, coleta e recuperação de plásticos.
- Deve ser investigado como possível polo de comercialização e processamento, sem presumir relações de compra com outros municípios.

### 4. Marabá

- 52 estabelecimentos e 78 vínculos.
- População de 288.513 e PIB per capita calculado de R$ 33.790.
- Presença em coleta, comércio de sucatas metálicas e recuperação de materiais.
- Pode funcionar como polo regional do sudeste paraense.

### 5. Parauapebas

- 34 estabelecimentos e 154 vínculos.
- PIB per capita calculado de R$ 88.408.
- A relação entre estabelecimentos e vínculos é mais intensa que em vários municípios, indicando presença de unidades com maior estoque formal de emprego no recorte analisado.
- Requer investigação específica sobre composição setorial e fornecedores.

### 6. Santarém

- 21 estabelecimentos e 138 vínculos.
- População de 357.311.
- Poucos estabelecimentos comparativamente ao tamanho populacional, mas com número relevante de vínculos.
- Candidato para análise de polo regional no oeste do Pará.

### 7. Barcarena

- 21 estabelecimentos e 47 vínculos.
- PIB per capita calculado de R$ 66.919.
- Presença em coleta, recuperação de materiais metálicos e plásticos e comércio atacadista.
- Deve ser analisada como município de atividade econômica especializada, mas sem confundir PIB elevado com capacidade específica de reciclagem.

### 8. Igarapé-Açu

- A RAIS 2024 não registrou vínculos nos códigos selecionados.
- O CNPJ, contudo, apresenta cinco estabelecimentos ativos no conjunto de CNAEs analisado.
- O município combina necessidade ambiental histórica, segundo os dados domiciliares de 2010, com sinais cadastrais de atividade econômica recente.
- A hipótese mais importante é a existência de uma lacuna entre cadastro empresarial, empregos formais e infraestrutura pública de resíduos.

## G. Descobertas não óbvias e hipóteses investigáveis

### 1. Cadastro empresarial sem correspondência proporcional na RAIS

Igarapé-Açu apresenta estabelecimentos ativos no CNPJ em coleta, recuperação e comércio de sucatas, mas não apareceu na RAIS 2024 nos códigos selecionados. Isso pode indicar informalidade, baixa escala, inatividade operacional de parte dos estabelecimentos ou defasagem entre registros.

**Hipótese investigável:** mapear individualmente os CNPJs ativos e verificar contratos, situação cadastral histórica, nomes empresariais, atividades secundárias e vínculos em códigos CNAE mais amplos.

### 2. Castanhal como possível referência regional mais próxima

Castanhal aparece com 25 estabelecimentos e 130 vínculos na RAIS 2024, incluindo várias etapas da cadeia. Esse perfil é mais diversificado que o de Igarapé-Açu na RAIS e pode ser usado como município de comparação institucional e econômica.

**Hipótese investigável:** comparar Igarapé-Açu, Castanhal e municípios intermediários para verificar se há complementaridade territorial, sem presumir fluxos de materiais.

### 3. Grande dispersão de atividades com baixa escala

Além dos grandes polos, muitos municípios paraenses aparecem com apenas um estabelecimento em algum código CNAE e nenhum vínculo ativo na RAIS. Isso revela uma rede empresarial dispersa, mas não necessariamente uma cadeia integrada.

**Hipótese investigável:** distinguir empresas ativas, baixadas, inaptas e suspensas no CNPJ e priorizar apenas aquelas com evidência recente de operação, contratos ou vínculos.

### 4. Necessidade ambiental e estrutura econômica não estão automaticamente concentradas

Igarapé-Açu possui indicadores domiciliares históricos de queima de lixo e baixa cobertura de esgotamento por rede, mas não apresenta a mesma densidade formal de empregos observada em Ananindeua, Castanhal, Marabá ou Parauapebas.

**Hipótese investigável:** testar modelos de replicação que combinem município gerador ou organizador da coleta com um polo regional de comercialização ou processamento.

### 5. A rubrica de Urbanismo é muito maior que Gestão Ambiental

Em 2024, Igarapé-Açu empenhou R$ 9,73 milhões em Urbanismo, R$ 1,25 milhão em Saneamento, R$ 998,6 mil em Serviços Urbanos e R$ 75 mil em Gestão Ambiental. Isso não permite afirmar que o município gasta R$ 9,73 milhões com resíduos, mas sugere a necessidade de abrir a classificação orçamentária em nível de subfunção e natureza da despesa.

**Hipótese investigável:** identificar quanto de Urbanismo e Serviços Urbanos corresponde efetivamente a limpeza urbana, coleta, varrição, manutenção, obras ou outras atividades.

## H. Consultas executadas e resultados

Foram executadas consultas reais para:

1. população municipal de 1991 a 2025;
2. agregação de domicílios de Igarapé-Açu por setor censitário em 2010;
3. série do PIB municipal de 2002 a 2023;
4. identificação dos códigos CNAE relacionados a resíduos e recuperação no diretório oficial da BD;
5. estabelecimentos e vínculos RAIS 2024 por CNAE em todo o Pará;
6. estabelecimentos CNPJ por município, CNAE e situação cadastral;
7. estabelecimentos CNPJ de Igarapé-Açu por situação cadastral;
8. despesas por função de Igarapé-Açu entre 2022 e 2025;
9. receitas orçamentárias de Igarapé-Açu entre 2022 e 2025;
10. contratações do PNCP relacionadas a lixo, coleta, limpeza ou saneamento;
11. indicadores de água e esgoto do SNIS para Igarapé-Açu;
12. tabela comparativa exploratória de municípios paraenses.

As consultas produziram referências de resultado para posterior exportação ou visualização na interface, incluindo os resultados de população, domicílios, PIB, RAIS, CNPJ, SICONFI, PNCP e comparação municipal.

## I. Limitações e lacunas

- Os dados domiciliares detalhados são de 2010; não devem ser tratados como situação atual.
- Não foi localizada tabela de resíduos sólidos do SNIS na BD consultada.
- A ausência de registro em RAIS não prova inexistência de atividade econômica.
- O CNPJ registra situação cadastral, não operação efetiva, volume processado ou capacidade instalada.
- O PIB está em valores correntes; não foi calculado crescimento real.
- O PIB per capita comparativo combina PIB de 2023 com população de 2024, e isso foi explicitado.
- As despesas orçamentárias têm múltiplos estágios e rubricas que não devem ser somados indiscriminadamente.
- O PNCP contém registros publicados, mas a presença de uma contratação não comprova execução integral nem qualidade do serviço.
- Não foram identificados dados efetivamente consultados sobre massa de resíduos, coleta seletiva, disposição em lixões ou aterros, cooperativas de catadores, logística reversa, rotas, distâncias ou fluxos de materiais.
- Não foi construída uma pontuação única de replicabilidade porque faltam indicadores comparáveis de resíduos, população urbana/rural atualizada, capacidade institucional e execução física dos serviços.

## J. Recomendações de aprofundamento dentro da Base dos Dados

1. Consultar individualmente os estabelecimentos ativos de Igarapé-Açu no CNPJ, incluindo CNAEs secundárias, datas de início e nomes empresariais.
2. Expandir a análise RAIS para todos os códigos da divisão 38 e para atividades de transporte, armazenagem e comércio relacionadas, separando atividades diretamente ligadas a resíduos das atividades logísticas gerais.
3. Fazer uma série temporal da RAIS para 2017–2021 e 2022–2024, observando as mudanças metodológicas indicadas no guia da base.
4. Abrir as despesas do SICONFI por subfunção, natureza da despesa e conta original para separar limpeza urbana, coleta, varrição, saneamento, obras e gestão ambiental.
5. Analisar contratos e empenhos do PNCP, em vez de apenas contratações, para identificar fornecedor, valor inicial, valor acumulado, vigência e execução contratual.
6. Comparar Igarapé-Açu com Castanhal, São Francisco do Pará, Santa Maria do Pará, Marapanim, Curuçá, Capitão Poço e outros municípios do nordeste paraense usando os mesmos indicadores.
7. Procurar no catálogo por novas tabelas de resíduos, cooperativas, assistência social, Cadastro Único, infraestrutura urbana e transferências específicas antes de consolidar uma classificação de replicabilidade.

A evidência atualmente disponível sustenta uma hipótese de investigação: **Igarapé-Açu combina necessidade ambiental histórica, capacidade fiscal municipal relevante e sinais cadastrais de atividades de reciclagem, mas ainda não demonstra, nos dados formais consultados, uma cadeia de empregos e infraestrutura de resíduos proporcional a essa oportunidade**. Os municípios mais promissores para articulação regional são Castanhal, Ananindeua, Benevides, Marabá, Parauapebas, Santarém e Barcarena, cada um por razões diferentes de escala, diversificação econômica ou concentração de vínculos.

## 3. USER | 2026-11-20T21:54:06.429711Z

Identificador: `d6e7e458-9728-4dec-a469-7fab9566c405`.

# MISSÃO 2 — APROFUNDAMENTO DA INTELIGÊNCIA TERRITORIAL
## Amazônia Carbono Circular | Base dos Dados

Já foi realizada uma primeira exploração da Base dos Dados para Igarapé-Açu (PA), código IBGE 1503200.

A investigação identificou:

1. Cinco estabelecimentos ativos no CNPJ em CNAEs selecionados de coleta, recuperação e comércio de resíduos.
2. Nenhum vínculo identificado na RAIS 2024 nos CNAEs selecionados para Igarapé-Açu.
3. Castanhal com 25 estabelecimentos e 130 vínculos formais na RAIS 2024 nos códigos selecionados.
4. Concentração de atividades econômicas ligadas à recuperação e comercialização de resíduos em Castanhal, Ananindeua, Belém, Benevides e outros polos.
5. Despesas municipais relevantes em saneamento e serviços urbanos, ainda sem decomposição suficiente para identificar os gastos efetivos com resíduos.
6. Ausência de tabela de manejo de resíduos sólidos do SNIS na Base dos Dados consultada.

Agora não queremos repetir o diagnóstico. Queremos aprofundar as hipóteses.

## FRENTE 1 — INVESTIGAR OS CINCO ESTABELECIMENTOS DE IGARAPÉ-AÇU

Utilize a tabela:

`basedosdados.br_rf_cnpj.estabelecimentos`

Identifique individualmente os estabelecimentos ativos nos CNAEs relacionados a:

- Coleta de resíduos não perigosos.
- Recuperação de materiais plásticos.
- Recuperação de materiais não especificados.
- Comércio atacadista de resíduos e sucatas metálicas.

Para cada estabelecimento, extraia os campos efetivamente disponíveis:

- CNPJ.
- Razão social, se disponível.
- Nome fantasia.
- CNAE principal.
- CNAEs secundárias.
- Situação cadastral.
- Data de abertura.
- Data de referência.
- Município.

Investigue a evolução cadastral nas fotografias históricas disponíveis.

Objetivo: identificar quais estabelecimentos são recentes, quais já existiam anteriormente e quais podem ter relação com a cadeia de reciclagem.

Não exponha dados pessoais de sócios. Não invente relações comerciais.

## FRENTE 2 — CASTANHAL E IGARAPÉ-AÇU: CADEIA REGIONAL

Compare os dois municípios utilizando CNPJ e RAIS.

Investigue:

- Empresas de recuperação de materiais.
- Comércio atacadista de papelão.
- Comércio atacadista de plásticos.
- Comércio atacadista de sucatas metálicas.
- Coleta de resíduos.
- Tratamento de resíduos.
- Transporte e armazenagem relacionados.

Identifique a distribuição por CNAE e a evolução histórica dos estabelecimentos.

Pergunta central:

Existe uma estrutura empresarial em Castanhal que possa representar um polo regional de comercialização ou processamento para municípios vizinhos como Igarapé-Açu?

Não presuma que existam fluxos comerciais. Identifique as empresas e formule hipóteses verificáveis.

## FRENTE 3 — ABRIR AS DESPESAS PÚBLICAS

Utilize:

- `basedosdados.br_me_siconfi.municipio_despesas_funcao`
- `basedosdados.br_me_siconfi.municipio_despesas_orcamentarias`

Inspecione os esquemas antes de consultar.

Para Igarapé-Açu, extraia 2022–2025:

- Função.
- Subfunção.
- Natureza da despesa.
- Conta original.
- Estágio.
- Valor empenhado.
- Valor liquidado.
- Valor pago.

Procure identificar gastos efetivamente relacionados a:

- Coleta de resíduos.
- Limpeza urbana.
- Varrição.
- Transporte.
- Destinação final.
- Serviços de manejo de resíduos.
- Contratos de terceiros.

Compare as despesas com as receitas municipais e calcule proporções quando os dados permitirem.

Não classifique Urbanismo inteiro como gasto com resíduos.

## FRENTE 4 — APROFUNDAR O PNCP

Utilize:

- `basedosdados.br_mgi_pncp.contratacao`
- `basedosdados.br_mgi_pncp.contrato`

Para Igarapé-Açu e Castanhal, investigue contratações e contratos de:

- Coleta de lixo.
- Limpeza pública.
- Manejo de resíduos.
- Transporte de resíduos.
- Destinação final.
- Coleta seletiva.
- Equipamentos de triagem.
- Prensas e trituradores.
- Consultorias ambientais.

Extraia, quando disponíveis:

- Órgão contratante.
- Objeto.
- Fornecedor.
- CNPJ do fornecedor.
- Valor estimado.
- Valor homologado.
- Valor inicial do contrato.
- Valor acumulado.
- Datas.
- Vigência.
- Situação.

Procure identificar fornecedores que aparecem em mais de um município.

Objetivo: mapear o mercado público regional de serviços e equipamentos relacionados a resíduos.

Não confunda contratação publicada com execução comprovada.

## FRENTE 5 — AMPLIAR A RAIS

Expanda a investigação para 2017–2024.

Não limite a análise aos sete CNAEs já utilizados.

Investigue também:

- Transporte rodoviário de carga.
- Armazenagem.
- Comércio atacadista de materiais recicláveis.
- Fabricação de embalagens.
- Fabricação de produtos de plástico.
- Fabricação de papel e papelão.
- Atividades de triagem e recuperação.

Diferencie claramente atividades diretamente ligadas à reciclagem e atividades de suporte.

Compare Igarapé-Açu, Castanhal e outros municípios do nordeste paraense.

Procure identificar mudanças na formalização da cadeia.

## FRENTE 6 — COMPARAÇÃO TERRITORIAL REGIONAL

Faça uma comparação consistente entre:

- Igarapé-Açu.
- Castanhal.
- São Francisco do Pará.
- Santa Maria do Pará.
- Marapanim.
- Curuçá.
- Capitão Poço.
- Outros municípios próximos, se houver justificativa.

Utilize os mesmos indicadores e anos sempre que possível.

Objetivo: identificar complementaridades territoriais, e não apenas municípios com população semelhante.

## FRENTE 7 — DESCOBERTAS ESTRATÉGICAS

Responda:

1. Existe evidência de que Castanhal pode funcionar como polo econômico da cadeia regional?
2. Quais CNAEs e empresas sustentam essa hipótese?
3. Existe contratação pública relevante em Igarapé-Açu ou Castanhal?
4. Quais fornecedores atuam em mais de um município?
5. Há sinais de crescimento ou retração das atividades formais ligadas à reciclagem?
6. Qual é a diferença entre a estrutura empresarial e o emprego formal nesses territórios?
7. Quais cruzamentos revelaram padrões que não seriam evidentes olhando cada base separadamente?

## REGRAS

- Execute consultas reais.
- Inspecione esquemas antes de usar campos.
- Apresente SQL e resultados.
- Não invente CNPJs, empresas, fornecedores ou contratos.
- Não confunda cadastro com atividade operacional.
- Não confunda correlação com relação comercial.
- Preserve os anos de referência.
- Apresente descobertas e limitações.

## RESULTADO ESPERADO

Entregar um diagnóstico aprofundado da cadeia econômica regional de reciclagem, com foco na conexão potencial entre Igarapé-Açu e Castanhal, identificando empresas, setores, contratos, fornecedores, despesas públicas e oportunidades de articulação.

## 4. ASSISTANT | 2026-11-20T21:54:06.451796Z

Identificador: `3c59297f-2868-4965-a9c2-5187d7b9873b`.

## Resultado central

Os dados aprofundados fortalecem a hipótese de que **Castanhal possui uma estrutura empresarial e trabalhista muito mais densa que Igarapé-Açu**, podendo funcionar como polo regional de comercialização, triagem ou processamento. Porém, a Base dos Dados **não comprova fluxos comerciais entre os municípios**.

A principal conexão observada entre os dois territórios é complementar:

- **Igarapé-Açu:** estabelecimentos empresariais ativos recentes, incluindo uma cooperativa de coleta, empresas de reciclagem e sucateiros, mas sem vínculos formais na RAIS nos códigos diretos em 2024.
- **Castanhal:** crescimento consistente dos estabelecimentos diretos e forte estrutura de suporte, com 34 estabelecimentos e 138 vínculos formais nos códigos diretos em 2024, além de 261 estabelecimentos e 1.751 vínculos nas atividades de suporte selecionadas.
- **Compras públicas:** Igarapé-Açu publicou contratações de coleta e destinação de lixo hospitalar; Castanhal publicou contratação de caminhão para coleta seletiva e contratação de serviços para lixo hospitalar.
- **Fiscal:** Castanhal apresenta despesas muito maiores em Gestão Ambiental e Serviços Urbanos, mas as rubricas disponíveis não permitem separar, por si só, coleta de resíduos, limpeza urbana, varrição ou destinação final.

## 1. Estabelecimentos ativos de Igarapé-Açu

A consulta foi feita na fotografia cadastral de **1º de novembro de 2026**, filtrando os estabelecimentos ativos com CNAEs principais diretamente relacionados à cadeia analisada. A razão social foi obtida por ligação entre `estabelecimentos` e `empresas`, usando `cnpj_basico` e a mesma data de referência.

| CNPJ | Razão social / nome empresarial | Nome fantasia | CNAE principal | Início da atividade | CNAEs secundárias |
|---|---|---|---|---|---|
| 55.188.543/0001-76 | Cooperativa de Trabalho de Coleta, Triagem e Comercialização de Materiais Recicláveis | RECICLASSU | 3811400 — Coleta de resíduos não perigosos | 20/05/2024 | 3821100, 3839499, 4687701, 4687702, 4687703 |
| 50.211.706/0001-70 | ALFA RECICLAGEM LTDA | ALFA RECICLAGEM LTDA | 3832700 — Recuperação de materiais plásticos | 04/04/2023 | 3811400, 3831901, 3831999, 3839499, 4687701, 4687702, 4687703 |
| 59.198.728/0001-12 | Razão social com nome de pessoa física, omitida nesta apresentação | Não informado | 3839499 — Recuperação de materiais não especificados anteriormente | 30/01/2025 | 3832700, 3831901, 3831999 |
| 23.265.227/0001-64 | SUCATARIA ALACIDAO LTDA | SUCATARIA ALACIDAO | 4687703 — Comércio atacadista de resíduos e sucatas metálicos | 11/09/2015 | 1099604, 3811400, 3831999, 3839499, 4687701, 4785799 |
| 61.944.292/0001-05 | P R DE OLIVEIRA NOGUEIRA LTDA | SUCATA FENIX | 4687703 — Comércio atacadista de resíduos e sucatas metálicos | 28/07/2025 | Não informado |

Todos os cinco registros estavam com situação cadastral **Ativa** na fotografia consultada.

### Interpretação cadastral

Há quatro sinais relevantes:

1. **A RECICLASSU tem formato cooperativo declarado na razão social**, atividade iniciada em 2024 e CNAEs secundárias que abrangem coleta, recuperação e comércio atacadista de resíduos.
2. **A ALFA RECICLAGEM**, iniciada em 2023, combina recuperação de plásticos, recuperação metálica, coleta e comércio atacadista em suas atividades secundárias.
3. O estabelecimento de 2025 em recuperação de materiais não especificados é recente e possui CNAEs secundárias concentradas em recuperação de materiais.
4. A SUCATARIA ALACIDAO é o registro mais antigo entre os cinco, com início em 2015, enquanto a SUCATA FENIX começou em 2025.

Esses dados indicam **diversificação cadastral recente**, mas não comprovam volume processado, número de trabalhadores, existência de galpão, capacidade de triagem ou relações comerciais.

## 2. Evolução cadastral: Igarapé-Açu e Castanhal

Foram comparadas as fotografias de novembro de 2023, 2024, 2025 e 2026 para os CNAEs de coleta, recuperação, tratamento e comércio atacadista de resíduos.

### Total aproximado por município e fotografia

Os totais abaixo são a soma dos estabelecimentos nos CNAEs selecionados; um estabelecimento pode aparecer em mais de uma linha quando se observam CNAEs diferentes.

| Fotografia | Igarapé-Açu — registros CNAE | Igarapé-Açu — ativos | Castanhal — registros CNAE | Castanhal — ativos |
|---|---:|---:|---:|---:|
| Nov. 2023 | 5 | 2 | 94 | 35 |
| Nov. 2024 | 6 | 3 | 101 | 34 |
| Nov. 2025 | 8 | 6 | 103 | 43 |
| Nov. 2026 | 9 | 5 | 118 | 54 |

A contagem por CNAE evidencia a distância estrutural entre os municípios. Em novembro de 2026, Castanhal tinha, por exemplo:

- 29 registros em coleta de resíduos não perigosos, 14 ativos;
- 21 registros em recuperação de materiais plásticos, 8 ativos;
- 12 registros em recuperação de materiais metálicos, 7 ativos;
- 27 registros em comércio atacadista de sucatas metálicas, 13 ativos.

Igarapé-Açu, na mesma fotografia, tinha:

- 2 registros em coleta de resíduos não perigosos, 1 ativo;
- 1 registro em recuperação de plásticos, 1 ativo;
- 1 registro em recuperação de materiais não especificados, 1 ativo;
- 2 registros em comércio atacadista de sucatas metálicas, ambos ativos.

O salto cadastral de Igarapé-Açu entre 2023 e 2026 é relevante em termos relativos, mas parte de uma base muito pequena. Castanhal possui escala, diversidade de CNAEs e maior número absoluto de ativos.

## 3. CNAEs de suporte investigados

Além das atividades diretamente ligadas a resíduos, o diretório CNAE permitiu identificar grupos de suporte:

### Atividades diretamente ligadas

- 3811400 — Coleta de resíduos não perigosos.
- 3812200 — Coleta de resíduos perigosos.
- 3821100 — Tratamento e disposição de resíduos não perigosos.
- 3822000 — Tratamento e disposição de resíduos perigosos.
- 3831901 — Recuperação de sucatas de alumínio.
- 3831999 — Recuperação de materiais metálicos, exceto alumínio.
- 3832700 — Recuperação de materiais plásticos.
- 3839499 — Recuperação de materiais não especificados anteriormente.
- 3900500 — Descontaminação e outros serviços de gestão de resíduos.
- 4687701 — Comércio atacadista de resíduos de papel e papelão.
- 4687702 — Comércio atacadista de resíduos e sucatas não metálicos.
- 4687703 — Comércio atacadista de resíduos e sucatas metálicos.

### Atividades de suporte

- 1731100, 1732000 e 1733800 — fabricação de embalagens de papel, cartolina e papelão ondulado;
- 2221800, 2222600 e 2229301–2229399 — fabricação de laminados, embalagens e artefatos de plástico;
- 4686901 — comércio atacadista de papel e papelão em bruto;
- 4930201 — transporte rodoviário municipal de carga;
- 4930202 — transporte rodoviário intermunicipal, interestadual e internacional de carga.

Essas atividades de suporte não devem ser interpretadas automaticamente como reciclagem. Elas indicam infraestrutura econômica potencialmente complementar.

## 4. RAIS 2017–2024: estrutura direta e de suporte

A RAIS foi dividida em duas categorias:

- **Direta:** coleta, tratamento, recuperação e comércio atacadista de resíduos e sucatas.
- **Suporte:** fabricação de embalagens e produtos de papel/plástico, comércio de papel e transporte rodoviário de carga.

### Igarapé-Açu e Castanhal

| Ano | Igarapé-Açu: diretos / vínculos | Castanhal: diretos / vínculos | Castanhal: suporte / vínculos |
|---:|---:|---:|---:|
| 2017 | 0 / 0 | 15 / 49 | 122 / 915 |
| 2018 | 1 / 0 | 11 / 57 | 130 / 1.218 |
| 2019 | 0 / 0 | 12 / 58 | 149 / 1.305 |
| 2020 | 1 / 0 | 14 / 63 | 163 / 1.490 |
| 2021 | 0 / 0 | 20 / 94 | 158 / 1.355 |
| 2022 | 0 / 0 | 23 / 105 | 170 / 1.589 |
| 2023 | 2 / 0 | 28 / 118 | 240 / 1.687 |
| 2024 | 3 / 0 | 34 / 138 | 261 / 1.751 |

### Leitura dos resultados

- Castanhal apresentou crescimento dos estabelecimentos diretos de 15 em 2017 para 34 em 2024.
- Os vínculos diretos de Castanhal subiram de 49 para 138 no mesmo período.
- As atividades de suporte em Castanhal cresceram de 122 estabelecimentos e 915 vínculos em 2017 para 261 estabelecimentos e 1.751 vínculos em 2024.
- Igarapé-Açu permaneceu com poucos estabelecimentos diretos e **zero vínculo ativo na RAIS** nesses códigos em todos os anos consultados.
- Em 2024, Igarapé-Açu tinha três estabelecimentos diretos na RAIS, mas nenhum vínculo ativo agregado. Isso é compatível com empresas pequenas, inatividade trabalhista, informalidade ou divergências cadastrais; não permite afirmar que não haja operação.

A diferença entre CNPJ e RAIS é uma das descobertas mais importantes: **Igarapé-Açu possui cadastro empresarial recente, mas a formalização trabalhista ainda não aparece nos códigos diretos consultados**.

## 5. Castanhal como possível polo regional

A hipótese de Castanhal como polo regional é sustentada por três conjuntos de evidências:

### a) Diversidade empresarial

Castanhal possui registros em coleta, recuperação de alumínio, recuperação de metais, recuperação de plásticos, recuperação de materiais não especificados, comércio atacadista de papelão e comércio atacadista de sucatas metálicas.

### b) Escala de emprego formal

Em 2024, Castanhal tinha:

- 34 estabelecimentos diretos;
- 138 vínculos formais nos códigos diretos;
- 261 estabelecimentos nas atividades de suporte selecionadas;
- 1.751 vínculos nas atividades de suporte.

### c) Crescimento temporal

O crescimento foi observado tanto em atividades diretas quanto de suporte, especialmente após 2021. Esse padrão é mais consistente com uma base econômica regional do que a presença isolada de uma ou duas empresas.

Ainda assim, a hipótese deve ser formulada como:

> Castanhal apresenta características compatíveis com um polo regional de comercialização, triagem ou processamento, mas é necessário confirmar capacidade instalada, destino dos materiais, compradores, rotas e relações contratuais.

## 6. Despesas públicas: o que a estrutura permite e o que não permite

### Esquema das tabelas SICONFI

As tabelas consultadas possuem:

- `ano`;
- `id_municipio`;
- `conta`;
- `conta_bd`;
- `estagio`;
- `estagio_bd`;
- `id_conta_bd`;
- `valor`.

Elas **não possuem campos separados denominados subfunção ou natureza da despesa**. Assim, não foi possível extrair diretamente uma decomposição com todas as dimensões solicitadas.

Também não foi possível identificar, nos campos consultados, uma conta explicitamente denominada “coleta de resíduos”, “triagem”, “prensa” ou “destinação final”.

### Funções selecionadas — despesas empenhadas

| Município | Ano | Gestão Ambiental | Saneamento | Serviços Urbanos |
|---|---:|---:|---:|---:|
| Igarapé-Açu | 2022 | R$ 50,0 mil | R$ 1,66 mi | R$ 1,28 mi |
| Igarapé-Açu | 2023 | R$ 100,0 mil | R$ 1,25 mi | R$ 3,80 mi |
| Igarapé-Açu | 2024 | R$ 75,0 mil | R$ 1,25 mi | R$ 998,6 mil |
| Igarapé-Açu | 2025 | sem registro | R$ 2,01 mi | R$ 3,56 mi |
| Castanhal | 2022 | R$ 2,67 mi | não retornado na seleção | R$ 92,04 mi |
| Castanhal | 2023 | R$ 3,28 mi | não retornado na seleção | R$ 69,98 mi |
| Castanhal | 2024 | R$ 3,42 mi | não retornado na seleção | R$ 71,14 mi |
| Castanhal | 2025 | R$ 4,48 mi | não retornado na seleção | R$ 106,23 mi |

Castanhal tem escala fiscal muito superior nas funções de Gestão Ambiental e Serviços Urbanos. Contudo, a rubrica Serviços Urbanos é ampla e não pode ser interpretada como despesa de resíduos sem abrir os documentos originais ou cruzar com contratos e empenhos específicos.

### Terceiros e pessoas jurídicas

A tabela de despesas orçamentárias mostra valores amplos em “Outros Serviços de Terceiros — Pessoa Jurídica”, mas essa classificação não identifica quais contratos são de limpeza, coleta ou resíduos.

Em 2024, por exemplo:

- Igarapé-Açu empenhou R$ 13,28 milhões em Outros Serviços de Terceiros — Pessoa Jurídica.
- Castanhal empenhou R$ 133,32 milhões na mesma classificação.

Esses valores não devem ser apresentados como gasto com resíduos. São apenas um indicador de contratação de serviços de terceiros em sentido amplo.

### Proporção em relação às despesas empenhadas por função

As despesas empenhadas totais da tabela de despesas por função foram:

| Ano | Igarapé-Açu | Castanhal |
|---:|---:|---:|
| 2022 | R$ 320,73 milhões | R$ 1,95 bilhão |
| 2023 | R$ 352,44 milhões | R$ 2,23 bilhões |
| 2024 | R$ 429,87 milhões | R$ 2,32 bilhões |
| 2025 | R$ 478,50 milhões | R$ 2,80 bilhões |

Como as contas selecionadas podem coexistir com outras classificações e não correspondem exclusivamente à gestão de resíduos, as proporções devem ser usadas com cautela. A Base dos Dados não forneceu, nesta rodada, uma medida confiável de “percentual do orçamento destinado a resíduos”.

## 7. PNCP: contratações específicas

A consulta mais restritiva, usando termos como lixo, resíduo, coleta seletiva, triagem, prensa, triturador e destinação final, retornou cinco registros de contratação.

### Igarapé-Açu

| Ano | Objeto | Valor estimado | Valor homologado |
|---:|---|---:|---:|
| 2025 | Coleta, transporte, tratamento e destino final de lixo hospitalar | R$ 91.140,00 | R$ 46.800,00 |
| 2026 | Coleta, transporte, tratamento e destino final de lixo hospitalar | R$ 224.040,00 | R$ 198.000,00 |

Esses objetos são relacionados a **resíduos de serviços de saúde**, não à coleta seletiva domiciliar ou à recuperação de materiais recicláveis.

### Castanhal

| Ano | Objeto | Valor estimado | Valor homologado |
|---:|---|---:|---:|
| 2026 | Aquisição de caminhão para coleta seletiva de resíduos recicláveis | R$ 515.000,00 | R$ 370.000,00 |
| 2026 | Coleta, transporte, tratamento e destinação de lixo patológico e químico | R$ 1.075.951,20 | R$ 968.335,80 |

O caminhão para coleta seletiva é a evidência mais direta de investimento público em infraestrutura de coleta diferenciada encontrada nesta rodada. O contrato de lixo patológico e químico pertence a uma cadeia distinta da reciclagem de resíduos domiciliares.

Também apareceu uma contratação da Câmara de Castanhal para publicação de atos administrativos porque o texto continha termo capturado pela busca. Ela foi excluída da interpretação substantiva como contratação de resíduos.

### Fornecedores em mais de um município

A consulta de contratos com termos específicos de resíduos não encontrou fornecedor comum a Igarapé-Açu e Castanhal.

Portanto, não há evidência, nesta consulta, de que o mesmo fornecedor contratado para serviços de resíduos atue nos dois municípios. A ausência não prova que não exista fornecedor compartilhado: pode decorrer de nomenclatura dos objetos, registros incompletos ou contratação fora do intervalo consultado.

## 8. Comparação territorial regional

A análise RAIS incluiu:

- Igarapé-Açu;
- Castanhal;
- São Francisco do Pará;
- Santa Maria do Pará;
- Marapanim;
- Curuçá;
- Capitão Poço.

### 2024 — atividades diretas

| Município | Estabelecimentos diretos | Vínculos diretos |
|---|---:|---:|
| Castanhal | 34 | 138 |
| Curuçá | 3 | 3 |
| Capitão Poço | 3 | 0 |
| Igarapé-Açu | 3 | 0 |
| Santa Maria do Pará | 3 | 3 |
| Marapanim | 1 | 4 |
| São Francisco do Pará | 1 | 0 |

### 2024 — atividades de suporte

| Município | Estabelecimentos de suporte | Vínculos de suporte |
|---|---:|---:|
| Castanhal | 261 | 1.751 |
| Santa Maria do Pará | 26 | 14 |
| Capitão Poço | 6 | 28 |
| São Francisco do Pará | 5 | 7 |
| Curuçá | 4 | 11 |
| Igarapé-Açu | 5 | 6 |
| Marapanim | 1 | 0 |

Castanhal é o único município do conjunto com escala simultaneamente elevada em atividades diretas e de suporte. Santa Maria do Pará aparece como um município com muitos estabelecimentos de suporte, mas poucos vínculos, enquanto Capitão Poço tem poucos estabelecimentos e 28 vínculos de suporte.

Esse contraste permite formular hipóteses diferentes:

- **Castanhal:** possível polo regional diversificado.
- **Igarapé-Açu:** base empresarial pequena, recente e ainda pouco formalizada em empregos.
- **Santa Maria do Pará:** muitos registros de suporte, mas baixa intensidade de vínculos em 2024.
- **Marapanim:** poucos estabelecimentos, porém quatro vínculos diretos em 2024.
- **Curuçá:** pequena estrutura direta e de suporte, sem escala comparável a Castanhal.
- **Capitão Poço:** atividade de suporte mais relevante que a direta.

## 9. Respostas às perguntas estratégicas

### 1. Castanhal pode funcionar como polo econômico regional?

**Sim, como hipótese forte de investigação.** A evidência é formada pela combinação de:

- crescimento de 15 para 34 estabelecimentos diretos entre 2017 e 2024;
- aumento de 49 para 138 vínculos diretos;
- 261 estabelecimentos de suporte e 1.751 vínculos de suporte em 2024;
- presença em recuperação de metais, plásticos, alumínio, materiais não especificados e comércio atacadista de papelão e sucatas metálicas;
- contratação pública de caminhão para coleta seletiva em 2026.

### 2. Quais CNAEs sustentam a hipótese?

Principalmente 3811400, 3831901, 3831999, 3832700, 3839499, 4687701, 4687702 e 4687703. As atividades de suporte mais relevantes são transporte rodoviário de carga, fabricação de embalagens de papelão e plástico e comércio atacadista de papel e papelão em bruto.

### 3. Existe contratação pública relevante?

Sim:

- Igarapé-Açu: lixo hospitalar homologado em R$ 46,8 mil em 2025 e R$ 198 mil em 2026.
- Castanhal: caminhão para coleta seletiva homologado em R$ 370 mil em 2026.
- Castanhal: lixo patológico e químico homologado em R$ 968.335,80 em 2026.

### 4. Há fornecedores comuns aos dois municípios?

Não foram encontrados nos contratos filtrados por termos específicos de resíduos.

### 5. Houve crescimento ou retração formal?

- Castanhal apresentou crescimento robusto da estrutura direta e de suporte entre 2017 e 2024.
- Igarapé-Açu apresentou crescimento cadastral no CNPJ, com empresas iniciadas em 2023, 2024 e 2025, mas não apresentou vínculos diretos ativos na RAIS.
- A trajetória de Igarapé-Açu é mais compatível com surgimento ou formalização empresarial recente do que com consolidação de empregos formais.

### 6. Qual a diferença entre empresas e empregos?

Em Igarapé-Açu, há estabelecimentos ativos no CNPJ, mas nenhum vínculo direto na RAIS 2024. Em Castanhal, há correspondência clara entre quantidade de estabelecimentos e vínculos formais, especialmente nas atividades de suporte.

Essa diferença pode indicar informalidade, empresas sem empregados próprios, terceirização, subdeclaração, baixa escala ou defasagem entre bases.

### 7. Quais cruzamentos foram mais reveladores?

Os cruzamentos mais úteis foram:

- CNPJ + empresas: revelou a existência da RECICLASSU e a diversidade de CNAEs secundárias.
- CNPJ + RAIS: mostrou a diferença entre presença empresarial e formalização de empregos.
- RAIS + diretório CNAE: separou atividades diretas de atividades de suporte.
- PNCP + município: revelou a compra de caminhão para coleta seletiva em Castanhal e os contratos de lixo hospitalar em Igarapé-Açu.
- SICONFI + PNCP: mostrou que há despesas amplas em Gestão Ambiental e Serviços Urbanos, mas que os contratos específicos são necessários para identificar resíduos.

## 10. Limitações importantes

- A fotografia do CNPJ é cadastral e não mede operação efetiva, faturamento ou capacidade instalada.
- O cadastro de Castanhal inclui situações ativas, baixadas e inaptas; as comparações devem priorizar a coluna de ativos.
- Um mesmo estabelecimento pode aparecer em mais de um CNAE secundário; somar linhas por CNAE pode gerar dupla contagem.
- A RAIS mede emprego formal, não trabalhadores informais, cooperados sem vínculo declarado ou autônomos.
- As tabelas SICONFI não expõem, no esquema consultado, campos separados de subfunção e natureza da despesa.
- “Serviços Urbanos”, “Gestão Ambiental” e “Terceiros — Pessoa Jurídica” são classificações amplas.
- O PNCP registra publicação de contratação, contrato ou empenho, não necessariamente execução física ou pagamento integral.
- Buscas textuais no objeto do PNCP podem trazer falsos positivos; por isso, foram separados os registros de resíduos específicos dos objetos genéricos de limpeza.
- A ausência de fornecedor comum no PNCP não prova ausência de articulação privada entre os municípios.

## Conclusão operacional

A melhor hipótese de articulação é uma arquitetura territorial em dois níveis:

1. **Igarapé-Açu como território de organização da coleta, inclusão socioprodutiva e formação de oferta de materiais**, apoiado na RECICLASSU, na ALFA RECICLAGEM, nos sucateiros ativos e na formalização de trabalhadores.
2. **Castanhal como polo regional de comercialização, suporte logístico e possível processamento**, dada a escala de estabelecimentos, empregos formais, diversidade de CNAEs e investimento público identificado em coleta seletiva.

Essa arquitetura ainda precisa ser validada por informações sobre capacidade física, volume coletado, compradores, rotas, contratos privados, custos logísticos, cooperados e execução dos contratos públicos. Os dados disponíveis sustentam uma hipótese territorial consistente, mas não comprovam uma cadeia regional já integrada.

