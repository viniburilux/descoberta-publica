# BD-008: Executor de reconciliação (cânone 2023)

- **Tema:** execução oficial das consultas de reconciliação no chatbot da BD para fechar o número defensável de BD-007.
- **Quando:** 19 a 20/11/2026.
- **Pergunta:** qual é o número fechado e defensável do crédito rural com recurso público em 2023, por município?
- **Como foi feito:** consultas no executor oficial da BD; decisões de método explícitas (valor em valor_parcela_credito; snapshot mais recente por imóvel; rateio igual entre imóveis); resolução da fonte 0911 como FNDCT (zero operações em 2023); download do CSV pelo endpoint de exports do próprio chatbot.
- **Resultados:** cânone de R$ 112.125.325.594,22 em 5.380 municípios (92,56% do subtotal classificado). Caso 2022 (finalidade investimento): R$ 48,29 bi conectados de R$ 52,42 bi (92,12%), 5.241 municípios, 489.138 imóveis.
- **O que aprendemos:** o ciclo descoberta → reconciliação é o que transforma um número vistoso de funil em um número defensável, com a divergência explicada.
- **Hipóteses abertas:** as validações em contexto separado convergiram para o mesmo método, mas não são auditoria independente.
- **Maturidade:** Reprodução (3 de 6).
- **Rastreio:** query_refs qr_0ef8fb01, qr_ceaa9c22 e qr_8a918dd1.

## Material

A consulta verificada (caso 2022, investimento) está em [consultas/credito_rural_por_municipio.sql](../consultas/credito_rural_por_municipio.sql) e no dossiê, com a validação em três passos: baseline em contexto separado, erro de snapshot quantificado e reparo confirmado ao centavo.
