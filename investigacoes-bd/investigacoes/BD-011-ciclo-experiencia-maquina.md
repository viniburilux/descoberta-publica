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

Código, consultas, contagens, documentos e resultados originais no pacote abaixo. Os dois exports de conversa do pacote de reconciliação somam 14 mensagens; a recuperação das sessões completas está em andamento.

## B. Consultas e código

[Código Python](../originais/bd_reconciliation/source/) · [SQLs originais](../originais/bd_reconciliation/outputs/sql/) · [Guia de reprodução](../REPRODUZIR.md).

## C. Resultados e arquivos

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

Executar um novo par A/B em outra família de relacionamento e guardar contexto inicial, SQL, resultados e contagem de chamadas.

Pendente: integrar a conversa completa com suas perguntas, respostas e chamadas originais.

## G. Pacote de trabalho

[Baixar o material recuperado (ZIP)](../pacotes/BD-011-material-recuperado-2026-11-22.zip). Versão 22/11/2026.

[Todos os materiais desta frente](#c-resultados-e-arquivos) · [Painel das 12 investigações](../PAINEL.md) · [Manifesto de arquivos e SHA-256](../manifesto-originais.json).
