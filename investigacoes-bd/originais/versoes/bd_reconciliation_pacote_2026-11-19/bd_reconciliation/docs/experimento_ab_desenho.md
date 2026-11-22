# Desenho do experimento A/B (M3) — v1, 2026-11-19 21:20

## Pergunta
Uma experiência registrada (método validado de uma investigação anterior) muda o desempenho do executor BD num caso NOVO da mesma família de método — sem assistência manual no meio do caminho?

## O que NÃO é condição B (decisão main 21:08)
Fornecer o método manualmente DEPOIS da falha = reprodução guiada. O ciclo 1 da thread 35bbb638 é isso: evidência de reprodução guiada, não de recuperação autônoma.

## Mecanismo real sob teste
O mecanismo que a app "O Dinheiro e o Território" implementaria: o registro de experiência entra como CONTEXTO INICIAL da conversa (primeira mensagem), antes do caso novo. A recuperação, se houver, é do próprio executor usando esse contexto. Nenhuma correção manual intermediária em nenhuma das condições.

## Condições
- **A (baseline):** thread nova, só o caso novo. Sem registro de experiência.
- **B (com experiência):** thread nova, primeira mensagem = registro de experiência T7 compacto (armadilhas: valor está em operacao.valor_parcela_credito e não na tabela-ponte; normalização de id_car; dedup de snapshots CAR; rateio igual por imóveis distintos; município via area_imovel mais recente; indicador_recurso_publico para recorte público), seguida do MESMO caso novo, adaptado.
- Ordem: A primeiro, B depois. Threads separadas (mesma conversa contamina).
- Executor e conta idênticos (chatbot BD, conta ChatbotTeste).

## Caso novo (mesma família de método, dados diferentes)
"Crédito rural de INVESTIMENTO com recurso PRIVADO (indicador_recurso_publico='0'), 2022, rateado por município via CAR: total, número de municípios, top-10." Traps compartilhados: tabela-ponte sem valor, normalização, snapshots, rateio, recorte por indicador (agora invertido). Diferente do T7 (custeio/público/2023).

## Instrumentação (o que registrar por condição)
1. Número de queries executadas até o primeiro resultado correto (via API messages: query_refs e status por tool_call).
2. Falhas reais (erro de SQL, coluna inexistente, zero linhas) e se o executor se recuperou sozinho.
3. Armadilhas aplicadas na PRIMEIRA tentativa vs descobertas por erro (checklist das 6 armadilhas).
4. Correção final: comparar números A vs B vs cânone computado depois (mesma query canônica adaptada).
5. Se em B a experiência foi só lida/citada ou ALTEROU a ação (evidência: trap aplicada sem erro prévio).
6. Tempo wall-clock por condição.

## Relato honesto (regras main/usuário)
- Resultado negativo ou correção é resultado útil.
- Não inflar: se B falhar igual, o mecanismo não transfere — reportar.
- Distinguir "experiência lida" de "experiência alterou ação".
- Não declarar motor universal nem transferência geral a partir de 1 par A/B.

## Status
DESENHADO, não executado. Execução: sessão agendada 21:33 (thread A nova → thread B nova → instrumentação → comparativo).

---

## v2 (21:20) — mecanismo real de recuperação (ponto load-bearing do main)

**Lacuna investigada e confirmada:** nenhuma implementação FUNCIONAL de recuperação de experiência existe no ecossistema alcançável. Verificado: `viniburilux/LuxMemory` é repo HTML (site estático, 2026-08-30); `viniburilux/luxverso-hermes-bridge` (Python) sem código de retrieval (search-code por retrieve/memory/experiencia = 0 hits nos dois); nada de LuxMemory/LuxOS no sandbox. LuxOS é mapa/catálogo, não motor de recuperação.

**Versão mínima autorizada implementada (seleção programática simples, NÃO semântica):**
- Acervo: `experiencias/t7_sicor_car_rateio.json` (registro estruturado: tags, família de método, 6 armadilhas validadas, canônico, disclaimers, fonte).
- Recuperador: `source/retrieve_experience.py` — scoring determinístico por overlap lexical (tags×3, título×2, corpo×1), emite JSON auditável (scores por registro + contexto selecionado verbatim). Nenhum humano escolhe o que entra no contexto B.
- Testado: caso novo → score 35 → seleciona t7_sicor_car_rateio e emite o contexto de injeção. Log = reproduzível.

**Condição B corrigida:** primeira mensagem da thread B = o contexto EMITIDO PELO RECUPERADOR (não colado à mão), precedido de "Registro de experiência recuperado pelo acervo:" + o caso novo. Isso testa acervo→seleção→contexto→ação do executor. O que NÃO testa: reconhecimento semântico/autônomo do problema (limitação declarada).

**Caso novo corrigido:** "crédito rural de INVESTIMENTO com recurso público, 2022, rateado por município via CAR" (não recurso privado: a ponte recurso_publico_propriedade é de recurso público — caso privado seria insolúvel pela ponte). O recorte por finalidade=investimento NÃO está no registro T7 → B ainda precisa descobrir algo além da experiência.
**Leitura honesta:** mesmo par de tabelas + método quase solução no registro ⇒ mede TRANSFERÊNCIA PRÓXIMA, não generalização ampla (controle do main registrado). Subteste "contexto manual" só se rotulado como tal; não é o ciclo pedido.

## v2.1 (21:21) — discriminação e limites de interpretação (main 21:20)
- Acervo agora com 4 registros (1 da família alvo + 3 de outras famílias, derivados dos catálogos validados). Seleção exige score mínimo 10: caso real → T7 (41) único selecionado; controle negativo (caso PNCP fora da família) → zero seleções. Discriminação básica demonstrada neste acervo de 4; NÃO é prova de seleção geral.
- "Não encontrado nos recursos inspecionados" ≠ inexistência no ecossistema: a ordem original cita MachineLab/ASIE/TraceFoundry/ExperienceStoreINT004/OIState, não inspecionados (sem arqueologia nova agora, por instrução do main).
- Etapa final do ciclo (atualização/rejeição da experiência após evidência) preservada: após o par A/B, o registro T7 recebe "resultado_transferencia" (confirmou/refinou/rejeitou + em que condições).
