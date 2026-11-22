# BD-003: Infraestrutura da BD, emendas × internações e o limite do CPF mascarado

- **Tema:** reconhecimento sistemático da infraestrutura da BD com níveis de evidência, e os primeiros testes analíticos.
- **Quando:** 18/11/2026, no chatbot da BD.
- **Pergunta:** como a BD está organizada (catálogo, tabelas, chaves) e o que um primeiro teste real mostra?
- **Como foi feito:** relatório de reconhecimento em três níveis (documentado, inferência, desconhecido) e testes SQL executados pelo chatbot, com a trilha de erros e correções visível.
- **Resultados:**
  - Mapa da infraestrutura da BD.
  - Teste emendas parlamentares × internações em saúde: correlação de Pearson de -0,0085. Resultado nulo, registrado como achado.
  - Tentativa de cruzar doadores de campanha → QSA → CNPJ → contratos bloqueada por CPF mascarado, com 3 rotas alternativas levantadas e não testadas.
- **O que aprendemos:** resultado nulo é resultado, e os limites de cruzamento impostos por dados mascarados são documentáveis. Essa trilha real de 85 consultas, com sucessos e falhas, virou insumo de avaliação.
- **Desdobramento:** a mesma sondagem foi rodada em 5 modelos de IA na noite de 18/11 (chatbot da BD, Qwen, ChatGPT, Gemini e Grok), com protocolo comparativo desenhado. É o embrião de um benchmark de Text-to-SQL sobre catálogo público, o candidato científico mais maduro do acervo: os dados primários já estão coletados, falta compor.
- **Maturidade:** Investigação (2 de 6).
- **Rastreio:** conversa no chatbot da BD em 18/11/2026.

## Saída pronta: esqueleto de artigo (benchmark)

- Pergunta: qual modelo de IA responde melhor perguntas reais sobre um catálogo público de dados?
- Protocolo: a mesma bateria de reconhecimento e consultas rodada em 5 modelos (chatbot da BD, Qwen, ChatGPT, Gemini e Grok) na noite de 18/11/2026, com trilha de sucessos e falhas registrada (85 consultas na sessão principal).
- Material: dados primários já coletados; falta compor a tabela comparativa e redigir.
