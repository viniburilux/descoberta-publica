# Diagnostico de relacionamento: Autos de infracao x areas embargadas (IBAMA)

- Relacionamento: `ibama_autos_embargos`
- Bases: `basedosdados.br_ibama_fiscalizacao.auto_infracao` x `basedosdados.br_ibama_fiscalizacao.area_embargada`
- Chaves: id_auto = id_auto
- Fonte dos numeros: execucao original registrada (BD chatbot T6 (c3e3f115) 2026-11-19 06:37-06:40 - execucao original registrada em bd_clean_6.txt)
- Gerado em: 2026-11-19 por report.py (metricas recomputadas das contagens)

## Resultados

| embargos (registros) | 116.332 |
| com id_auto nulo | 19.979 |
| com auto correspondente | 96.293 |
| cobertura sobre termos preenchidos | 99,94% |
| cobertura sobre todos os registros | 82,77% |
| autos com ao menos um embargo | 94.489 |

## Regresso (metrica recomputada vs destaque registrado)

| Check | Calculado | Registrado | OK |
|---|---:|---:|:--:|
| cobertura_termos_preenchidos | 99.9377 | 99.94 | SIM |
| cobertura_todos_registros | 82.7743 | 82.77 | SIM |

## Problemas conhecidos

- Duas leituras de cobertura com denominadores distintos: 99,94% dos termos com id_auto preenchido (96.293/96.353) versus 82,77% de todos os registros de embargo (96.293/116.332). Registrar sempre o denominador.
- 19.979 registros de embargo com id_auto nulo (17,2% do total) limitam joins por identificador; caminho alternativo pode ser municipio+data, nao testado
- Cardinalidade um-para-muitos: um auto pode gerar varios embargos

Status de validacao: **validado_execucao_registrada** (numeros da execucao original; nova execucao via executor BD pendente).
