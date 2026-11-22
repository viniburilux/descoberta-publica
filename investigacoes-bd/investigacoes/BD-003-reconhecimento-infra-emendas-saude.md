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

- [BD-003: JSON de 12 mensagens](../conversas/BD-003_4bbb1362-4dfb-47c1-a70a-61886d7a151b.json) · [leitura cronológica](../conversas/extraidos/BD-003/mensagens.md) · [SQL, chamadas e respostas](../conversas/extraidos/BD-003/)

## B. Consultas e código

21 consultas SQL extraídas das conversas. Chamadas e respostas originais, com identificadores e argumentos, estão nas pastas ligadas acima. Os SQLs estão separados em `sql/` dentro de cada pasta.

## C. Resultados e arquivos

14 tabelas CSV das linhas registradas nas respostas do chatbot; respostas completas e índices com a consulta e a mensagem de origem.


## D. Reprodutibilidade

Abra a leitura cronológica para seguir perguntas, chamadas e respostas na ordem. Os SQLs separados podem ser reexecutados no executor BD.

## E. Destinos possíveis

Artigo e protocolo de benchmark Text-to-SQL; relato técnico do teste emendas × internações.

## F. Pendências e próximo passo

Os exports nativos apenas referenciados em `downloads-referenciados.json` ainda não foram baixados neste lote. As respostas e linhas registradas já estão nos arquivos extraídos.

Log BD, 21 SQLs e resultados recuperados. Faltam os materiais dos outros quatro modelos para a tabela comparativa do benchmark.


## G. Pacote de trabalho

[Baixar o material recuperado (ZIP)](../pacotes/BD-003-material-recuperado-2026-11-22.zip). Versão 22/11/2026.

[Todos os materiais desta frente](#c-resultados-e-arquivos) · [Painel das 12 investigações](../PAINEL.md) · [Manifesto de arquivos e SHA-256](../manifesto-originais.json).
