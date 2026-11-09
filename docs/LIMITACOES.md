# Limitações

Leia antes de reutilizar. Estas são as fronteiras reais do pacote.

## Recorte

- **Só modalidade 9 (Inexigibilidade).** Não representa as contratações públicas do país, nem outras modalidades do próprio PNCP.
- **Eixo é data de publicação**, não data do ato nem do contrato. Registros publicados em 2025 incluem atos de outros anos (`ano_compra` diverge em milhares de casos) e 16 registros têm anos inválidos óbvios (ex.: 20252025), preservados como vieram.

## Janela

- 2025: presença de registros nas 27 UFs × 12 meses (`cobertura_uf_mes.csv`). Presença não comprova integralidade contra o total do portal.
- 2026: parcial. Janeiro a 21 de agosto (até 21/08 inclusive); **o período de 22 a 31 de agosto não está na base**; setembro, outubro e 01–06 de novembro como complemento; sem dezembro. Não compare totais de 2025 e 2026 como dois anos completos.
- Contra-checagem pontual contra a consulta nacional da API em 06/11/2026 encontrou divergências pequenas (setembro −1, novembro −28) de origem não estabelecida. A coleta não é atômica e o portal muda com o tempo.

## Valores

- `valor_estimado` e `valor_homologado` são campos de publicação. **Não são valor pago, gasto executado ou transferência.**
- Valores originais preservados, inclusive inconsistências extremas (há registros com "trilhões" no estimado). Não normalizamos por palpite.
- Situação do registro inclui "Anulada", "Revogada" e "Suspensa" (2.753 registros) — verifique `situacao` antes de somar.

## Dimensão municipal

- Razão contra receita só faz sentido em esfera municipal; município de uma unidade federal/estadual é localização, não prova de despesa municipal.
- RCL válida em 3.216 entes; DCA em 2.318. Cruzar estimado com receita mistura conceitos e anos — é escala contextual, não parcela de orçamento.
- População da dimensão canônica é a estimada para 2025 (SIDRA 6579).

## Derivados

- A classificação por categorias é heurística, com classes de erro conhecidas e documentadas. Fidelidade de 87,8% a rótulos anteriores na base BA (28.306) não é precisão nacional.
- Agregados do derivado aplicam exclusões documentadas de valores inconsistentes (ver `derivados/README_CATEGORIZACAO.md`); os registros originais permanecem intactos em `dados/`.
