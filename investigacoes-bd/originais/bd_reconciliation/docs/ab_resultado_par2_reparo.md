# Resultado A/B, par 2: TESTE DE REPARO (2026-11-19 21:45–21:47)

## Desenho
Mesmo caso novo do par 1. Thread B2 = b41bd441-96c3-4170-b92c-a28e3fd6c569, contexto emitido pelo recuperador a partir do registro T7 REFINADO (armadilha 3 reescrita + status de validação por item). Sem nova baseline: a referência é o output de A (par 1) já submetido a diagnóstico SQL complementar. B original (de090efe) preservado intacto; versões não destrutivas.
URL: https://basedosdados.org/chatbot?t=b41bd441-96c3-4170-b92c-a28e3fd6c569

## Resultado
- Total: **R$ 48.292.622.454,52**, idêntico ao centavo à referência de A.
- Municípios: **5.241**, idêntico.
- Top-10: idêntico, posição a posição, valores aos centavos.
- SQL final usa BETWEEN 2026-06-02 AND 2026-08-04 + ROW_NUMBER PARTITION BY imóvel (a forma correta, não o filtro por data máxima global).
- 2 queries SQL (par 1: B=3, A=9), sem alegação de aceleração; só contagem.
- B2 ecoou espontaneamente a ressalva de status: "a semântica conceitual do indicador de recurso público permanece a ressalva parcialmente validada mencionada no registro": o status por item transferiu para a fala do executor.

## Veredito do ciclo completo
Ciclo acervo→recuperação→estratégia→teste→ATUALIZAÇÃO→reteste FECHADO com reparo confirmado:
1. Par 1: experiência original induziu erro silencioso (leitura literal da armadilha de snapshot; -77% dos imóveis).
2. Diagnóstico comparativo quantificou o erro (378.322 descartados de 489.138).
3. Registro refinado (wording + status por item).
4. Par 2 (reparo): erro eliminado; resultado idêntico à referência verificada.

## Limites declarados
- Um par de reparo com mesmo caso e mesmo executor = evidência de reparo DESTA armadilha nesta família, não de generalização.
- Referência de A validada por diagnóstico complementar na mesma thread (mesmo executor/sessão), não auditoria independente.
- Semântica do indicador_recurso_publico: parcialmente validada; pendente contra documentação BCB.
- Recuperação = seleção programática simples (overlap lexical, min-score 10, acervo de 4 registros), não reconhecimento semântico.

Corpus: export integral da thread NÃO incluído neste pacote (conversa original na URL acima); retrieval log: outputs/runs/2026-11-19/ab2_retrieval_log.json
