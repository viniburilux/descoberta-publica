# Diagnostico de relacionamento: PRODES x MapBiomas - desmatamento x cobertura e uso da terra

- Relacionamento: `prodes_mapbiomas`
- Bases: `basedosdados.br_inpe_prodes.municipio_bioma` x `basedosdados.br_mapbiomas_estatisticas.cobertura_municipio_classe`
- Chaves: CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING)) = CONCAT(id_municipio, '|', bioma, '|', CAST(ano AS STRING))
- Fonte dos numeros: execucao original registrada (BD chatbot T6 (c3e3f115) 2026-11-19 06:40 - execucao original registrada em bd_clean_6.txt)
- Gerado em: 2026-11-22 por report.py (metricas recomputadas das contagens)

## Resultados

| chaves PRODES | 6.536 |
| com MapBiomas | 6.437 |
| sem MapBiomas | 99 |
| cobertura | 98,49% |

## Regresso (metrica recomputada vs destaque registrado)

| Check | Calculado | Registrado | OK |
|---|---:|---:|:--:|
| cobertura_chaves | 98.4853 | 98.49 | SIM |

## Problemas conhecidos

- 99 chaves PRODES sem correspondencia MapBiomas em 2023 (1,51%) - investigar se sao municipio-bioma sem area de cobertura ou defasagem de recorte
- MapBiomas repete a chave composta por classe de cobertura: agregacao por classe necessaria antes de joins 1:1

Status de validacao: **validado_execucao_registrada** (numeros da execucao original; nova execucao via executor BD pendente).
