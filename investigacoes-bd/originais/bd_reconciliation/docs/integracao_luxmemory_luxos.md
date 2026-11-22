# Integração LuxMemory / Lux-Lab / LuxOS (avaliação)

Decisão de casa (19/11/2026): componente e catálogo ficam em linha própria `bd_reconciliation/` no Lux-Lab, seguindo o padrão das linhas existentes. LuxOS e LuxMemory não recebem cópia; recebem ponteiros/registro.

## Lux-Lab (casa primária)

- Padrão seguido: pasta da linha com `README.md` (as 5 perguntas), `manifest.json`, `inputs/`, `outputs/`, `source/`, `docs/`, `catalog/`.
- História resumida em `docs/metodo.md`.

## LuxOS

- O LuxOS é o catálogo de capacidades/documentos do ecossistema e usa a regra de evidência (Existe/Especificado/Implementado/Utilizado/Integrado/Validado/Reutilizável).
- Passo de integração: entrada no catálogo de componentes do LuxOS apontando para esta linha, com status por item (tabela no README da linha). Ex.: componente = Implementado; regressão = Validado; execução nova na BD = Especificado.
- Categoria de evidência aplicada a cada claim desta linha, conforme a regra.

## LuxMemory

- O LuxMemory registra capacidades e proveniência (CAPABILITY_MAP.md e contratos de memória/capacidades/proveniência).
- Passo de integração: registrar a linha no CAPABILITY_MAP com os campos de proveniência usados aqui (fonte, thread, query_ref, data de observação).
- Os registros do catálogo já carregam o bloco `evidencias` no formato de proveniência.

## Estado de integração (atualizado 20/11/2026, 00:05 -03)

1. Ponteiros nos dois repos: CONCLUÍDO (commits reais, ver seção Execução abaixo). Escopo: integração documental, NÃO integração em tempo de execução.
2. Entrada formal no CAPABILITY_MAP do LuxMemory: CONCLUÍDO (20/11). Os contratos de proveniência/capacidades/segredos do LuxMemory foram relidos na íntegra e o formato validado contra as entradas existentes do mapa. Registrados: capacidade observada "Reconciliação de bases públicas com diagnóstico de relacionamento" (confiança high, evidência executed_live, ativos e limites declarados) e oportunidade hipotética "contribuição de data-quality checks à Base dos Dados" (decisão explore, confiança low, gate e sinal de sucesso explícitos, restrição: contato externo é decisão do usuário, fora desta operação). Commit verificado por fetch raw.
3. Compatibilidade/deduplicação com os componentes MCP da BD e radar PNCP: CONCLUÍDO 20/11 00:10: análise em `docs/proposta_contribuicao_bd.md` §4 (sem sobreposição funcional; PNCP×outras bases registrado como possibilidade futura).

## Execução (19/11/2026, 23:50 -03)

Ponteiros EXECUTADOS como commits reais:
- LuxOS: `missions/PONTEIRO_bd_reconciliation_20261119.md`
  (https://github.com/viniburilux/LuxOS/blob/main/missions/PONTEIRO_bd_reconciliation_20261119.md):
  registro na régua de evidência LuxOS (Existe/Implementado/Utilizado/Integrado/Validado).
- LuxMemory: `docs/PONTEIRO_bd_reconciliation_20261119.md`
  (https://github.com/viniburilux/LuxMemory/blob/main/docs/PONTEIRO_bd_reconciliation_20261119.md):
  entrada de memória apontando para o acervo de experiências (schema de 9 campos).

Escopo declarado: integração documental executada. Integração em tempo de
execução (chamada de código entre os sistemas) NÃO existe e não é reivindicada.

