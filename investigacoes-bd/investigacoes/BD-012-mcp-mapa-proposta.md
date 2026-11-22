# BD-012: Mapa do MCP da BD e proposta de contribuição

- **Tema:** mapeamento do MCP (Model Context Protocol) oficial da Base dos Dados e proposta técnica de contribuição.
- **Quando:** 19/11/2026.
- **Pergunta:** o que o MCP da BD expõe sem conta e o que dá para contribuir de volta?
- **Como foi feito:** leitura de metadados públicos via MCP e API GraphQL (funciona sem conta e sem custo), verificada ao vivo em 19/11; README, código-fonte e documentação pública.
- **Resultados:** mapa do MCP de gestão (cerca de 30 ferramentas create_update_*, idempotentes, cobrindo o ciclo de catalogação) e uma proposta objetiva de colaboração em 4 passos, começando pelo que não depende de ninguém.
- **O que aprendemos:** os metadados públicos da BD são legíveis por máquina sem autenticação. E a própria documentação da BD declara a lacuna que a nossa experiência de reconciliação (BD-006, BD-009) pode ajudar a preencher: checagens automáticas de qualidade de dados e metadados.
- **Hipóteses abertas:** o escopo final de qualquer contribuição depende de conversa com a equipe da BD.
- **Produto:** [MCP de gestão da BD: mapa e proposta](https://files.instinct.com/pl7nm8txk6ks-mcp-de-gestao-da-bd-mapa), com as fontes verificadas.
- **Maturidade:** Aplicável (5 de 6).
- **Rastreio:** fontes públicas listadas no documento, verificadas em 19/11/2026.

## Saída pronta

A proposta objetiva em 4 passos está no próprio documento linkado acima, começando pelo que não depende de ninguém: usar a leitura livre de metadados para montar o catálogo de relacionamentos entre bases.
