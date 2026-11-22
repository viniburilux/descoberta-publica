# Diagnostico de relacionamento: RAIS x Diretorio CNAE 2 - estabelecimentos x classificacao de atividades

- Relacionamento: `rais_cnae`
- Bases: `basedosdados.br_me_rais.microdados_estabelecimentos` x `basedosdados.br_bd_diretorios_brasil.cnae_2`
- Chaves: cnae_2_subclasse = subclasse
- Fonte dos numeros: execucao original registrada (BD chatbot T6 (c3e3f115) 2026-11-19 06:40 - execucao original registrada em bd_clean_6.txt)
- Gerado em: 2026-11-22 por report.py (metricas recomputadas das contagens)

## Resultados

| subclasses RAIS | 1.339 |
| com correspondencia | 1.337 |
| cobertura subclasses | 99,85% |
| registros RAIS | 11.768.420 |
| registros com CNAE | 11.760.468 |
| cobertura registros | 99,93% |
| sem correspondencia: 8630505 | 1.253 registros |
| sem correspondencia: 9999999 | 6.699 registros |

## Regresso (metrica recomputada vs destaque registrado)

| Check | Calculado | Registrado | OK |
|---|---:|---:|:--:|
| cobertura_subclasses | 99.8506 | 99.85 | SIM |
| cobertura_registros | 99.9324 | 99.93 | SIM |

## Problemas conhecidos

- 2 subclasses RAIS sem correspondencia no diretorio consultado: 8630505 e 9999999 (esta concentra 6.699 registros e parece codigo de preenchimento, nao atividade)
- Relacao muitos-para-um: joins precisam respeitar a cardinalidade para nao multiplicar registros

Status de validacao: **validado_execucao_registrada** (numeros da execucao original; nova execucao via executor BD pendente).
