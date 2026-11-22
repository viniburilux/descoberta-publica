# Diagnostico de relacionamento: SICOR x CAR - credito rural x imovel rural cadastrado

- Relacionamento: `sicor_car`
- Bases: `basedosdados.br_bcb_sicor.recurso_publico_propriedade` x `basedosdados.br_sfb_sicar.area_imovel`
- Chaves: id_car = id_imovel
- Fonte dos numeros: execucao original registrada (BD chatbot T6 (c3e3f115) 2026-11-19 06:57 - execucao original via execute_bigquery_sql, registrada em bd_clean_6.txt)
- Gerado em: 2026-11-19 por report.py (metricas recomputadas das contagens)

## Resultados

| 2019 | 1.680.904 | 1.680.881 | 23 | 100,00% |
| 2023 | 2.028.517 | 2.028.504 | 13 | 100,00% |
| 2026 | 1.839.880 | 1.834.500 | 5.380 | 99,71% |

Residuo: 3.258 ids sem correspondencia, 3258 em municipios com outros CARs, 0 em municipio sem CAR.

## Regresso (metrica recomputada vs destaque registrado)

| Check | Calculado | Registrado | OK |
|---|---:|---:|:--:|
| cobertura_registros_2019 | 99.9986 | 99.999 | SIM |
| cobertura_registros_2023 | 99.9994 | 99.999 | SIM |
| cobertura_registros_2026 | 99.7076 | 99.708 | SIM |

## Problemas conhecidos

- Formato da chave diverge entre as bases (hifens): join literal retorna zero
- Snapshots CAR sao por UF em datas distintas: um snapshot unico cobre parcialmente (2026: 389.263/1.839.880 registros)
- 3.258 ids de 2026 sem correspondencia estao todos em municipios que possuem outros CARs - hipotese de defasagem temporal do snapshot ou baixa do imovel, nao ausencia de CAR no municipio
- id_car de anos anteriores a 2019 e praticamente vazio: recorte temporal e obrigatorio

Status de validacao: **validado_execucao_registrada** (numeros da execucao original; nova execucao via executor BD pendente).
