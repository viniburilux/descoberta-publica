# MapBiomas Colecao 11 (1985-2025) — cobertura/uso por municipio (ha)
Fonte: Base dos Dados, dataset br_mapbiomas_estatisticas, via chatbot (thread nova, 20/11/2026 ~02h04 -03): https://basedosdados.org/chatbot?t=430dfb1d-63f9-4901-b181-963177941355
Anos pedidos: 2017, 2020 e mais recente disponivel = 2025. Totais MUNICIPAIS (nao sao os poligonos dos CARs/TADs).

## Rondon do Para (1506187) — bioma: Amazonia
| classe (n2) | 2017 | 2020 | 2025 |
|---|---|---|---|
| Formacao Florestal | 420.153,87 | 406.620,61 | 360.506,30 |
| Floresta Alagavel | 3.462,27 | 3.432,58 | 3.280,02 |
| Pastagem | 336.520,75 | 334.469,85 | 341.281,57 |
| Agricultura | 33.023,41 | 42.809,33 | 62.225,81 |
| Mosaico de Usos | 24.227,68 | 30.104,76 | 51.613,96 |
| Silvicultura | 2.176,45 | 2.081,60 | 1.134,61 |
| Formacao Campestre | 2.778,00 | 2.821,22 | 2.276,70 |
| Outros | ~4.600 | ~4.500 | ~4.700 |
Leitura: Formacao Florestal -59.648 ha 2017-2025 (-14,2%), concentrada 2020-2025 (-46.114 ha); Agricultura +88% e Mosaico +113% no periodo; Pastagem ~estavel.

## Sao Felix do Coribe (2929057) — bioma na tabela: Caatinga (*)
| classe (n2) | 2017 | 2020 | 2025 |
|---|---|---|---|
| Formacao Savanica | 105.630,36 | 105.584,21 | 97.394,52 |
| Formacao Florestal | 18.967,02 | 18.756,74 | 17.845,77 |
| Pastagem | 39.793,97 | 39.482,92 | 45.633,41 |
| Agricultura | 3.499,52 | 3.469,50 | 4.089,22 |
| Mosaico de Usos | 123,67 | 670,26 | 2.972,13 |
| Afloramento Rochoso | 6.534,70 | 6.536,53 | 6.592,27 |
| Outros | ~640 | ~730 | ~1.050 |
Leitura: Savanica -8.236 ha (-7,8%) 2017-2025, queda toda 2020-2025; Pastagem +14,7%.

(*) QUESTAO DE DADO ABERTA: a tabela rotula o bioma do municipio como "Caatinga", mas a classe dominante e Formacao Savanica (fisionomia de Cerrado) e o IBGE C04_bioma_2010 classifica a area como Cerrado (verificado com controles na run anterior). Compativel com a observacao anterior de que o produto PRODES Caatinga cobre a regiao do assentamento enquanto o PRODES Cerrado nao tem feicoes la. Hipoteses: recorte de bioma usado pelo MapBiomas/BD difere do IBGE; ou erro de rotulo na tabela. Nao resolvido.

## Cautelas de interpretacao
- Totais municipais: a perda florestal municipal de Rondon ocorre em algum lugar do municipio; PRODES-AMZ mostra zero corte raso de primaria DENTRO dos CARs A/B 2016-2025 (ver prodes_amz_carA/B.json). As duas fontes nao se contradizem.
- Mudancas de classe entre anos podem refletir revisoes metodologicas da colecao, nao so mudanca real; checar notas da Colecao 11 antes de quantificar taxas.
- "Mosaico de Usos" (n2) agrega usos mistos; nao equivale a agricultura.

[RETIRADA 20/11/2026 02h58] A afirmação "PRODES-AMZ mostra zero corte raso de primária DENTRO do ..." depende de consulta RETIRADA: requisição literal não preservada, ordem de eixos não reproduzível. Todo resultado PRODES anterior a 02h53 de 20/11 está invalidado; reconsulta pendente com método documentado em testes_espaciais_terrabrasilis_20261120.txt (Drive). 502 do servidor é pendência, não zero.
