# BD-002: conversa BD

Origem: https://basedosdados.org/chatbot?t=433024b2-d169-4637-889d-a75f45eedadc

Thread: `433024b2-d169-4637-889d-a75f45eedadc`. Mensagens: 6.

## 1. USER | 2026-11-18T17:47:49.859871Z

Identificador: `404d4419-d8b9-4335-8725-5061fce90e7b`.

Eaaaaaaaaaaai, beleza?? 

Além dos dados do PNCP, quais bases fazem parte do conjunto que vc tem acesso?

## 2. ASSISTANT | 2026-11-18T17:47:49.874713Z

Identificador: `c1b05903-e72b-4001-8ef4-89f4e24fbca7`.

Eaaaaaaaaai! Beleza 😄 Além do **PNCP**, o catálogo ao qual tenho acesso reúne bases brasileiras e algumas internacionais, organizadas por temas. Alguns exemplos importantes:

- **IBGE:** Censo, população, PIB municipal, IPCA, INPC, IPCA-15, POF, PNS e MUNIC.
- **Educação — Inep:** Censo Escolar, Enem, Ideb, Saeb, Censo da Educação Superior, indicadores educacionais e sinopses estatísticas.
- **Saúde — Ministério da Saúde/DATASUS:** CNES, SIH/SUS, SIA, SINASC, SISVAN, cobertura da Atenção Básica e Pesquisa Nacional de Saúde.
- **Trabalho e emprego — Ministério da Economia:** RAIS e CAGED.
- **Eleições — TSE:** eleitorado, candidaturas, resultados eleitorais e prestação de contas desde 1945.
- **Economia e finanças públicas:** indicadores de preços, atividade econômica, orçamento e outras estatísticas públicas — a disponibilidade exata depende da base e das tabelas catalogadas.
- **Território e geografia:** dados geográficos brasileiros, municípios, estados, regiões e diretórios de códigos institucionais.
- **Saúde suplementar:** beneficiários de planos de saúde, da ANS.
- **Dados produzidos por organizações da sociedade civil:** por exemplo, o IEPS Data, com indicadores de saúde e SUS.
- **Meio ambiente e clima:** bases da NOAA, como observações meteorológicas diárias e registros de tempestades.
- **Bases internacionais:** há também conjuntos sobre eleições e geografia de outros países, como Alemanha, Índia, Austrália, Japão e México.

Essa não é uma lista exaustiva: o catálogo tem conjuntos específicos dentro de cada órgão e tema. Posso consultar a base disponível para localizar um assunto, órgão ou indicador específico — por exemplo, “gastos municipais”, “mortalidade”, “emprego”, “educação” ou “eleições”.

## 3. USER | 2026-11-18T18:46:16.823030Z

Identificador: `64cb64ad-c326-4b36-93bc-9871ca56a975`.

Identifique relações potencialmente interessantes entre os datasets de contratações públicas, população e finanças municipais disponíveis. Não faça análises ainda. Primeiro, mapeie quais tabelas poderiam ser cruzadas, quais chaves de relacionamento existem e quais perguntas seriam possíveis.

## 4. ASSISTANT | 2026-11-18T18:46:16.855551Z

Identificador: `69bcd9bc-6259-4df7-b299-6de1c8418ba4`.

## Mapa inicial de cruzamentos possíveis

Há três eixos de ligação particularmente fortes:

1. **Município:** `id_municipio`, código IBGE de sete dígitos.
2. **Tempo:** `ano`.
3. **Identidade da contratação:** `id_contratacao_pncp`, para ligar contratações a contratos e empenhos dentro do PNCP.

A combinação principal seria:

```text
PNCP + População + SICONFI
id_municipio + ano
```

Isso permite construir indicadores municipais como contratações por habitante, contratos em relação à receita ou à despesa, e composição das compras públicas segundo o perfil fiscal do município.

* * *

## 1. Tabelas de contratações públicas

### PNCP — `contratacao`

**Unidade de observação:** uma linha por contratação — licitação, dispensa ou inexigibilidade.

**Campos úteis para cruzamentos:**

- `id_municipio`: município da unidade administrativa responsável;
- `sigla_uf`: unidade da federação;
- `ano`: ano de publicação no PNCP;
- `data_publicacao`, `ano_compra`;
- `id_contratacao_pncp`: identificador da contratação;
- `id_esfera`, `id_poder`, `id_modalidade`, `id_situacao_compra`;
- `valor_total_estimado` e `valor_total_homologado`;
- `indicador_emenda_parlamentar` e `indicador_srp`;
- `categoria` temática por meio do objeto textual e de variáveis associadas à contratação.

A tabela cobre registros publicados de **10 de agosto de 2021 a 23 de setembro de 2026** e é particionada por `ano`.

### PNCP — `contrato`

**Unidade de observação:** uma linha por contrato ou empenho. A coluna `id_tipo_contrato` distingue os dois.

**Campos úteis:**

- `id_municipio`, `sigla_uf`, `ano`;
- `id_contratacao_pncp`: ligação com a tabela `contratacao`;
- `id_contrato_pncp`: identificador do contrato ou empenho;
- `id_fornecedor`, `nome_fornecedor`, `tipo_pessoa_fornecedor`;
- `id_tipo_contrato`, `id_categoria_processo`;
- `data_assinatura`, `data_vigencia_inicio`, `data_vigencia_fim`;
- `valor_inicial`, `valor_global`, `valor_acumulado` e `valor_parcela`;
- `indicador_emenda_parlamentar`, `indicador_receita` e `indicador_fruto_adesao`.

A tabela cobre **6 de setembro de 2021 a 23 de setembro de 2026** e também é particionada por `ano`.

### Relação interna do PNCP

```text
contratacao.id_contratacao_pncp
        = contrato.id_contratacao_pncp
```

Esse cruzamento permite sair do registro da oportunidade ou procedimento de compra para os contratos e empenhos efetivamente registrados. É importante preservar a diferença de granularidade: uma contratação pode estar associada a mais de um contrato ou empenho.

Também há tabelas de **atas de registro de preços** e **instrumentos de cobrança**, que podem ser incorporadas em análises específicas. A relação esperada seria por `id_ata_pncp` ou pelo identificador do contrato, mas suas estruturas detalhadas ainda precisariam ser examinadas antes de um cruzamento.

* * *

## 2. População municipal

### IBGE — `populacao.municipio`

**Unidade de observação:** um município em um determinado ano.

**Campos:**

- `id_municipio`;
- `sigla_uf`;
- `ano`;
- `populacao`.

A tabela cobre **1991 a 2025**, é particionada por `ano`, `id_municipio` e `sigla_uf`, e constitui a dimensão populacional mais direta para normalizar os dados do PNCP e do SICONFI.

### Relação com o PNCP

```text
pncp.id_municipio = populacao.id_municipio
pncp.ano          = populacao.ano
```

O cruzamento temporal precisa ser interpretado com cuidado: no PNCP, `ano` é o ano de publicação do registro; na população, é o ano da estimativa com referência em 1º de julho. Para contratos com vigência plurianual, pode ser mais adequado relacionar o contrato ao ano de assinatura, ao ano de publicação ou a cada ano de vigência, conforme a pergunta.

* * *

## 3. Finanças municipais

### SICONFI — `municipio_receitas_orcamentarias`

**Unidade de observação:** município, ano, conta contábil e estágio da receita.

**Campos-chave e métricas:**

- `id_municipio`, `sigla_uf`, `ano`;
- `conta`, `conta_bd`, `id_conta_bd`;
- `estagio` e `estagio_bd`;
- `valor`.

Cobre **1989 a 2025**.

### SICONFI — `municipio_despesas_orcamentarias`

**Unidade de observação:** município, ano, conta contábil e estágio da despesa.

**Campos úteis:**

- `id_municipio`, `sigla_uf`, `ano`;
- `conta`, `conta_bd`, `id_conta_bd`;
- `estagio`, `estagio_bd`;
- `valor`.

Também cobre **1989 a 2025**.

### SICONFI — `municipio_despesas_funcao`

**Unidade de observação:** município, ano, função orçamentária e estágio da despesa.

É especialmente útil para comparar contratações com despesas em áreas como educação, saúde, urbanismo, transporte ou administração, desde que as contas e funções sejam agregadas sem duplicação.

Cobre **1996 a 2025**.

### SICONFI — `municipio_balanco_patrimonial`

**Unidade de observação:** município, ano e conta patrimonial.

Pode complementar a análise com indicadores de ativos, passivos e posição patrimonial, conforme as contas selecionadas. Cobre **1998 a 2025**.

### Relações com PNCP e população

Para todas essas tabelas, a chave territorial e temporal candidata é:

```text
siconfi.id_municipio = pncp.id_municipio
siconfi.ano          = pncp.ano

siconfi.id_municipio = populacao.id_municipio
siconfi.ano          = populacao.ano
```

A `sigla_uf` pode ser usada como chave de validação, mas não como substituta de `id_municipio`, pois ela identifica apenas a unidade da federação.

* * *

## 4. Finanças municipais especializadas: SIOPE

### SIOPE — `indicador_municipal`

Essa tabela traz indicadores municipais de educação calculados pelo FNDE a partir das declarações bimestrais do SIOPE.

**Campos úteis:**

- `id_municipio`, `sigla_uf`, `ano`;
- `bimestre`;
- `codigo_indicador` e `id_indicador`;
- `valor_percentual` e `valor_real`.

A tabela cobre **janeiro de 2021 a agosto de 2026**. Ela poderia ser cruzada com o PNCP para perguntas específicas sobre compras e contratos relacionados à educação, aplicação mínima em manutenção e desenvolvimento do ensino, FUNDEB e investimento por aluno.

O significado de `id_indicador` depende do dicionário próprio do SIOPE; portanto, antes de filtrar ou apresentar um indicador, será necessário consultar esse dicionário.

* * *

## Chaves e relações disponíveis

| Relação | Chave candidata | Uso |
|---|---|---|
| Contratação → contrato | `id_contratacao_pncp` | Identificar contratos e empenhos originados de uma contratação |
| PNCP → população | `id_municipio` + `ano` | Normalizar compras e contratos pela população |
| PNCP → SICONFI | `id_municipio` + `ano` | Comparar contratações com receitas, despesas e funções orçamentárias |
| PNCP → SIOPE | `id_municipio` + `ano` | Relacionar contratações a indicadores de financiamento da educação |
| SICONFI → população | `id_municipio` + `ano` | Calcular receitas, despesas e saldos por habitante |
| SIOPE → população | `id_municipio` + `ano` | Calcular indicadores educacionais ou valores por habitante |
| Todas as bases municipais → diretório geográfico | `id_municipio` | Recuperar nome do município e atributos territoriais |

Os campos `id_municipio` das tabelas examinadas apontam para o diretório de municípios da Base dos Dados, o que oferece uma forma padronizada de validar e enriquecer a identificação territorial.

* * *

## Perguntas que esses cruzamentos permitiriam investigar

### Escala e intensidade das contratações

- Quais municípios registram maior valor contratado por habitante?
- Como varia o número de contratações por mil habitantes?
- Municípios de população semelhante apresentam padrões muito diferentes de contratação?
- O valor contratado cresce proporcionalmente à população ou há diferenças relevantes entre municípios?

### Contratações e capacidade fiscal

- Qual é a relação entre o valor contratado e a receita orçamentária municipal?
- Municípios com maior despesa por habitante também apresentam maior volume de contratos no PNCP?
- Que parcela das despesas orçamentárias aparece associada a contratos e empenhos divulgados no PNCP?
- Municípios com baixa receita própria dependem mais de determinadas modalidades ou tipos de contratação?

### Composição do gasto público

- Quais funções orçamentárias concentram maior despesa nos municípios com maior volume de contratações?
- Municípios que gastam mais em saúde, educação ou urbanismo contratam proporcionalmente mais nessas áreas?
- Há diferenças na composição das compras entre municípios pequenos, médios e grandes?
- O perfil de contratação muda conforme a situação fiscal ou patrimonial do município?

### Modalidades, fornecedores e governança

- Municípios com diferentes níveis de receita utilizam modalidades de contratação distintas?
- Qual é a participação de dispensas, inexigibilidades, pregões e outras modalidades no conjunto de contratações?
- Municípios com maior concentração de contratos em poucos fornecedores apresentam perfil fiscal ou populacional diferente?
- O uso de atas de registro de preços é mais frequente em determinados portes municipais?
- Como se distribuem os contratos envolvendo emendas parlamentares por população, receita e despesa?

### Educação e financiamento

- Municípios com maior investimento educacional por aluno registram maior volume de contratações na área de educação?
- Como se relacionam contratos, aplicação em MDE e percentuais do FUNDEB?
- O padrão de contratação educacional difere entre municípios com diferentes níveis de população e receita?

### Dinâmica temporal

- Como mudou o volume de contratações municipais desde 2021?
- A entrada em vigor do novo regime de contratações coincide com mudanças no número ou no valor dos registros?
- Municípios com crescimento populacional apresentam crescimento proporcional das contratações?
- A evolução das contratações acompanha a evolução das receitas e despesas municipais?

* * *

## Cuidados metodológicos para uma etapa posterior

- O PNCP registra contratações, contratos e empenhos em tabelas com granularidades diferentes; somar tudo sem definir a unidade de análise pode gerar dupla contagem.
- `valor_total_estimado`, `valor_total_homologado`, `valor_global` e `valor_acumulado` não representam necessariamente a mesma etapa financeira.
- O PNCP abrange União, estados e municípios; será necessário restringir a análise à esfera municipal usando os campos apropriados e validar a presença de `id_municipio`.
- O ano do PNCP pode ser ano de publicação, enquanto no SICONFI é ano fiscal e na população é ano da estimativa; a escolha do alinhamento temporal deve ser explícita.
- As tabelas do SICONFI têm várias linhas por município e ano, por conta, estágio e função. Será necessário selecionar contas e estágios antes de calcular totais.
- Os dados de população chegam a 2025, enquanto as tabelas do PNCP e do SIOPE têm registros posteriores; um painel integrado completo provavelmente exigirá restringir o período a anos comuns ou tratar 2026 separadamente.
- Os valores monetários das diferentes fontes não devem ser comparados sem definir se a análise usará valores nominais ou algum procedimento de atualização monetária.

## 5. USER | 2026-11-18T19:11:55.020294Z

Identificador: `079471d2-2ad9-4f41-9faa-2b06cb37fea1`.

Identifique datasets brasileiros e internacionais que permitam estudar o mesmo fenômeno em diferentes países. Organize por tema, unidade de observação, período, escala geográfica, variáveis comparáveis e limitações de harmonização.

## 6. ASSISTANT | 2026-11-18T19:11:55.037671Z

Identificador: `4b4af68b-d5b2-4320-8796-511845d815ee`.

Abaixo estão os pares e famílias de datasets com melhor potencial para estudar o mesmo fenômeno no Brasil e em outros países. O foco é a **comparabilidade possível**, não uma análise dos resultados.

## Visão geral

| Tema | Brasil | Dataset internacional | Comparabilidade preliminar |
|---|---|---|---|
| Demografia | População Brasileira — IBGE | World Population Prospects — ONU | Alta para totais nacionais; moderada em idade, sexo e projeções |
| Eleições | Eleições Brasileiras — TSE | Eleições Nacionais — Harvard/NED; SAGE | Alta para resultados agregados; moderada para sistemas eleitorais e partidos |
| Mercado de trabalho | PNAD Contínua — IBGE | Labour Force — Austrália; QCEW/LAUS — EUA | Moderada, dependendo do conceito de emprego |
| Finanças públicas | SICONFI/Finbra — Ministério da Economia | Census of Governments — EUA | Moderada; exige harmonização institucional e contábil |
| Clima | BDMEP/INMET | GHCN-Daily — NOAA | Alta para variáveis meteorológicas; moderada por diferenças de estação e cobertura |
| Emissões de GEE | SEEG — Brasil | Inventário nacional da Austrália | Moderada a alta para totais por setor, desde que adotadas classificações comuns |
| População e condições sociais | PNAD-C, Atlas do Desenvolvimento Humano | World Population Prospects e indicadores internacionais | Moderada; as unidades e metodologias são diferentes |

* * *

# 1. Demografia e mudança populacional

## Brasil: População Brasileira — IBGE

**Unidade de observação:** município, unidade da federação ou Brasil por ano.

**Período:** 1991–2025 na tabela municipal consultada.

**Escala geográfica:** Brasil, estados e municípios.

**Variáveis comparáveis:**

- população total;
- população por ano;
- eventualmente população por sexo e idade em bases demográficas complementares;
- variação populacional e população como denominador para taxas.

## Internacional: World Population Prospects — ONU

**Unidade de observação:** país ou área, ano e, em algumas tabelas, grupo de idade e sexo.

**Período:** estimativas de 1950 a 2023 e projeções de 2024 a 2100; as tabelas por idade e sexo cobrem o mesmo horizonte.

**Escala geográfica:** 237 países e áreas.

**Variáveis comparáveis:**

- população total;
- população por idade e sexo;
- fecundidade;
- mortalidade;
- expectativa de vida;
- migração internacional.

### Perguntas comparáveis

- Como evoluiu a população do Brasil em comparação com outros países?
- Como diferem o envelhecimento populacional e a estrutura etária?
- A queda ou o aumento da fecundidade ocorre em períodos semelhantes?
- Quais países têm trajetórias semelhantes de população e expectativa de vida?

### Limitações de harmonização

- A base do IBGE oferece detalhamento subnacional brasileiro, enquanto o WPP é principalmente nacional.
- As estimativas do IBGE têm referência em 1º de julho; uma tabela do WPP por grupo de idade e sexo também usa 1º de julho, mas outras tabelas podem usar referência diferente.
- O WPP mistura estimativas históricas e projeções; a comparação com o Brasil deve separar esses dois componentes.
- Censos e estimativas intercensitárias podem produzir quebras de série diferentes entre países.

* * *

# 2. Eleições, participação e representação política

## Brasil: Eleições Brasileiras — TSE

**Unidades de observação disponíveis:** candidatura, candidato, partido, município, zona eleitoral, seção eleitoral, receita e despesa de campanha.

**Período:** eleições brasileiras desde 1945; algumas tabelas específicas têm cobertura própria, como pesquisas eleitorais desde 2012.

**Escala geográfica:** país, estado, município, zona e seção eleitoral.

**Variáveis comparáveis:**

- votos e percentual de votos;
- candidatos e partidos;
- cadeiras e vagas disputadas;
- comparecimento e abstenção;
- receitas e despesas de campanha;
- perfil do eleitorado;
- resultados por município ou seção.

## Internacional: Eleições Nacionais — Harvard/NED

**Unidade de observação:** eleição presidencial ou parlamentar, candidato, partido e resultado agregado.

**Período:** 1789–2023; 6.309 eleições em 212 países e territórios.

**Escala geográfica:** país, com foco em eleições nacionais.

**Variáveis comparáveis:**

- votos e percentuais para candidatos presidenciais;
- cadeiras e distribuição de cadeiras em eleições parlamentares;
- partidos participantes;
- tipo de eleição;
- eventos políticos associados ao pleito.

## Complemento: SAGE — Eleições Globais em Pequenas Áreas

**Unidade de observação:** retorno eleitoral em pequenas áreas, tipicamente seção ou unidade equivalente, candidato e partido.

**Período:** 1948–2026.

**Escala geográfica:** 110 países, no menor nível territorial publicado pelas autoridades eleitorais.

**Variáveis comparáveis:**

- votos;
- resultados por candidato e partido;
- localização da unidade eleitoral;
- identificadores harmonizados de partidos e candidatos.

### Perguntas comparáveis

- Como variam participação e abstenção entre países?
- A fragmentação partidária está associada a diferentes regras eleitorais?
- Como se distribui o apoio territorial a partidos e candidatos?
- A representação de mulheres e outros grupos varia entre sistemas eleitorais?
- A concentração de votos em poucos partidos é maior em eleições presidenciais ou parlamentares?

### Limitações de harmonização

- O TSE oferece grande detalhamento municipal e por seção, enquanto o dataset internacional de Harvard é predominantemente nacional.
- Presidencialismo, parlamentarismo, voto distrital, voto proporcional e sistemas mistos não são diretamente equivalentes.
- “Percentual de votos” pode ser calculado sobre votos válidos, votos totais, eleitores presentes ou outro denominador.
- Partidos mudam de nome, fazem fusões e participam de coligações; a identificação de uma mesma organização ao longo do tempo exige tratamento adicional.
- No Brasil, a coluna `ano` pode representar o ciclo eleitoral original, mesmo quando a votação ocorreu em outra data.
- Eleições suplementares e diferentes quantidades de vagas — especialmente no Senado — dificultam comparações simples.

* * *

# 3. Mercado de trabalho

## Brasil: PNAD Contínua — IBGE

**Unidade de observação:** pessoa, domicílio ou agregação estatística, conforme a tabela.

**Periodicidade:** mensal para um conjunto restrito de indicadores, trimestral para os principais indicadores de força de trabalho, anual para temas permanentes e suplementares.

**Escala geográfica:** Brasil, Grandes Regiões, unidades da federação, regiões metropolitanas específicas, municípios das capitais e Região Integrada de Desenvolvimento da Grande Teresina. A representatividade não é municipal para todos os indicadores.

**Variáveis comparáveis:**

- população ocupada;
- desocupação;
- força de trabalho;
- taxa de participação;
- informalidade;
- posição na ocupação;
- horas trabalhadas;
- características demográficas e educacionais.

## Internacional: Labour Force — Austrália

**Unidade de observação:** pessoas ocupadas, desempregadas ou na força de trabalho, agregadas por sexo, idade, indústria, ocupação, posição na ocupação ou região.

**Período:** série mensal desde fevereiro de 1978; algumas tabelas detalhadas têm séries trimestrais ou mensais desde novembro de 1984.

**Escala geográfica:** Austrália, estados, territórios e regiões de grande capital.

**Variáveis comparáveis:**

- emprego;
- desemprego;
- força de trabalho;
- taxa de participação;
- horas trabalhadas;
- subutilização;
- indústria;
- ocupação;
- posição na ocupação;
- duração do desemprego.

## Alternativa internacional: QCEW/LAUS — Estados Unidos

O QCEW permite estudar estabelecimentos, emprego e salários por condado, estado, área metropolitana e setor. O LAUS permite comparar força de trabalho, emprego, desemprego e taxa de desemprego em diferentes áreas locais dos Estados Unidos.

### Perguntas comparáveis

- Como evoluíram emprego, desemprego e participação no Brasil e em outros países?
- A informalidade brasileira tem algum equivalente comparável nas categorias de posição na ocupação estrangeiras?
- Como a estrutura setorial do emprego se relaciona com desemprego e subutilização?
- As diferenças entre regiões metropolitanas e áreas não metropolitanas são semelhantes?
- A duração do desemprego e as horas trabalhadas apresentam padrões convergentes?

### Limitações de harmonização

- A PNAD-C é uma pesquisa domiciliar; QCEW é baseado em estabelecimentos administrativos; a Labour Force australiana também tem conceitos próprios de pesquisa de força de trabalho.
- “Emprego”, “ocupação”, “desemprego” e “força de trabalho” podem seguir regras distintas de classificação e idade mínima.
- A informalidade é uma dimensão importante da PNAD-C, mas não possui equivalente automático nas tabelas australianas ou americanas.
- As classificações setoriais e ocupacionais — CNAE, ANZSIC, ANZSCO, NAICS e SOC — precisam ser convertidas para categorias comuns.
- A representatividade geográfica brasileira é diferente da australiana e da americana.
- As séries podem usar ajustes sazonais, calendários e períodos de referência diferentes.

* * *

# 4. Finanças públicas e governos subnacionais

## Brasil: SICONFI/Finbra — Ministério da Economia

**Unidade de observação:** município, ano, conta contábil e estágio da execução; há também tabelas por função orçamentária, balanço patrimonial e restos a pagar.

**Período:** as tabelas municipais consultadas cobrem, dependendo do tema, de 1989 a 2025; despesas por função começam em 1996 e balanço patrimonial em 1998.

**Escala geográfica:** municípios, unidades da federação e governo federal.

**Variáveis comparáveis:**

- receitas orçamentárias;
- despesas orçamentárias;
- despesas por função;
- restos a pagar;
- ativos, passivos e outras contas patrimoniais;
- estágios de execução;
- valores nominais em reais.

## Internacional: Census of Governments — Estados Unidos

**Unidade de observação:** unidade de governo e item financeiro; há tabelas complementares de unidades de governo e população.

**Período:** finanças de governos estaduais e locais de 1967 a 2018, sem dados em 1968 e 1969; não há microdados financeiros por unidade a partir de 2019. A lista de governos vai de 1997 a 2025 e emprego público de 1992 a 2024.

**Escala geográfica:** governos estaduais e locais dos Estados Unidos.

**Variáveis comparáveis:**

- receita;
- despesa;
- dívida;
- ativos;
- emprego e folha de pagamento do setor público;
- população da unidade governamental;
- tipo de governo.

### Perguntas comparáveis

- Como variam receita e despesa públicas por habitante?
- A composição da despesa municipal ou local muda conforme o tamanho do governo?
- Municípios brasileiros e governos locais americanos apresentam perfis semelhantes de endividamento?
- Qual é o peso relativo de educação, saúde, segurança e infraestrutura?
- Como se relacionam arrecadação própria, transferências e despesa total?
- Há diferenças na quantidade de empregados públicos por habitante?

### Limitações de harmonização

- Município brasileiro e “local government” americano não são unidades institucionais equivalentes.
- O Brasil possui forte divisão entre municípios, estados e União; nos Estados Unidos, condados, municípios, distritos escolares e outros governos podem ter autonomia e funções distintas.
- As classificações orçamentárias e contábeis não são diretamente correspondentes.
- O SICONFI informa contas e estágios da execução; o CoG traz itens financeiros com agregados calculados. Não se deve somar indiscriminadamente todos os itens do CoG.
- Os anos fiscais podem terminar em datas diferentes.
- O CoG não fornece microdados financeiros por unidade para os anos mais recentes, limitando comparações contemporâneas.
- Valores devem ser convertidos para uma base monetária comum e, para comparações substantivas, ajustados por inflação, paridade de poder de compra e escala populacional.

* * *

# 5. Clima e condições meteorológicas

## Brasil: BDMEP — INMET

**Unidade de observação:** estação meteorológica e medição temporal; a tabela de microdados registra compilações de medidas em intervalos de uma hora.

**Período:** o guia do conjunto informa consistência da série desde 2000; as tabelas devem ser verificadas individualmente quanto à cobertura exata de cada estação.

**Escala geográfica:** pontos de estações meteorológicas no Brasil, com identificação da estação e município.

**Variáveis comparáveis:**

- temperatura;
- precipitação;
- pressão;
- umidade;
- vento;
- radiação;
- data e hora da medição.

## Internacional: GHCN-Daily — NOAA

**Unidade de observação:** estação meteorológica, dia e elemento meteorológico.

**Período:** 1763–2026, com cobertura dependente da estação e da variável.

**Escala geográfica:** 132.501 estações em todo o mundo.

**Variáveis comparáveis:**

- temperatura máxima e mínima;
- precipitação;
- neve e profundidade de neve;
- outros elementos meteorológicos;
- indicadores de qualidade e origem da medição.

### Perguntas comparáveis

- Como diferem temperatura e precipitação em regiões climáticas distintas?
- A frequência de extremos climáticos aumentou de forma semelhante?
- Quais áreas apresentam maior variabilidade de chuva ou temperatura?
- Eventos climáticos extremos estão associados a efeitos demográficos, econômicos ou fiscais diferentes?

### Limitações de harmonização

- O BDMEP trabalha em grande parte com medições horárias de estações automáticas, enquanto o GHCN-Daily apresenta agregações diárias e combina fontes diversas.
- Estações não são distribuídas uniformemente; comparações nacionais exigem agregação espacial cuidadosa.
- Uma medição de estação é um ponto, não uma média territorial.
- O INMET informa dados brutos, não necessariamente validados; o GHCN fornece sinalizadores de qualidade que precisam ser usados.
- Horários do INMET estão em UTC e precisam ser tratados antes de análises diárias ou de eventos.
- A presença de falhas e períodos sem observação pode variar significativamente entre estações.

* * *

# 6. Emissões de gases de efeito estufa

## Brasil: SEEG

**Unidade de observação:** emissão anual por setor, gás e, conforme a tabela, categoria ou atividade.

**Escala geográfica:** Brasil, com detalhamento por setores como agropecuária, energia, mudanças de uso da terra, processos industriais e resíduos.

**Variáveis comparáveis:**

- emissões de gases de efeito estufa;
- gás emitido;
- setor emissor;
- ano;
- emissões e remoções.

## Internacional: Inventário Nacional de GEE — Austrália

**Unidade de observação:** jurisdição, ano fiscal, setor e gás.

**Período:** desde 1989–1990.

**Escala geográfica:** Austrália, estados e territórios.

**Variáveis comparáveis:**

- emissões por gás;
- emissões por setor;
- emissões em gigagramas;
- emissões de Escopo 2;
- categorias da UNFCCC e classificação econômica ANZSIC.

### Perguntas comparáveis

- Como se distribuem as emissões por setor no Brasil e na Austrália?
- Quais setores explicam a maior parte da variação anual?
- Como diferem energia, agropecuária, uso da terra, resíduos e processos industriais?
- As trajetórias de emissões per capita seguem padrões semelhantes?

### Limitações de harmonização

- O ano brasileiro e o ano fiscal australiano não são necessariamente equivalentes.
- Brasil e Austrália possuem estruturas produtivas e territoriais muito diferentes.
- As categorias setoriais podem seguir classificações distintas, embora o inventário australiano também apresente uma versão baseada na hierarquia da UNFCCC.
- Emissões de uso da terra e remoções são particularmente sensíveis a métodos de estimação e revisões.
- Para comparação per capita, será necessário harmonizar população, referência temporal e unidade de emissão.

* * *

## Cruzamentos internacionais mais viáveis

### Mais diretamente comparáveis

1. **População do IBGE × World Population Prospects** — população total, crescimento, idade, sexo e fecundidade.
2. **BDMEP/INMET × GHCN-Daily** — temperatura, precipitação e extremos meteorológicos por estação.
3. **SICONFI × Census of Governments** — receitas e despesas públicas, desde que o nível de governo seja cuidadosamente definido.
4. **Eleições Brasileiras × Eleições Nacionais** — resultados presidenciais e parlamentares em nível nacional.

### Comparáveis, mas com mais tratamento

1. **PNAD-C × Labour Force da Austrália** — mercado de trabalho e desemprego.
2. **TSE × SAGE** — eleições em pequenas áreas e concentração territorial de votos.
3. **SEEG × inventário australiano de GEE** — emissões por setor e gás.
4. **Dados municipais brasileiros × bases subnacionais estrangeiras** — exige correspondência entre unidades administrativas, limites territoriais e funções de governo.

### Regra geral de harmonização

Para uma comparação internacional consistente, seria necessário padronizar pelo menos:

- unidade de observação;
- período de referência e ano fiscal;
- escala geográfica;
- população denominadora;
- moeda, preços e paridade de poder de compra;
- classificações setoriais e ocupacionais;
- definição de votos, emprego, desemprego, receita, despesa ou emissão;
- tratamento de valores ausentes, revisões e estimativas;
- limites territoriais e mudanças administrativas.

