# PNCP: snapshot Kaggle processado

## Crédito à coleta original

O mérito da coleta e da disponibilização deste snapshot é de **Lucas Rangel S. Souza** (perfil Kaggle `lucasrangelss`). Este projeto reaproveita e transforma esse trabalho, sem se apresentar como autor da coleta.

- Dataset original: https://www.kaggle.com/datasets/lucasrangelss/pncp-raw-trusted-part-1
- Projeto do coletor: https://github.com/LucasRangelSSouza/brazil-public-data-map
- Fonte pública primária: Portal Nacional de Contratações Públicas (PNCP).

Processamento e organização derivados: Vinícius Buri / Descoberta Pública. Snapshot declarado pelo publicador: **30/09/2026**. Processamento: **10/11/2026**.

## O que há aqui

**3.768.885 contratações com IDs únicos, 18 modalidades presentes, 69 Parquets por modalidade e ano de publicação.** Os arquivos de dados ficam nos assets da release, junto com o pacote de código, manifestos e verificações.

| Modalidade | Registros |
| --- | ---: |
| Dispensa | 1.904.280 |
| Pregão eletrônico | 1.008.541 |
| Inexigibilidade | 620.283 |
| Concorrência eletrônica | 145.930 |
| Credenciamento | 44.394 |
| Pregão presencial | 27.920 |
| Outras modalidades presentes | 17.537 |
| **Total** | **3.768.885** |

Os totais referem-se a contratações, não itens, contratos assinados nem valores pagos. Não é prova de cobertura completa do PNCP. Ano é o ano da **publicação**, não necessariamente o ano contido no número da compra.

## Integridade e procedência

- Conjunto de IDs do derivado igual ao `trusted__pncp_contratacoes.parquet` baixado, sem duplicatas.
- Hashes SHA-256 dos arquivos baixados conferidos com o manifesto do publicador e novamente após o processamento.
- Cada um dos 69 Parquets derivados tem contagem, tamanho e SHA-256 no manifesto global.
- Arquivos brutos originais não foram modificados e não são reempacotados aqui.
- `raw__pncp_contratacoes_atualizacao.parquet`: 7.719.898 versões, 3.764.907 IDs distintos. Todos esses IDs aparecem no trusted.
- **3.978 IDs aparecem somente no trusted**, sem linhagem explicada pelo raw de atualização disponível. São 2.927 dispensas, 965 inexigibilidades, 80 credenciamentos e 6 nas demais modalidades. Não se afirma que cada linha trusted foi reconstruída a partir daquele raw.
- O README atual do projeto do coletor descreve amostras e um plano de publicação; isso difere do dataset grande efetivamente baixado. Os bytes, hashes, contagens e esta ressalva ficam registrados, sem presumir equivalência entre as versões.

## Classificação: uso experimental

O classificador canônico **v6.3** foi reaplicado sem alteração. Isso **não valida** seus rótulos fora da inexigibilidade, nem equivale a uma avaliação independente de acurácia neste snapshot.

Foram encontrados erros concretos: internet **"banda larga"** recebe artístico por "banda"; obra com **"forro"** pode receber artístico; manutenção de teatro também pode gerar falso positivo. Os exemplos com ID estão em `triagem_classificador.json`.

Os **202.953 rótulos artísticos no conjunto inteiro, incluindo inexigibilidade**, são saídas da regra, não uma contagem validada de contratações artísticas. Não usar para estimar mercado sem revisar uma amostra e adaptar/testar as regras. O canônico não foi alterado. Há 44 flags de valor aproximadamente 1000x; os valores de origem não foram corrigidos.

## Privacidade: não anonimiza nomes

Foram selecionados campos necessários e excluídos usuário, informações complementares, justificativa presencial, links de processo e outros campos fora do escopo. Regex mascara padrões de CPF, e-mail, telefone e RG contextual: **16.836 ocorrências**, não necessariamente pessoas distintas.

A releitura integral não encontrou resíduos **dos mesmos padrões**. Isso não prova ausência de dados pessoais. **Nomes de pessoas e identificadores indiretos podem permanecer. Não há certificação de anonimização.** A máscara pode também ocultar números não pessoais que se parecem com os padrões. Não reidentificar nem usar este conjunto para perseguição, discriminação ou decisões sobre pessoas.

## Relação com a base original de 494.446

Este é um acervo **separado por fonte**. Não foi somado, fundido nem usado para alterar a base original de 494.446 registros de inexigibilidade. A base original não está neste repositório.

Em 2025-26 o snapshot tem 412.580 inexigibilidades. A diferença de 81.866 para a base original é diferença de contagens, **não um resultado de reconciliação por ID nem algo explicado apenas pela data**. Uma comparação do histórico próprio encontrou 280 IDs ausentes no snapshot. Manter as fontes e comparar IDs antes de deduplicar ou completar lacunas. Nenhuma janela de coleta foi declarada completa por este processamento.

## Termos e atribuição

O Kaggle informa **"Other (specified in description)"** e declara **"Source terms apply; credit the original publisher"**. Não atribuímos uma licença aberta nova aos dados de terceiros, não afirmamos que "Other" significa domínio público e não oferecemos certificação jurídica. Preserve a atribuição ao coletor e ao PNCP, a procedência e estes avisos ao reutilizar.

A descrição do Kaggle diz que o snapshot original não teve mascaramento. Este derivado tem as máscaras limitadas descritas acima.

Fontes primárias consultadas sobre dados abertos do PNCP:
- https://www.gov.br/pncp/pt-br/acesso-a-informacao/copy_of_dados-abertos
- https://www.gov.br/pncp/pt-br/central-de-conteudo/noticias/gestao-torna-dados-sobre-compras-publicas-mais-acessiveis-a-toda-sociedade

Essas páginas descrevem dados abertos e reutilização, mas não substituem a avaliação de privacidade de cada aplicação. Não há afiliação ou endosso do coletor original ou do PNCP.

## Reproduzir

Baixe o arquivo trusted diretamente do dataset original, instale `pyarrow` e execute o código do pacote fonte com Python 3.10 ou superior. Não é necessário consultar a API do PNCP.

```bash
pip install pyarrow
python processar_dump.py 9
python processar_dump.py 6 --year 2025
```

Por padrão, o script usa `./dados/trusted__pncp_contratacoes.parquet` e grava em `./dados/derivado_kaggle_v1/`. Os classificadores estão na mesma pasta do script. Execute os demais códigos/anos conforme necessário. Consulte os manifestos para comparar contagens e hashes. A divisão física de pregão e dispensa por ano reduz o tempo de cada execução; os demais códigos são processados em lote por modalidade.

## Baixar e reunir o pacote de dados

O pacote ZIP de 373 MB foi dividido em 45 partes binárias para transferência. Baixe todas as partes, o manifesto `partes_sha256.json` e o pacote de código/manifestos nos assets desta release. Os prefixos numéricos adicionados ao nome dos assets não fazem parte do conteúdo; o sufixo `part001` até `part045` identifica a ordem.

O pacote de código inclui `reunir_partes.py`, que acha cada sufixo, confere SHA-256 por parte, reúne em ordem e confere o hash do ZIP final. Na pasta com os downloads:

```bash
python reunir_partes.py
```

Depois extraia `pncp_kaggle_derivados_v1.parquet.zip` e confira os 69 Parquets contra `manifest_global.json`. Não tente abrir uma parte sozinha como ZIP.
