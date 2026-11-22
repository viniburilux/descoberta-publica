# BD-011: Ciclo de experiência da máquina
- **Tema:** demonstração de que experiência registrada muda o comportamento da máquina em investigação posterior, para o bem e para o mal.
- **Quando:** 19 a 20/11/2026, dentro da mesma operação.
- **Pergunta:** uma experiência recuperada altera o que a máquina tenta? E como tratar quando ela induz erro?
- **Como foi feito:** ciclo executado uma vez, ponta a ponta: uma experiência recuperada da memória de trabalho induziu um erro; o erro foi detectado, o registro foi corrigido e o reteste passou.
- **Resultados:** demonstração completa do ciclo recuperar → aplicar → errar → corrigir → retestar.
- **Rastreio:** registros da operação de 19 a 20/11/2026.

## Sequência da investigação

Experiência T7 → par A/B 1 → erro de snapshot → refinamento do registro → par A/B 2 com reparo.

## A. Material bruto recuperado

- [ab-baseline: JSON de 4 mensagens](../conversas/ab-baseline_e6d448ba-eceb-4c09-9705-dad568afe806.json) · [leitura cronológica](../conversas/extraidos/ab-baseline/mensagens.md) · [SQL, chamadas e respostas](../conversas/extraidos/ab-baseline/)
- [ab-experiencia: JSON de 2 mensagens](../conversas/ab-experiencia_de090efe-9af0-4778-8556-a3c3eb6ef6ba.json) · [leitura cronológica](../conversas/extraidos/ab-experiencia/mensagens.md) · [SQL, chamadas e respostas](../conversas/extraidos/ab-experiencia/)
- [ab2-reparo: JSON de 2 mensagens](../conversas/ab2-reparo_b41bd441-96c3-4170-b92c-a28e3fd6c569.json) · [leitura cronológica](../conversas/extraidos/ab2-reparo/mensagens.md) · [SQL, chamadas e respostas](../conversas/extraidos/ab2-reparo/)

## B. Consultas e código

15 consultas SQL extraídas das conversas. Chamadas e respostas originais, com identificadores e argumentos, estão nas pastas ligadas acima. Os SQLs estão separados em `sql/` dentro de cada pasta.

[Código da reconciliação](../originais/bd_reconciliation/source/) · [21 SQLs parametrizados](../originais/bd_reconciliation/outputs/sql/) · [Reprodução local](../REPRODUZIR.md).

## C. Resultados e arquivos

12 tabelas CSV das linhas registradas nas respostas do chatbot; respostas completas e índices com a consulta e a mensagem de origem.

- [Desenho A/B](../originais/bd_reconciliation/docs/experimento_ab_desenho.md)
- [Resultado par 1](../originais/bd_reconciliation/docs/ab_resultado_par1.md)
- [Resultado par 2](../originais/bd_reconciliation/docs/ab_resultado_par2_reparo.md)
- [Registros de experiência](../originais/bd_reconciliation/experiencias/)
- [Recuperador Python](../originais/bd_reconciliation/source/retrieve_experience.py)
- [Logs originais](../originais/bd_reconciliation/outputs/runs/2026-11-19/)

## D. Reprodutibilidade

Recuperador, registros estruturados, contexto, resultados e logs dos pares A/B disponíveis. O passo a passo está no desenho experimental original.

## E. Destinos possíveis

Paper ou artigo de método com desenho A/B, registro de erro e reparo.

## F. Pendências e próximo passo

Os exports nativos apenas referenciados em `downloads-referenciados.json` ainda não foram baixados neste lote. As respostas e linhas registradas já estão nos arquivos extraídos.

Executar um novo par A/B em outra família de relacionamento e guardar contexto inicial, SQL, resultados e contagem de chamadas.


## G. Pacote de trabalho

[Baixar o material recuperado (ZIP)](../pacotes/BD-011-material-recuperado-2026-11-22.zip). Versão 22/11/2026.

[Todos os materiais desta frente](#c-resultados-e-arquivos) · [Painel das 12 investigações](../PAINEL.md) · [Manifesto de arquivos e SHA-256](../manifesto-originais.json).
