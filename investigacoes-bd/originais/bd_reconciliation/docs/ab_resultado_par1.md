# Resultado A/B, par 1 (2026-11-19 21:33–21:39)

## Caso novo (idêntico nas duas condições, linguagem natural, sem nomes de tabelas)
"Quanto foi o crédito rural de investimento com recurso público em 2022, rateado por município usando o Cadastro Ambiental Rural? Total geral, número de municípios, top-10."

## Condições
- **A (baseline)** thread e6d448ba-eceb-4c09-9705-dad568afe806: só o caso.
- **B (com experiência)** thread de090efe-9af0-4778-8556-a3c3eb6ef6ba: contexto emitido pelo recuperador (`retrieve_experience.py`, log em outputs/runs/2026-11-19/ab_retrieval_log.json, que selecionou t7_sicor_car_rateio score 27, único ≥10) + o mesmo caso. Zero correção manual intermediária.

## Resultados
| | A (baseline) | B (com experiência) |
|---|---|---|
| Tool calls | 21 (9 SQL) | 15 (3 SQL) |
| Erros de ferramenta | 0 | 0 |
| Total | R$ 48.292.622.454,52 | R$ 6.720.439.372,94 |
| Municípios | 5.241 | 1.273 |
| Top-1 | São Desidério-BA | Paracatu-MG |
| Método final | canônico: janela de snapshots 2026-06-02→2026-08-04 + ROW_NUMBER por imóvel; rateio igual; indicador_recurso_publico='1'; finalidade Investimento (descoberta via dicionário/empreendimento) | 5/6 armadilhas aplicadas, MAS snapshot filtrado como `data_extracao = '2026-08-04'` (só a data máxima global) |

## Veredito
**Transferência PARCIAL com erro induzido.** A experiência foi lida E alterou a ação (B declara explicitamente a aplicação; disclaimers e rateio corretos). Neste par B usou menos queries (3 vs 9); NÃO alegar 'aceleração' sem medir tempo/recursos pareados, mas a armadilha "deduplicar pelo snapshot mais recente" foi lida ao pé da letra como "usar apenas a data máxima de extração", descartando imóveis cujo último snapshot na janela não era 04/08/2026 → subcontagem de ~7× (6,72 bi vs 48,29 bi; 1.273 vs 5.241 mun). A baseline, sem experiência, convergiu sozinha para a forma do T7 validado (janela + dedup por imóvel). ATENÇÃO: o output de A NÃO é verdade independente por ser de A: antes de chamá-lo cânone do caso 2022 é preciso comprovar dedup/janela/escopo por protocolo externo (ciclo de verificação abaixo).

Leituras honestas:
1. A experiência reduziu o número de queries neste par (sem medir tempo/recursos) e transferiu disclaimers/estrutura, MAS ancorou uma interpretação literal errada no ponto mais sutil do método.
2. Transferência PRÓXIMA (mesma família de tabelas/método), não generalização. Um par não demonstra seleção geral nem motor.
3. O filtro de finalidade (investimento), ausente do registro, foi descoberto corretamente pelas DUAS condições: o registro não substituiu exploração onde não cobria, e isso funcionou.
4. Não houve recuperação de erro porque não houve erro de ferramenta: o erro de B é semântico e silencioso. Sem o cânone externo (A), o erro passaria despercebido. Lição para a app: experiência injetada precisa de verificação independente quando o passo tem leitura ambígua.

## Etapa de atualização do ciclo (obrigatória)
Armadilha 3 do registro T7 REFINADA (não rejeitada): "para CADA imóvel, usar seu snapshot mais recente DENTRO da janela disponível (ROW_NUMBER por imóvel); NÃO filtrar a tabela inteira pela data máxima global". Registrado em experiencias/t7_sicor_car_rateio.json → campo resultado_transferencia.

## Instrumentação
Corpus completo (eventos, SQL verbatim, tool calls): export integral NÃO incluído neste pacote; as conversas originais estão nas URLs das threads A e B acima. SQL finais comparados linha a linha: A usou CONCAT(SUBSTR...) para reformatar id_car (equivalente funcional); B usou UPPER(REPLACE) do registro.


## Diagnóstico SQL complementar do output de A (na mesma thread A; NÃO é auditoria independente)
Critério de verificação: comparar outputs SQL/cobertura com protocolo; executado como diagnóstico SQL complementar na mesma thread (limitação: mesmo executor, mesma sessão; não é verificação independente; a declaração do chatbot de que 'não estava errado' não prova nada, o que vale são as contagens reproduzíveis) e comprovar dedup/janela/escopo do caso 2022 antes de chamar cânone. Ciclo enviado à thread A em 21:41 com 3 verificações: (1) equivalência entre a reformatação CONCAT(SUBSTR) de A e a normalização UPPER(REPLACE) do T7 (contagens e interseção de imóveis ligados); (2) cobertura de snapshots: quantos CARs ligados sob janela+dedup vs só-data-máxima (isso prova/quantifica o descarte de B); (3) escopo: total conectado vs total investimento público 2022 sem CAR (fração de conexão). Resultado (thread A, resposta 2026-11-20T00:41:34Z, 1 query de verificacao composta):
1. NORMALIZACAO: CONCAT(SUBSTR) de A e UPPER(REPLACE) do T7 ligam EXATAMENTE os mesmos 489.138 id_car distintos (0 exclusivos de cada lado; 7 sem ligacao por ambos). Equivalencia comprovada.
2. SNAPSHOTS: janela+dedup liga 489.138 imoveis; so-data-maxima liga 110.816 -> 378.322 descartados (77,3%). Erro de B quantificado por consulta comparativa direta dos dois criterios de snapshot.
3. ESCOPO: total investimento publico 2022 SEM exigir CAR = R$ 52.421.687.317,99; conectado = R$ 48.292.622.454,52 = 92,12% de cobertura de conexao. Escopo sensato.
CONCLUSAO: output de A consistente nos 3 eixos por diagnostico complementar reproduzivel (mesma thread; auditoria verdadeiramente independente segue aberta). Numeros canonicos do caso 2022: total investimento publico R$ 52,42 bi; conectado ao CAR R$ 48,29 bi (92,12%), 5.241 municipios, 489.138 imoveis ligados. O chatbot declarou explicitamente: 'o resultado anterior nao estava errado'.
