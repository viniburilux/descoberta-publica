# Licença — leitura dos termos das fontes e proposta (v0.1)

**Status: APROVADA pelo autor em 08/11/2026.** Os textos das licenças adotadas estão em `LICENSE-CODE` (MIT) e `LICENSE-DATA` (CC BY 4.0) na raiz do repositório. Este documento permanece como registro da decisão.

Documento de apoio à decisão de licenciamento deste pacote, preparado em 07–08/11/2026. **Nenhum termo foi aceito em nome do autor e nenhuma licença foi adotada ainda.** Esta proposta precisa da aprovação do Vinícius antes de qualquer publicação.

## 1. Registros públicos subjacentes (PNCP)

Os registros coletados são publicações exigidas por lei (Lei 14.133/2021) e disponibilizados na API de dados abertos do PNCP. Não cabe a este pacote conceder ou restringir direitos sobre eles; o que se licencia abaixo é a seleção, organização e documentação produzidas sobre eles.

## 2. Termos localizados nas fontes (consultados em 07–08/11/2026)

- **PNCP** — página "Dados abertos" <https://www.gov.br/pncp/pt-br/acesso-a-informacao/copy_of_dados-abertos>: descreve que os dados abertos podem ser baixados "para manipulá-los em aplicativos da forma como quiser". A página de perguntas frequentes afirma que "todas as informações são públicas e podem ser acessadas livremente". **Não localizamos uma licença nominal** (CC, ODbL etc.) nas páginas de dados abertos do PNCP consultadas. Se o usuário reutilizador preferir verificar por conta própria, o ponto de contato oficial do PNCP está no próprio portal.
- **Siconfi / Tesouro Transparente** — <https://www.tesourotransparente.gov.br/consultas/consultas-siconfi/siconfi-api-de-dados-abertos>: página da API de dados abertos do Siconfi (RREO, DCA), acesso aberto e sem chave. Não localizamos licença nominal na página da API.
- **IBGE** — <https://www.ibge.gov.br/acesso-informacao/dados-abertos.html>: o IBGE disponibiliza seu acervo sob a Política de Dados Abertos instituída pelo Decreto 8.777/2016, que define dados abertos como "acessíveis a todos e que podem ser usados, reutilizados e redistribuídos livremente por qualquer pessoa".

O que isso sustenta, e o que não sustenta:

- **Sustentado pelas fontes lidas:** acesso livre, download e manipulação dos dados (as três fontes); uso, reutilização e redistribuição livres (IBGE, por força do Decreto 8.777/2016).
- **Não localizado:** uma licença nominal do PNCP ou do Siconfi que estabeleça expressamente termos de redistribuição de pacotes derivados. O trecho "redistribuição permitida" não pode ser afirmado para essas duas fontes com base no que foi lido; há permissão de acesso e manipulação, e ausência de licença nominal localizada. Isso é o padrão da Lei de Acesso à Informação para dados públicos, mas esta proposta não transforma isso em parecer jurídico.

## 3. Proposta de licenciamento do pacote

O pacote mistura código, dados estruturados e documentação. Recomendação (não imposição legal): licenciar em duas faixas.

**a) Código das ferramentas (`consultar.py`, `expandir.py`, `categorizar_v63.py`) — MIT.**
Os arquivos foram escritos no âmbito deste acervo e o histórico disponível no projeto não indica código de terceiros incorporado (ausência de cabeçalho alheio é indício, não prova). Dependências apenas de bibliotecas externas instaladas pelo usuário, não redistribuídas no pacote: DuckDB, licença MIT (fonte oficial: https://duckdb.org/faq), e PyArrow, licença Apache 2.0 (fonte oficial: https://arrow.apache.org). MIT é uma licença permissiva, padrão para código utilitário, e não impõe nada sobre os dados.

**b) Seleção, organização e documentação (estrutura de pastas, dicionário de dados, metodologia, README, derivados de classificação) — CC BY 4.0.**
Atribuição: "Vinícius Buri Lux (LuxVerso), Inexigibilidades publicadas no PNCP — recorte 2025 e 2026 parcial, v0.1". CC BY 4.0 permite uso comercial e obras derivadas com atribuição, o que é compatível com a finalidade declarada (reutilização aberta da base).

### O que a proposta não faz

- Não licencia os registros públicos subjacentes (não é nosso papel; são dados governamentais públicos).
- Não garante ausência de restrições: quem reutilizar deve conferir os termos atuais das fontes, que podem mudar.
- Não concede direito de usar o nome do autor ou do projeto para endossar usos derivados (a cláusula padrão de não-endosso da CC BY cobre isso em parte).

## 4. Arquivos de licença no pacote

Se aprovada, incluir na raiz do pacote publicado:

- `LICENSE-CODE` — texto integral da MIT.
- `LICENSE-DATA` — texto integral da CC BY 4.0.
- Referência no README: "Código sob MIT; documentação e curadoria sob CC BY 4.0; registros subjacentes são dados públicos das fontes citadas."

## 5. Decisão pendente do autor

Aprovar, trocar ou complementar as licenças propostas. Nenhum texto de licença foi incluído nesta versão de preparação.
