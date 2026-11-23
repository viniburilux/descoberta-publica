---
id: proposta-colaboracao-bd
type: proposta
---
# Da infraestrutura de dados à produção de conhecimento

## Proposta de colaboração entre Base dos Dados e Descoberta Pública

### 1. Contexto

O Descoberta Pública é uma iniciativa independente de investigação e inteligência aplicada a dados públicos brasileiros.

A partir da infraestrutura da Base dos Dados, desenvolvemos um fluxo de trabalho que transforma perguntas de investigação em consultas reproduzíveis, cruzamentos entre bases, conjuntos de dados derivados, análises, aplicações interativas e produtos de comunicação.

A proposta é demonstrar, por meio de casos concretos, como a infraestrutura de dados pode sustentar uma cadeia integrada de produção científica, tecnológica e jornalística.

### 2. Um caso já desenvolvido: crédito rural e território

A investigação BD-007 ("O Dinheiro e o Território") cruza microdados do SICOR com registros do Cadastro Ambiental Rural (CAR), construindo uma representação territorial do crédito rural público a partir dos imóveis associados às operações.

O trabalho reúne:

- Consultas SQL reproduzíveis sobre as tabelas públicas da Base dos Dados (`br_bcb_sicor`, `br_sfb_sicar`, `br_ibge_pam`, `br_mapbiomas_estatisticas`).
- Um método documentado de integração SICOR-CAR (normalização do identificador: 0% -> 99,999% de cobertura no join).
- Dataset municipal de crédito rural público territorializado (5.380 municípios, 2023; série 2019-2025).
- Validação contra os agregados oficiais do Banco Central (MDCR), com diferença abaixo de 0,1% nos totais.
- Aplicação interativa de mapa municipal e materiais de reprodução.
- Manuscrito científico em preparação para submissão à revista Data in Brief, com depósito de dados no Zenodo (rascunho, DOI reservado).

### 3. Oportunidade de colaboração

Propomos explorar uma colaboração em três frentes:

**Produção científica.** Desenvolvimento e divulgação de conjuntos de dados derivados, métodos de integração, estudos e artigos baseados na infraestrutura da BD, com atribuição adequada das contribuições de cada participante.

**Aplicações e demonstrações.** Construção de aplicações, indicadores, mapas e estudos de caso que demonstrem possibilidades concretas de uso do catálogo e das ferramentas da BD.

**Comunicação e jornalismo de dados.** Transformação de descobertas em pautas, artigos, visualizações e conteúdos acessíveis ao público.

### 4. Modelo de trabalho proposto

O Descoberta Pública mantém sua independência e conduz suas próprias investigações, utilizando e referenciando a infraestrutura da Base dos Dados. A colaboração pode ocorrer por meio de publicação conjunta de estudos quando houver contribuição efetiva das partes, envio de descobertas para os canais de comunicação da BD, divulgação cruzada de aplicações e conjuntos de dados, desenvolvimento de demonstrações de uso do catálogo e do chatbot, e identificação conjunta de novas perguntas de investigação.

Cada iniciativa terá autoria, responsabilidades e condições de publicação definidas conforme sua contribuição específica.

### 5. Proposta inicial

Sugerimos começar com a apresentação do caso SICOR x CAR como demonstração completa do fluxo: pergunta, consulta, integração, resultado, validação, dataset, aplicação e produção científica. A partir dela, discutir uma agenda contínua de investigações e aplicações sobre outros domínios do catálogo.

**Descoberta Pública** - investigação, integração e inteligência aplicada a dados públicos brasileiros.
Repositório: https://github.com/viniburilux/descoberta-publica
