# BD-001: Garimpo PNCP: festas e eventos
- **Tema:** contratações de festas, shows e eventos no PNCP, consultadas pela base da Base dos Dados.
- **Quando:** 18/11/2026, no chatbot da BD.
- **Pergunta:** o que os dados do PNCP na BD revelam sobre gastos com festas nos municípios?
- **Como foi feito:** sondagem do dataset PNCP, filtros por objeto, SQL executado pelo chatbot (com o log de chamadas inspecionado) e ranqueamento de casos.
- **Resultados:** top 5 de casos extremos: Alcobaça (R$ 120 mi estimados contra R$ 120 mil homologados), Lafaiete Coutinho (R$ 0,01 estimado contra R$ 308,4 mil homologados), Palmas de Monte Alto (R$ 2,04 contra R$ 599,9 mil), Porto Seguro (cachês repetidos) e Mata de São João (R$ 3.898 por habitante). Mais uma lista de cerca de 10 candidatos.
- **Rastreio:** conversa no chatbot da BD em 18/11/2026.

## Sequência da investigação

Abertura PNCP → busca por festas e eventos → comparação dos valores → seleção de municípios.

## A. Material bruto recuperado

- [BD-001: JSON de 20 mensagens](../conversas/BD-001_43f64dd9-d0fe-416c-a599-a5e2a28e1918.json) · [leitura cronológica](../conversas/extraidos/BD-001/mensagens.md) · [SQL, chamadas e respostas](../conversas/extraidos/BD-001/)

## B. Consultas e código

18 consultas SQL extraídas das conversas. Chamadas e respostas originais, com identificadores e argumentos, estão nas pastas ligadas acima. Os SQLs estão separados em `sql/` dentro de cada pasta.

## C. Resultados e arquivos

5 tabelas CSV das linhas registradas nas respostas do chatbot; respostas completas e índices com a consulta e a mensagem de origem.


## D. Reprodutibilidade

Abra a leitura cronológica para seguir perguntas, chamadas e respostas na ordem. Os SQLs separados podem ser reexecutados no executor BD.

## E. Destinos possíveis

Pauta QPI sobre Alcobaça, Lafaiete Coutinho, Palmas de Monte Alto, Porto Seguro e Mata de São João.

## F. Pendências e próximo passo

Os exports nativos apenas referenciados em `downloads-referenciados.json` ainda não foram baixados neste lote. As respostas e linhas registradas já estão nos arquivos extraídos.

Usar os candidatos, os 18 SQLs e as tabelas recuperadas para montar a pauta por contratação e ligar cada caso ao ato no PNCP.


## G. Pacote de trabalho

[Baixar o material recuperado (ZIP)](../pacotes/BD-001-material-recuperado-2026-11-22.zip). Versão 22/11/2026.

[Todos os materiais desta frente](#c-resultados-e-arquivos) · [Painel das 12 investigações](../PAINEL.md) · [Manifesto de arquivos e SHA-256](../manifesto-originais.json).
