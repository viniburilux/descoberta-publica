# Schema de experiências — 9 campos da DIRETRIZ TRANSVERSAL (19/11/2026, 21:25)

Todo registro em `experiencias/` carrega, além dos campos operacionais originais
(`id`, `tipo`, `titulo`, `tags`, `familia_metodo`, `armadilhas_validadas`, `fonte`,
`registrado_em`), os 9 campos de captura de descobertas da diretriz:

1. `contexto_origem` — contexto de origem e referência à conversa/investigação.
2. `ideia_original` — ideia original, preservando formulação e significado.
3. `principio_hipotese` — princípio ou hipótese extraível.
4. `evidencias_exemplos` — evidências e exemplos já disponíveis.
5. `outras_aplicacoes` — outras aplicações/domínios potenciais (marcar nível: hipótese etc.).
6. `perguntas_abertas` — perguntas ainda não respondidas.
7. `experimentos_possiveis` — experimentos possíveis.
8. `estado_validacao` — ideia | hipótese | experimentada | demonstrada | validada em outro contexto.
9. `relacoes` — relações com projetos, componentes e experiências existentes.

Compatibilidade: `source/retrieve_experience.py` (seleção por overlap lexical,
tags×3/título×2/corpo×1) lê apenas os campos originais; os 9 campos são aditivos
e não alteram o mecanismo validado no par A/B. Lacunas são marcadas como tal,
nunca preenchidas retroativamente com formulação nova.
