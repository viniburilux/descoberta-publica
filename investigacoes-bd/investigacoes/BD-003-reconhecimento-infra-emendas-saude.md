# BD-003: Infraestrutura, emendas e internações
- **Tema:** reconhecimento sistemático da infraestrutura da BD com níveis de evidência, e os primeiros testes analíticos.
- **Quando:** 18/11/2026, no chatbot da BD.
- **Pergunta:** como a BD está organizada (catálogo, tabelas, chaves) e o que um primeiro teste real mostra?
- **Como foi feito:** relatório de reconhecimento em três níveis (documentado, inferência, desconhecido) e testes SQL executados pelo chatbot, com a trilha de erros e correções visível.
- **Resultados:**
  - Mapa da infraestrutura da BD.
  - Teste emendas parlamentares × internações em saúde: correlação de Pearson de -0,0085. Resultado nulo, registrado como achado.
  - Tentativa de cruzar doadores de campanha → QSA → CNPJ → contratos bloqueada por CPF mascarado, com 3 rotas alternativas levantadas e não testadas.
- **Rastreio:** conversa no chatbot da BD em 18/11/2026.

## Sequência da investigação

Reconhecimento da infraestrutura → teste emendas × internações → Pearson -0,0085 → exploração das chaves para outros cruzamentos.

## A. Material bruto recuperado

A recuperação da conversa completa e dos exports desta frente está em andamento.

Último vestígio da sessão: `4bbb1362-4dfb-47c1-a70a-61886d7a151b`, chatbot da BD.

## B. Consultas e código

SQL e chamadas da sessão ainda não recuperados como arquivos nesta frente.

## C. Resultados e arquivos

Resultados ainda registrados na ficha e no vestígio da sessão; os exports correspondentes aguardam recuperação.

## D. Reprodutibilidade

Aguardando os arquivos da sessão para executar a reprodução.

## E. Destinos possíveis

Artigo e protocolo de benchmark Text-to-SQL; relato técnico do teste emendas × internações.

## F. Pendências e próximo passo

Recuperar o log da sessão e os materiais dos cinco modelos; montar a tabela de consultas, erros, correções e resultados.

Pendente: integrar a conversa completa com suas perguntas, respostas e chamadas originais.

## G. Pacote de trabalho

[Todos os materiais desta frente](#c-resultados-e-arquivos) · [Painel das 12 investigações](../PAINEL.md) · [Manifesto de arquivos e SHA-256](../manifesto-originais.json).
