# BD-005: conversa BD

Origem: https://basedosdados.org/chatbot?t=6deb373a-9730-4a52-b009-c9eefa55f26f

Thread: `6deb373a-9730-4a52-b009-c9eefa55f26f`. Mensagens: 2.

## 1. USER | 2026-11-18T19:09:01.268803Z

Identificador: `d648dc68-9953-4632-8813-dcaa1fdbf5b8`.

Identifique as principais entidades que aparecem em múltiplos datasets da Base dos Dados. Não se limite a município e ano. Procure empresas, instituições, pessoas, países, territórios, produtos, setores, eventos e outras entidades que possam funcionar como pontos de conexão. Para cada entidade, indique datasets relacionados, campos de identificação e possíveis cruzamentos.

## 2. ASSISTANT | 2026-11-18T19:09:01.326657Z

Identificador: `1fcc18fd-464d-4135-a903-af3f5da08c3a`.

A Base dos Dados funciona melhor como uma **rede de entidades e chaves de ligação** do que como um único banco integrado. Os pontos de conexão mais fortes que aparecem nos metadados consultados são os seguintes.

## 1. Empresas e estabelecimentos — CNPJ

**Identificadores principais**

- `cnpj` — identifica o estabelecimento, com 14 dígitos.
- `cnpj_basico` — identifica a pessoa jurídica ou grupo de estabelecimentos, com os oito primeiros dígitos.
- `cnpj_ordem` e `cnpj_dv` — componentes do CNPJ.
- `razao_social`, `nome_fantasia` — identificadores textuais, menos seguros para junções.
- `cnae_fiscal_principal` e `cnae_fiscal_secundaria` — atividade econômica.
- `id_municipio`, `sigla_uf`, `id_pais` — localização.

**Datasets relacionados**

- **Quadros Societários CNPJ**: `empresas`, `estabelecimentos`, `socios` e `simples`.
- **Cadastros de Sanções da CGU**: `cpf_cnpj_sancionado`, `cnpj_entidade` ou campos equivalentes nas tabelas de sanções.
- **Eleições Brasileiras**: CNPJs de doadores, prestadores de contas, contratantes e pagantes de pesquisas.
- **Censo Escolar**: `cnpj_escola` e `cnpj_mantenedora` para escolas privadas.
- **CNES**: `cnpj_mantenedora` e `cpf_cnpj` de estabelecimentos de saúde.
- **Comex Stat** e **Empresas exportadoras e importadoras**: conexão temática com empresas de comércio exterior, embora as tabelas municipais do Comex Stat sejam agregadas e não tragam necessariamente o CNPJ individual.

**Cruzamentos possíveis**

- Empresa ↔ sanção administrativa: CNPJ no cadastro da Receita Federal contra CNPJ sancionado pela CGU.
- Empresa ↔ campanha eleitoral: CNPJ doador ou prestador de contas contra situação cadastral, atividade econômica, porte e localização no CNPJ.
- Mantenedora escolar ↔ empresa: CNPJ da mantenedora contra natureza jurídica, CNAE, município e situação cadastral.
- Mantenedora de estabelecimento de saúde ↔ CNPJ: identificação da natureza jurídica e localização do prestador.
- Empresa ↔ comércio exterior: combinação de município fiscal, CNAE e atividade exportadora/importadora; não se deve interpretar o município do Comex automaticamente como local de produção.

**Cuidado:** as tabelas do CNPJ são fotografias. O mesmo CNPJ reaparece em cada `data_referencia`, portanto a data precisa fazer parte do filtro analítico.

## 2. Sócios, representantes e pessoas físicas

**Identificadores principais**

- `documento` — CPF mascarado ou CNPJ do sócio no CNPJ.
- `cpf_representante_legal` — representante legal de uma empresa.
- `nome`, `nome_representante_legal` — identificação textual.
- `titulo_eleitoral` — identificador longitudinal de candidatos no TSE.
- `cpf` — CPF de candidatos em períodos em que essa informação foi divulgada.
- `cpf_cnpj_sancionado` — pessoa física ou jurídica sancionada pela CGU.

**Datasets relacionados**

- **Quadros Societários CNPJ — `socios`**.
- **Eleições Brasileiras — `candidatos`**, `receitas_candidato`, `despesas_candidato`, bens e certidões.
- **Cadastros de Sanções da CGU — `ceis` e `cnep`**.
- **Contratantes e pagantes de pesquisas eleitorais**, dentro de Eleições Brasileiras.

**Cruzamentos possíveis**

- Pessoa candidata ↔ receitas e despesas de campanha pelo conjunto da eleição e pelos identificadores do candidato.
- Pessoa candidata ↔ sócio ou representante legal, quando houver CPF ou documento compatível.
- Pessoa física/jurídica ↔ sanção administrativa pela combinação de CPF/CNPJ.
- Pessoa ↔ patrimônio declarado, ocupação, partido, votos e situação eleitoral.

**Limitações:** nomes não são chaves confiáveis. CPFs de candidatos não estão disponíveis de forma uniforme em todos os anos; no TSE, `titulo_eleitoral` é recomendado para acompanhar candidatos ao longo do tempo, mas pode ser nulo ou apresentar exceções.

## 3. Instituições de ensino, escolas e mantenedoras

**Identificadores principais**

- `id_escola` e `ano` no Censo Escolar.
- `id_ies` e `ano` no Censo da Educação Superior.
- `id_mantenedora` e `nome_mantenedora` na educação superior.
- `cnpj_escola` e `cnpj_mantenedora` para escolas privadas.
- `id_municipio` e `sigla_uf` como localização.

**Datasets relacionados**

- **Censo Escolar — `escola`, `turma`, `matricula` e `docente`**.
- **Censo da Educação Superior — `ies` e `curso`**.
- **Indicadores Educacionais**.
- **Índice de Desenvolvimento da Educação Básica (Ideb)**.
- **Sinopses Estatísticas da Educação Básica**.
- **CNES**, que também possui uma tabela `estabelecimento_ensino`.
- **Censo Demográfico**, para características sociodemográficas do território.

**Cruzamentos possíveis**

- Escola ↔ Ideb e indicadores educacionais por `id_escola`, ano e localização.
- Escola ↔ CNPJ da mantenedora, permitindo estudar natureza jurídica, porte e atividade econômica.
- IES ↔ cursos, matrículas, docentes e mantenedora por `id_ies` e ano.
- Rede escolar ↔ população, renda, urbanização e condições domiciliares por município ou UF.
- Educação ↔ emprego formal por município, CNAE e setor, usando RAIS ou CAGED como camada agregada.

O Censo Escolar informa que as tabelas podem ser cruzadas internamente por `id_escola`, `id_turma` e `ano`. Matrículas e docentes são anonimizados; as escolas, por outro lado, podem ser acompanhadas ao longo dos anos.

## 4. Estabelecimentos e instituições de saúde

**Identificadores principais**

- `id_estabelecimento_cnes` — identificador do estabelecimento de saúde.
- `cnpj_mantenedora` e `cpf_cnpj` — entidade mantenedora ou responsável.
- `id_municipio`, `id_municipio_6`, `id_regiao_saude` e `id_microrregiao_saude`.
- `id_contrato_estado_sus` e `id_contrato_municipio_sus` — vínculos contratuais com o SUS.

**Datasets relacionados**

- **Cadastro Nacional de Estabelecimentos de Saúde (CNES)**: estabelecimento, profissional, equipe, leito, equipamento, habilitação, incentivos e serviços especializados.
- **Sistema de Informações Ambulatoriais (SIA)**.
- **Sistema de Informações Hospitalares do SUS (SIH/SUS)**.
- **Cobertura da Atenção Básica**.
- **Beneficiários de Plano de Saúde**.
- **SINASC**, **SISVAN** e **Pesquisa Nacional de Saúde**.
- **CNPJ**, para dados da mantenedora e natureza jurídica.

**Cruzamentos possíveis**

- Estabelecimento ↔ leitos, equipes, profissionais, equipamentos e serviços pelo `id_estabelecimento_cnes`.
- Estabelecimento ↔ produção ambulatorial e internações por CNES.
- Estabelecimento ↔ CNPJ da mantenedora, natureza jurídica e município.
- Rede de saúde ↔ população, nascimentos, cobertura da atenção básica e indicadores socioeconômicos.
- Estabelecimento ↔ contratos e gestão municipal/estadual do SUS.

## 5. Municípios, estados, regiões de saúde e países

Essas entidades são as principais chaves territoriais transversais, embora não sejam o único tipo de conexão relevante.

**Identificadores principais**

- `id_municipio` — código IBGE de sete dígitos.
- `sigla_uf` — unidade da Federação.
- `id_municipio_tse` — código eleitoral do município.
- `id_municipio_rf` — código da Receita Federal.
- `id_regiao_saude`, `id_microrregiao_saude` — recortes do sistema de saúde.
- `id_pais` e `sigla_pais_iso3` — país de destino ou origem.
- `id_sh4` e `id_ncm` — classificações de produtos, não localidades.

**Datasets relacionados**

Praticamente todos os conjuntos brasileiros consultados usam `id_municipio` ou `sigla_uf`, incluindo CNPJ, Censo Escolar, educação superior, CNES, eleições, RAIS, CAGED, PIB, Comex Stat e bases de saúde.

**Cruzamentos possíveis**

- Município ↔ população, PIB, emprego, educação, saúde e resultados eleitorais.
- Município ↔ empresas e estabelecimentos por endereço fiscal ou localização cadastral.
- Município ↔ fluxos de exportação/importação, produtos e países.
- Município ↔ seção ou zona eleitoral, com as chaves específicas do TSE.
- Município ↔ região de saúde e cobertura assistencial.

**Cuidado:** `id_municipio_tse`, `id_municipio_rf` e `id_municipio` não devem ser tratados como equivalentes sem usar as tabelas de referência correspondentes. O TSE também registra municípios no exterior, que podem não possuir código IBGE.

## 6. Partidos, candidaturas e eleições

**Identificadores principais**

- `id_eleicao`, `ano` e `tipo_eleicao`.
- `sequencial`, `sequencial_candidato` e `titulo_eleitoral`.
- `numero_partido` e `sigla_partido`.
- `id_municipio_tse`, `zona` e `secao`.
- `cargo`, `turno` e `data_eleicao`.

**Datasets relacionados**

- **Eleições Brasileiras — `candidatos`**.
- Resultados por candidato, município, zona e seção.
- Resultados e receitas por partido.
- Bens, despesas e receitas de candidatos.
- Perfil do eleitorado e detalhes da votação.
- Pesquisas eleitorais, contratantes e pagantes.

**Cruzamentos possíveis**

- Candidato ↔ votos, bens, receitas, despesas e certidões.
- Partido ↔ coligações, federações, receitas e resultados.
- Candidato ↔ CNPJ/CPF doador e prestador de contas.
- Eleição ↔ perfil do eleitorado, escolaridade, idade, gênero e biometria.
- Município ↔ votação, população, renda, educação, emprego e saúde.
- Empresa ↔ doações, pesquisas eleitorais contratadas e prestação de contas.

Para candidaturas a partir de 2010, o guia do conjunto indica `ano`, `tipo_eleicao` e `sequencial_candidato` como combinação de identificação da candidatura. Para rastrear a pessoa, recomenda-se `titulo_eleitoral`.

## 7. Produtos, mercadorias e classificações comerciais

**Identificadores principais**

- `id_sh4` — posição de quatro dígitos do Sistema Harmonizado.
- `id_ncm` ou códigos da Nomenclatura Comum do Mercosul.
- Códigos SH6 e CUCI/SITC nas bases internacionais.
- `id_pais` e `sigla_pais_iso3` — parceiro comercial.
- `id_municipio` — município fiscal da empresa declarante no Comex Stat.

**Datasets relacionados**

- **Comex Stat**: exportação e importação por município e por NCM.
- **Comércio Internacional e Complexidade Econômica (BACI e Atlas)**.
- **Diretórios de Comércio Internacional**.
- **Empresas exportadoras e importadoras**.
- CNPJ e CNAE para caracterização das empresas, quando a granularidade permitir.

**Cruzamentos possíveis**

- Produto ↔ país de destino/origem, valor FOB e peso líquido.
- Produto ↔ município exportador/importador.
- Produto ↔ complexidade econômica, vantagem comparativa e estrutura produtiva.
- Produto ↔ setor CNAE e emprego formal por município ou setor.
- Empresa exportadora/importadora ↔ situação cadastral, porte e atividade econômica, quando houver identificador empresarial compatível.

O Comex Stat diferencia claramente o município da empresa declarante do local de produção. Também não se deve misturar automaticamente as séries do BACI em SH6 com as séries do Atlas em CUCI/SITC, pois as metodologias são distintas.

## 8. Setores econômicos, ocupações e atividades

**Identificadores principais**

- `cnae_fiscal_principal`, `cnae_fiscal_secundaria` no CNPJ.
- `cnae`, `cnae_2_doador` e descrições CNAE no TSE.
- `cbo` nas bases de trabalho.
- `cnae`, porte, natureza jurídica e tamanho do estabelecimento na RAIS/CAGED.
- Classificações SH/NCM para mercadorias.

**Datasets relacionados**

- **CNPJ**.
- **RAIS** — estabelecimentos e vínculos.
- **CAGED** — movimentações de emprego.
- **Eleições Brasileiras — receitas de campanha**.
- **Comex Stat**.
- **PIB**, especialmente quando houver desagregação setorial ou territorial.

**Cruzamentos possíveis**

- CNAE ↔ número de empresas e estabelecimentos.
- CNAE ↔ empregos formais, salários, admissões e desligamentos.
- CNAE ↔ doadores de campanha.
- CNAE ↔ exportações, importações e produtos.
- CNAE ↔ PIB, renda e estrutura produtiva municipal.
- CBO ↔ ocupação, escolaridade, remuneração e setor econômico.

**Limitação importante:** RAIS e CAGED são anonimizados e não contêm CNPJ ou CPF. O cruzamento com CNPJ deve ser feito por dimensões agregadas, como CNAE, município, UF, setor, ocupação e período, e não por empresa individual.

## 9. Eventos administrativos e econômicos

Além de entidades persistentes, vários datasets oferecem eventos que podem ser usados como pontos de conexão temporal:

| Evento | Identificadores | Cruzamentos potenciais |
|---|---|---|
| Eleição | `id_eleicao`, `ano`, `tipo_eleicao`, `data_eleicao` | candidaturas, votos, financiamento, eleitorado e contexto municipal |
| Sanção administrativa | `codigo_sancao`, processo, CPF/CNPJ, datas de início e fim | empresa, pessoa, órgão sancionador e contratos públicos |
| Movimentação trabalhista | ano, mês, município, CNAE, CBO e tipo de movimentação | emprego formal, atividade econômica e conjuntura local |
| Receita ou despesa eleitoral | `sequencial_candidato`, recibo, CPF/CNPJ, data e valor | candidato, partido, empresa e doador |
| Exportação/importação | ano, mês, produto, país e município | comércio, setor econômico e território |
| Atendimento de saúde | CNES, município, procedimento e competência | estabelecimento, leitos, profissionais e população |
| Matrícula escolar | `id_escola`, `id_turma`, ano e etapa de ensino | infraestrutura, docentes, resultados e território |

## Mapa de conexão recomendado

Uma arquitetura de integração particularmente promissora seria:

1. **Camada empresarial:** CNPJ, CNAE, natureza jurídica e município.
2. **Camada de pessoas:** CPF/título eleitoral, sócios, candidatos e sancionados, com controles de qualidade e privacidade.
3. **Camada institucional:** escola, IES, estabelecimento de saúde e mantenedora.
4. **Camada territorial:** município IBGE, UF, regiões de saúde e país.
5. **Camada classificatória:** CNAE, CBO, SH/NCM e códigos eleitorais.
6. **Camada temporal/eventos:** eleições, sanções, admissões, desligamentos, comércio, atendimentos e matrículas.

Os cruzamentos mais robustos são os baseados em identificadores explícitos — CNPJ, `id_escola`, `id_ies`, CNES, `id_municipio`, `id_eleicao`, `id_sh4` e ISO3 de país. Cruzamentos por nome, endereço, razão social ou nome de pessoa devem ser tratados como aproximações e passar por normalização e validação.

