# Validação real da suite gerada: execução ao vivo no chatbot BD

Data: 2026-11-19 23:51–23:57 UTC (~20h51–20h57 America/Bahia).
Executor: chatbot da Base dos Dados (conta do projeto, plano custo zero verificado).
Thread de evidência: https://basedosdados.org/chatbot?t=5d4bd8d9-338c-4330-9ea0-74230674b27a
Método: SQL gerado pelo componente (reconcile.py, suite 04_cobertura) enviado verbatim com instrução de executar sem alterar a lógica.

## Prova de execução (não narrativa)

Para cada caso, o transcript da thread registra o evento `tool_call execute_bigquery_sql` com o SQL efetivamente executado (comparado: idêntico ao enviado, salvo espaços em branco) e o `tool_output` com as linhas brutas do resultado, query_ref e slug de artifact. Escopo DESTA rodada (23:51-23:57): **apenas a suite 04 (cobertura)**, nas partições indicadas. As suites 01/02/03/05/06 já haviam sido executadas ao vivo em 19/11 21:48-21:58 (thread 23340b3d; ver suites_restantes_4configs.md) e não foram repetidas aqui.

| Caso (slug) | query_ref | Executado em (UTC) | Linhas |
|---|---|---|---|
| validacao_interoperabilidade_prodes_mapbiomas | qr_a98d50fbca4b42f098e1cea8a1c19fe2 | 2026-11-19T23:51:17Z | 1 |
| validacao_rais_cnae_2023 | qr_254f1cba82c64e80a5025f16808a756e | 2026-11-19T23:52:06Z | 1 |
| validacao_embargos_autos | qr_944d51b839eb4cf29158105df146df19 | 2026-11-19T23:52:42Z | 1 |
| validacao_sicor_car | qr_fe80786656034c5bbb8129f8dbad1337 | 2026-11-19T23:53:48Z | 3 |

## Resultados brutos retornados

- **prodes_mapbiomas**: ano=2023, registros_left=6.536, chaves_distintas_left=6.536, correspondentes=6.437, sem_correspondencia=99. Registrado: 6.536/6.437/99 (98,49%). CONFIRMADO.
- **rais_cnae**: ano=2023, registros_left=11.768.420, subclasses_distintas=1.339, subclasses_correspondentes=1.337, registros_correspondentes=11.760.468, sem=7.952. Registrado: idem (99,93%). CONFIRMADO.
- **ibama_autos_embargos**: embargos=116.332, id_auto_vazio=19.979, com_auto=96.293, sem_auto=60, autos_distintos_referenciados=94.546. Registrado: idem (82,77% total; 99,94% dos preenchidos). CONFIRMADO + correção de rótulo (achado 3).
- **sicor_car**: 2019: 1.680.904/770.165 ids/1.680.881 corr./23 sem; 2023: 2.028.517/927.784/2.028.504/13; 2026: 1.839.880/812.394/1.834.500/5.380. Registrado: idem. CONFIRMADO nas 3 partições.

## Checagem de suporte executada (query_ref qr_5e759c0c83ee4cb4aca1c733e58fc006, slug snapshots_sicar_area_imovel)

`SELECT data_extracao, COUNT(*) FROM basedosdados.br_sfb_sicar.area_imovel GROUP BY 1 ORDER BY 1` → exatamente 5 snapshots na tabela hoje: 2026-06-02 (468.571), 2026-08-01 (2.254.420), 2026-08-02 (2.819.155), 2026-08-03 (1.154.162), 2026-08-04 (1.788.278). A afirmação "a tabela só contém esses 5 snapshots" agora é fato consultado, não inferência da equivalência de contagens.

## Achados da execução real (realimentam o componente)

1. **Bug de chave composta**: config prodes gerava `id_municipio + bioma + ano` (type error BigQuery). Corrigido para `CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING))`; o SQL corrigido foi o validado ao vivo.
2. **Denominador honesto**: suite 04 não excluía chaves vazias do lado esquerdo. Gerador corrigido (`nonempty_key_predicate`) antes da validação SICOR×CAR.
3. **Correção de interpretação IBAMA**: preenchidos SEM auto correspondente = 60; 20.039 = 19.979 vazios + 60. Registro corrigido com nota de composição.
4. **Dedup integral ≡ união de snapshots (SICOR×CAR)**: verificado por execução (mesmos números) e agora com suporte confirmado (tabela só tem os 5 snapshots). Documentado como decisão de integração com efeito nulo NESTE caso; verificar cobertura temporal da tabela antes de generalizar.

## Limites declarados

- Escopo desta rodada: suite 04 apenas. Demais suites: executadas ao vivo em 21:48-21:58 (ver suites_restantes_4configs.md), não repetidas nesta rodada.
- O chatbot executou o SQL fornecido verbatim; geração autônoma de SQL equivalente pelo chatbot (condição A do A/B da missão 3) não foi testada nesta rodada.
