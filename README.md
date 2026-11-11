# Descoberta Pública

**Uma iniciativa aberta para descobrir padrões, perguntas e conexões na informação pública brasileira.**

A informação pública do Brasil é enorme e quase inutilizável do jeito que está espalhada. A Descoberta Pública faz o trabalho de base: coleta, organiza, documenta e devolve esses dados em pacotes prontos para descoberta, análise e investigação.

O objetivo não é só reunir dados. É reduzir a distância entre informação pública e alguém descobrir algo com ela.

## Por que importa

Uma contratação isolada conta pouco. Cruzar milhares delas pode revelar padrões, diferenças entre municípios e perguntas que ninguém fez ainda. É daí que podem sair uma história, uma pesquisa, uma ferramenta ou uma investigação.

A Descoberta Pública estrutura a matéria-prima. O [Quem Pagou Isso?](https://www.instagram.com/quempagouisso/) transforma descobertas em atenção e conversa. Outras pessoas podem chegar com perguntas e construir caminhos que a gente ainda não imaginou.

O PNCP é a primeira fonte, não o limite do projeto.

## O que já existe

### Base original: inexigibilidades do PNCP

A edição **v0.1.2** reúne **494.446 registros únicos das 27 UFs**, publicados entre 01/01/2025 e 06/11/2026, com uma lacuna de 22 a 31/08/2026. Inclui classificação do objeto, ferramentas de consulta e uma dimensão de municípios com população, PIB e receita.

[Baixar a edição v0.1.2](https://github.com/viniburilux/descoberta-publica/releases/tag/v0.1.2) ou escolher pacotes por UF em [`dados/`](dados/).

### Fonte adicional: snapshot PNCP do Kaggle

**3.768.885 contratações únicas, 18 modalidades presentes, 69 Parquets por modalidade/ano.** Snapshot declarado de 30/09/2026, organizado e processado como fonte separada. **Não foi somado à base original de 494.446 nem a substitui.**

O mérito da coleta e da disponibilização é de **Lucas Rangel S. Souza**: [dataset no Kaggle](https://www.kaggle.com/datasets/lucasrangelss/pncp-raw-trusted-part-1) e [projeto do coletor](https://github.com/LucasRangelSSouza/brazil-public-data-map). A fonte primária é o PNCP.

[Baixar o processamento e os manifestos](https://github.com/viniburilux/descoberta-publica/releases/tag/kaggle-pncp-v0.1.0) · [Código e documentação](fontes/kaggle_pncp/).

Antes de usar esta fonte:
- A classificação fora da inexigibilidade **ainda não foi validada**; há erros documentados como "banda larga" e "forro" classificados como artístico.
- O mascaramento por padrões **não anonimiza nomes** nem garante remoção de todo dado pessoal.
- Os termos são os da fonte: **"Other (specified in description)" / "Source terms apply; credit the original publisher"**. Não se aplica automaticamente a licença CC BY 4.0 da edição original. Preserve o crédito ao coletor e ao PNCP.

## O que dá para fazer com isso

- **Descobrir padrões:** comparar objetos, valores, municípios e períodos; encontrar recorrências e perguntas para aprofundar.
- **Contar histórias:** usar o dado como ponto de partida para conteúdo e jornalismo, voltando ao ato original quando o achado pede contexto.
- **Construir em cima:** pesquisa, cruzamentos com outras bases, ferramentas, produtos de transparência e agentes de IA.

Há espaço para uma trilha experimental de investigação: anomalias, padrões, cruzamentos, perguntas e aprofundamento. Não precisa começar procurando fraude. Um achado pode ser erro de preenchimento ou o começo de uma história. Essa trilha é uma possibilidade de trabalho, não uma investigação já concluída.

## Como usar

### Consultar a base original

Extraia os pacotes de [`dados/`](dados/) e [`ferramentas/`](ferramentas/) na mesma pasta. Instale `duckdb` com `python -m pip install duckdb` e rode:

```bash
python consultar.py --resumo --ano 2025
python consultar.py --uf BA --ano 2025 --municipio Salvador --esfera M --csv salvador.csv
python consultar.py --uf CE --objeto show --limite 500 --csv shows_ce.csv
```

Um leitor de Parquet com suporte a partições Hive também lê os dados; a dimensão de municípios se junta por `cod_ibge`.

### Conferir a integridade do pacote

Antes de confiar no acervo, verifique os SHA-256 declarados no manifesto (somente leitura):

```bash
python3 ferramentas/verificar_integridade.py
```

O script retorna `0` quando todos os arquivos com checksum conferem e lista explicitamente as entradas informativas sem checksum (documentos). Para quem baixa a release, é a checagem de que nada foi alterado em trânsito.

### Usar o snapshot Kaggle processado

Na [release da fonte adicional](https://github.com/viniburilux/descoberta-publica/releases/tag/kaggle-pncp-v0.1.0), baixe as 45 partes, o manifesto e o utilitário para reunir e conferir os hashes. As instruções estão em [`fontes/kaggle_pncp/`](fontes/kaggle_pncp/). Mantenha as fontes distintas ao comparar ou deduplicar.

## Metodologia e limites

Os arquivos têm procedência e checagens de integridade documentadas. Isso não significa que cada contratação foi investigada ou confirmada.

**Valor estimado e homologado não são valor pago. Classificação e anomalias são pistas para explorar, não conclusões ou acusações.**

- [Metodologia, integridade e diferenças entre as fontes](docs/METODOLOGIA_FONTES.md)
- [Limitações da edição original](docs/LIMITACOES.md)
- [Método, privacidade e limites do snapshot Kaggle](fontes/kaggle_pncp/)

Código da edição original sob MIT; curadoria, documentação e derivados da edição v0.1.2 sob CC BY 4.0. A fonte adicional de terceiros mantém os termos descritos acima. Consulte [`LICENSE-CODE`](LICENSE-CODE) e [`LICENSE-DATA`](LICENSE-DATA).

Se você quer usar, testar, criticar ou construir junto: este repositório é o ponto de partida.

Origem da iniciativa: [LuxVerso](https://github.com/viniburilux/LuxVerso).
