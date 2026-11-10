# Descoberta Pública

**Uma iniciativa aberta para descobrir padrões, perguntas e conexões na informação pública brasileira.**

A informação pública do Brasil é enorme — e quase inutilizável do jeito que está espalhada. A Descoberta Pública faz o trabalho de base: coleta, organiza, verifica e devolve esses dados em pacotes prontos para qualquer pessoa usar. Sem cadastro, sem paywall, sem permissão.

O Portal Nacional de Contratações Públicas (PNCP) é a primeira base. Não é o limite: outras fontes de dados públicos entram no caminho.

## O que dá para fazer com isso

- **Descobrir.** Os dados chegam prontos para pergunta, não só para download: o que sua cidade contratou, de quem, por quanto, com que justificativa.
- **Contar histórias.** O [Quem Pagou Isso?](https://www.instagram.com/quempagouisso/) transforma descobertas desta base em vídeos e posts curtos. É a camada de distribuição da iniciativa: a descoberta nasce aqui, a conversa acontece lá.
- **Construir em cima.** Pesquisa, jornalismo de dados, ferramentas, produtos de transparência. A edição original é aberta (código MIT, conteúdo CC BY 4.0) para ser usada, cruzada e republicada com crédito. Fontes adicionais de terceiros mantêm seus próprios termos, descritos abaixo.

## Primeiro ativo: Inexigibilidades publicadas no PNCP

Recorte 2025 e 2026 parcial, edição **v0.1.2**:

- **494.446 registros únicos** das 27 UFs, publicados no portal entre 01/01/2025 e 06/11/2026 (o período de 22 a 31/08/2026 não está na base).
- Modalidade **inexigibilidade de licitação**: contratações diretas por lei, de shows a obras.
- Dimensão de municípios com população, PIB (IBGE) e receita (Siconfi) para cruzamento.
- Classificação do objeto por categorias, com metodologia e validação abertas.
- Ferramentas de consulta incluídas — três comandos e você está filtrando por UF, município e tema.

**Download completo:** [Release v0.1.2](https://github.com/viniburilux/descoberta-publica/releases) — ou baixe só os pacotes das UFs que interessam em `dados/`.

## Fonte adicional: snapshot PNCP do Kaggle

A Descoberta Pública também oferece um processamento separado do snapshot publicado por **Lucas Rangel S. Souza**: [dataset no Kaggle](https://www.kaggle.com/datasets/lucasrangelss/pncp-raw-trusted-part-1) e [projeto do coletor](https://github.com/LucasRangelSSouza/brazil-public-data-map). O mérito da coleta é dele; a fonte primária é o PNCP.

São **3.768.885 contratações únicas, 18 modalidades presentes, 69 Parquets por modalidade/ano**, snapshot declarado de 30/09/2026. Código, manifestos e pacote de dados ficam em [Releases](https://github.com/viniburilux/descoberta-publica/releases); metodologia em `fontes/kaggle_pncp/`. É uma fonte adicional, **não uma soma nem substituição da base original de 494.446**, que continua distinta e intacta. Não prova cobertura completa.

- Classificador v6.3 reaplicado, **não validado nas outras modalidades**. Erros documentados: internet "banda larga", obra com "forro" e manutenção de teatro podem virar artístico. Os 202.953 rótulos artísticos do conjunto inteiro incluem inexigibilidade e não são uma estimativa validada de mercado.
- Mascaramento por padrões: 16.836 ocorrências de CPF-like/e-mail/telefone/RG. **Não anonimiza nomes** nem garante remoção de todo dado pessoal. Não foi o mesmo código de privacidade da edição v0.1.2.
- **3.978 IDs do trusted não têm linhagem explicada pelo raw de atualização disponível**. Uma comparação histórica encontrou 280 IDs próprios ausentes no snapshot. Não fundir contagens sem reconciliação por ID.
- **Exceção às licenças gerais deste repositório:** este dataset de terceiro informa "Other (specified in description)" e "Source terms apply; credit the original publisher". Não o relicenciamos como CC BY 4.0; preserve crédito ao coletor e ao PNCP, procedência e avisos. Sem endosso/afiliação e sem certificação jurídica ou de anonimato.

## O que existe hoje, o que pode virar

**Existe hoje:** esta base, as ferramentas, a classificação e um canal publicando histórias reais a partir dela.

**Pode virar (hipóteses, não promessas):** novas fontes além do PNCP (diários oficiais, outras bases federais), mais modalidades e anos de contratações, camadas de investigação mais profundas, parcerias com pesquisa e jornalismo, produtos de transparência em cima desta infraestrutura.

Se você quer usar, testar, criticar ou construir junto: este repositório é o ponto de partida.

## Antes de usar, saiba

- **O recorte é por data de publicação no PNCP, não pelo ano do ato.** A base inclui compras de anos anteriores publicadas nesse período: entre os registros publicados em 2025–2026 há compras de 2022 a 2026 pelo ano da compra.
- **Valor estimado e valor homologado não são valor pago.** São campos do registro público, preservados como vieram da fonte — inclusive os visivelmente inconsistentes.
- **Nomes de fornecedores, órgãos e municípios são a substância pública dos atos** e foram mantidos. Identificadores pessoais que os órgãos escreveram no texto livre (CPF, RG, e-mail pessoal, endereço residencial) foram mascarados nesta edição; famílias beneficiárias de programas sociais tiveram os nomes removidos. Não é anonimização: os registros de origem seguem públicos no PNCP.
- Leia `docs/LIMITACOES.md` antes de reutilizar. A classificação derivada é material de exploração, não conclusão nem acusação.

## Como consultar

Extraia os pacotes de `dados/` e `ferramentas/` na mesma pasta. Com `duckdb` instalado (`python -m pip install duckdb`):

```
python consultar.py --resumo --ano 2025
python consultar.py --uf BA --ano 2025 --municipio Salvador --esfera M --csv salvador.csv
python consultar.py --uf CE --objeto show --limite 500 --csv shows_ce.csv
```

Qualquer leitor de Parquet com suporte a partições Hive lê `dados/` direto; a dimensão de municípios se junta por `cod_ibge`.

## Origem, integridade e licenças

- **Fontes:** PNCP (API de dados abertos, sem cadastro), Siconfi/Tesouro Nacional, IBGE. Os registros são dados públicos governamentais; este pacote não concede nem restringe direitos sobre eles.
- **Integridade:** 621 arquivos brutos com SHA256 conferido (100%); contagens por UF/ano verificadas após cada transformação; hashes desta edição em `manifest_v012.json`.
- **Licenças:** código sob MIT (`LICENSE-CODE`); curadoria, documentação e derivados sob CC BY 4.0 (`LICENSE-DATA`). Atribuição: "Vinícius Buri Lux (LuxVerso), Descoberta Pública — Inexigibilidades publicadas no PNCP, v0.1.2".

Origem da iniciativa: [LuxVerso](https://github.com/viniburilux/LuxVerso).
