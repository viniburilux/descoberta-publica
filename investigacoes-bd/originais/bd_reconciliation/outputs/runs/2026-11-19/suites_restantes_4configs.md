# Execução real das suites 01/02/03/05/06, 4 configs (2026-11-19 21:48–21:58)

Thread: https://basedosdados.org/chatbot?t=23340b3d-36ca-478c-8a85-7b3db0ed4e3d
Corpus: export integral da thread NÃO incluído neste pacote (conversa original na URL acima). Todas verbatim, zero falhas, query_refs abaixo.
Escopo: cada resultado vale para as partições/filtros do SQL da suite; não generalizar além.
Correções de interpretação (revisão 22:01, verificadas contra config/SQL antes de catalogar):
- Suite 06_estrutura existe só em sicor_car porque só essa config define structural_checks (chave CAR com UF/município embutidos). Para rais_cnae, ibama e prodes: 06 = NA JUSTIFICADO (não aplicável a chaves sem campos embutidos), NÃO "não testado". Cobertura por config: sicor_car 6/6; demais 5/5 aplicáveis.
- IBAMA: direção conferida no config: left=auto_infracao (711.140 AUTOS), right=area_embargada (116.332 TERMOS DE EMBARGO). Os 610.001 resíduos são AUTOS SEM TERMO de embargo correspondente (não "embargos sem auto", como rotulado antes, corrigido). Reconciliação: 711.140 - 6.651 vazias - 610.001 sem correspondência = 94.488 ≈ 94.489 autos ligados (suite 03).
- SICOR denominadores: DISCREPÂNCIA DE 1 ABERTA: suite 02 conta DISTINCT id_car bruto (1.687.256); suites 03/05 usam chave normalizada distinta: 1.683.985 ligadas + 3.272 resíduos = 1.687.257, um a mais que o bruto. Hipótese NÃO demonstrada: bucket de chave vazia ou efeito de unidades mistas (linhas vs IDs distintos). Normalização determinística na mesma amostra não deveria aumentar cardinalidade, então a explicação exige SQL comparando mesmas partições/normalização/filtros com COUNT DISTINCT vs COUNT de linhas. Catálogo registra as contagens em seus escopos originais + discrepância de 1 em aberto, sem harmonização forçada.
- PRODES/MapBiomas: right = cobertura_municipio_classe (uma linha por CLASSE de cobertura por município|bioma|ano, cardinalidade um-para-muitos declarada no config). As 70.931 "repetições" são classes por chave composta, NÃO pixels; grão real = município×bioma×ano×classe.

## sicor_car (5 suites; 06_estrutura só existe nesta config)
- 01_chaves_nulas (qr_36fb3322): left 5.744.472 regs / 195.171 chave vazia; right 8.484.586 / 0.
- 02_duplicidade (qr_48fac946): left 1.687.256 chaves distintas (4.057.216 repetidas, várias operações por imóvel, esperado); right 8.467.886 distintas / 16.700 repetidas.
- 03_transformacoes (qr_78b5e2b7): literal = 0 correspondências; normalizado = 5.543.885 registros / 1.683.985 ids. Transformação confirmada.
- 05_residuos (qr_8dfa9a59): 3.272 ids left sem correspondência.
- 06_estrutura (qr_da8da48b): 5.456 linhas (comprimento × UF × município embutido); 195.171 sem comprimento (chaves nulas); demais comprimento 41 com UF/município coerentes. Resultado completo server-side (1.000 exibidas).

## rais_cnae (4 suites)
- 01 (qr_69ef908a): left 11.768.420 / 0 vazia; right 1.356 / 0.
- 02 (qr_633ce0ad): left 1.339 chaves distintas; right 1.356 distintas / 0 repetidas.
- 03 (qr_6e7209ab): literal liga 11.760.468 registros / 1.337 ids.
- 05 (qr_fa03d0d1): 2 ids sem correspondência.

## ibama_autos_embargos (4 suites)
- 01 (qr_4effff19): left 711.140 / 6.651 vazias; right 116.332 / 19.979 vazias.
- 02 (qr_175fba61): left 704.489 distintas; right 94.546 distintas / 21.786 repetidas.
- 03 (qr_802c6540): literal liga 94.489.
- 05 (qr_6006e2b6): 610.001 ids left sem correspondência = autos sem termo de embargo correspondente (direção conferida no config; corrigido após revisão 22:01).

## prodes_mapbiomas (4 suites)
- 01 (qr_b0d09c71): left 6.536 / 0; right 77.405 / 0.
- 02 (qr_a465abf2): left 6.536 distintas / 0 repetidas; right 6.474 chaves distintas (município|bioma|ano) / 70.931 linhas a mais = classes de cobertura por chave (um-para-muitos esperado, não pixels).
- 03 (qr_dca944b3): literal liga 6.437.
- 05 (qr_c631b6d1): 99 ids sem correspondência.

Consistência cruzada com a suite 04 já validada: RAIS 11.768.420/1.339/1.337 e PRODES 6.536/6.437/99 batem com os canônicos; IBAMA right 116.332/19.979 batem.
