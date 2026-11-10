# Metodologia e diferenças entre as fontes

Detalhes técnicos preservados na reorganização do README em 10/11/2026. Integridade de arquivo e procedência não significam investigação ou confirmação de cada contratação.

## Fonte adicional: snapshot PNCP do Kaggle

A Descoberta Pública também oferece um processamento separado do snapshot publicado por **Lucas Rangel S. Souza**: [dataset no Kaggle](https://www.kaggle.com/datasets/lucasrangelss/pncp-raw-trusted-part-1) e [projeto do coletor](https://github.com/LucasRangelSSouza/brazil-public-data-map). O mérito da coleta é dele; a fonte primária é o PNCP.

São **3.768.885 contratações únicas, 18 modalidades presentes, 69 Parquets por modalidade/ano**, snapshot declarado de 30/09/2026. Código, manifestos e pacote de dados ficam em [Releases](https://github.com/viniburilux/descoberta-publica/releases); metodologia em `fontes/kaggle_pncp/`. É uma fonte adicional, **não uma soma nem substituição da base original de 494.446**, que continua distinta e intacta. Não prova cobertura completa.

- Classificador v6.3 reaplicado, **não validado nas outras modalidades**. Erros documentados: internet "banda larga", obra com "forro" e manutenção de teatro podem virar artístico. Os 202.953 rótulos artísticos do conjunto inteiro incluem inexigibilidade e não são uma estimativa validada de mercado.
- Mascaramento por padrões: 16.836 ocorrências de CPF-like/e-mail/telefone/RG. **Não anonimiza nomes** nem garante remoção de todo dado pessoal. Não foi o mesmo código de privacidade da edição v0.1.2.
- **3.978 IDs do trusted não têm linhagem explicada pelo raw de atualização disponível**. Uma comparação histórica encontrou 280 IDs próprios ausentes no snapshot. Não fundir contagens sem reconciliação por ID.
- **Exceção às licenças gerais deste repositório:** este dataset de terceiro informa "Other (specified in description)" e "Source terms apply; credit the original publisher". Não o relicenciamos como CC BY 4.0; preserve crédito ao coletor e ao PNCP, procedência e avisos. Sem endosso/afiliação e sem certificação jurídica ou de anonimato.


## Antes de usar, saiba

- **O recorte é por data de publicação no PNCP, não pelo ano do ato.** A base inclui compras de anos anteriores publicadas nesse período: entre os registros publicados em 2025–2026 há compras de 2022 a 2026 pelo ano da compra.
- **Valor estimado e valor homologado não são valor pago.** São campos do registro público, preservados como vieram da fonte - inclusive os visivelmente inconsistentes.
- **Nomes de fornecedores, órgãos e municípios são a substância pública dos atos** e foram mantidos. Identificadores pessoais que os órgãos escreveram no texto livre (CPF, RG, e-mail pessoal, endereço residencial) foram mascarados nesta edição; famílias beneficiárias de programas sociais tiveram os nomes removidos. Não é anonimização: os registros de origem seguem públicos no PNCP.
- Leia `docs/LIMITACOES.md` antes de reutilizar. A classificação derivada é material de exploração, não conclusão nem acusação.


## Origem, integridade e licenças

- **Fontes:** PNCP (API de dados abertos, sem cadastro), Siconfi/Tesouro Nacional, IBGE. Os registros são dados públicos governamentais; este pacote não concede nem restringe direitos sobre eles.
- **Integridade:** 621 arquivos brutos com SHA256 conferido (100%); contagens por UF/ano verificadas após cada transformação; hashes desta edição em `manifest_v012.json`.
- **Licenças:** código sob MIT (`LICENSE-CODE`); curadoria, documentação e derivados sob CC BY 4.0 (`LICENSE-DATA`). Atribuição: "Vinícius Buri Lux (LuxVerso), Descoberta Pública - Inexigibilidades publicadas no PNCP, v0.1.2".

Origem da iniciativa: [LuxVerso](https://github.com/viniburilux/LuxVerso).


## Escopo dos números e da classificação

Os 621 arquivos e seus hashes citados acima dizem respeito à edição original v0.1.2, não à fonte adicional. Os 3.768.885 registros do snapshot Kaggle foram mantidos como fonte separada; não somar aos 494.446 registros da edição original sem reconciliação por ID.

Os 202.953 rótulos artísticos do snapshot incluem 148.590 de inexigibilidade e 54.363 das outras modalidades. São saídas da regra, não uma estimativa validada de mercado. A reaplicação do v6.3 não equivale a uma avaliação independente de acurácia nesse conjunto.

O mascaramento novo não usa o mesmo código de privacidade da v0.1.2. Não se afirma equivalência de proteção: padrões de CPF-like, e-mail, telefone e RG contextual foram mascarados; nomes e identificadores indiretos podem permanecer. A releitura com os mesmos padrões não prova ausência de dados pessoais.

## Linhagem e cobertura do snapshot adicional

Todos os 3.764.907 IDs distintos do raw de atualização aparecem no trusted. Há 3.978 IDs apenas no trusted cuja linhagem não é explicada pelo raw disponível: 2.927 dispensas, 965 inexigibilidades, 80 credenciamentos e seis nas demais modalidades. Essa lacuna está registrada e não foi tratada como resolvida.

Em 2025-26 o snapshot contém 412.580 inexigibilidades. A diferença de 81.866 para a base original é diferença de contagens, não um join por ID nem algo explicado somente pelo corte temporal. No histórico próprio comparado, 280 IDs não apareceram no snapshot. Nenhuma janela de coleta foi declarada completa por este processamento.

O snapshot declarado é de 30/09/2026. A data de publicação organiza as partições, não o ano do ato. Valores e flags de inconsistência preservam os campos da fonte; uma flag não corrige um valor nem prova irregularidade.

## Termos por fonte

As licenças MIT e CC BY 4.0 da edição original não relicenciam o dataset de terceiro. No Kaggle constam "Other (specified in description)" e "Source terms apply; credit the original publisher". Preserve a atribuição ao coletor Lucas Rangel S. Souza e ao PNCP. Não há afiliação ou endosso do coletor ou do PNCP, nem certificação jurídica ou de anonimização.

Consulte os manifestos, exemplos de erro e método completo em [fontes/kaggle_pncp](../fontes/kaggle_pncp/) e as [limitações da edição original](LIMITACOES.md).
