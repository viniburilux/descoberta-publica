# Investigações na Base dos Dados

Doze frentes de investigação executadas entre 18 e 20 de novembro de 2026 sobre a infraestrutura pública de dados da [Base dos Dados](https://basedosdados.org) (BD): o chatbot com SQL visível, o catálogo com mais de 740 tabelas e a API pública de metadados.

Este diretório é o registro público e navegável desse trabalho. Cada frente tem pergunta, método, resultado, hipóteses abertas e nível de maturidade explícito. Os textos e a organização são nossos; a infraestrutura de dados é da BD, sempre creditada.

**Aviso de leitura:** nada aqui é acusação. Onde existe anomalia, ela aparece como inconsistência de dado a verificar. Valor registrado ou rateado não é valor pago. Declaração em cadastro não é condição observada no território. Resultado nulo também é resultado.

## As doze frentes

| ID | Frente | Maturidade |
|----|--------|-----------|
| [BD-001](investigacoes/BD-001-pncp-festas.md) | Garimpo PNCP: festas e eventos | Investigação |
| [BD-002](investigacoes/BD-002-reconhecimento-catalogo.md) | Reconhecimento do catálogo além do PNCP | Exploração |
| [BD-003](investigacoes/BD-003-reconhecimento-infra-emendas-saude.md) | Infra BD, emendas × internações (nulo) e limite por CPF mascarado | Investigação |
| [BD-004](investigacoes/BD-004-vinte-cruzamentos.md) | Vinte cruzamentos exploratórios (banco de hipóteses) | Exploração |
| [BD-005](investigacoes/BD-005-mapa-entidades.md) | Mapa de entidades em 6 camadas | Investigação |
| [BD-006](investigacoes/BD-006-inventario-territorial-sicor-car.md) | Inventário territorial e join SICOR × CAR | Reprodução |
| [BD-007](investigacoes/BD-007-dinheiro-e-territorio.md) | O Dinheiro e o Território (SICOR × CAR × PAM × MapBiomas) | Produto |
| [BD-008](investigacoes/BD-008-executor-reconciliacao.md) | Executor de reconciliação (cânone 2023) | Reprodução |
| [BD-009](investigacoes/BD-009-catalogo-reconciliacao.md) | Catálogo de reconciliação (4 relações medidas) | Reprodução |
| [BD-010](investigacoes/BD-010-micro-cars.md) | Micro-CARs: datas, APP/RL declaradas e sobreposições | Investigação |
| [BD-011](investigacoes/BD-011-ciclo-experiencia-maquina.md) | Ciclo de experiência da máquina | Método |
| [BD-012](investigacoes/BD-012-mcp-mapa-proposta.md) | Mapa do MCP da BD e proposta de contribuição | Aplicável |

## Os produtos

Quatro artefatos prontos para uso e leitura, abertos por link:

- **[O Dinheiro e o Território](https://files.instinct.com/0ge7iva44a3a-o-dinheiro-e-o-territorio)**: app interativa para buscar, filtrar e comparar os 5.380 municípios do cânone de crédito rural 2023.
- **[Crédito rural por município, SICOR 2023](https://files.instinct.com/5gs9dgjmfr9g-credito-rural-por-municipio-sicor-2023)**: dossiê com método, validação, lacunas e o SQL verificado.
- **[A história territorial dos dois casos](https://files.instinct.com/5upblg04u1v8-a-historia-territorial-dos-dois-casos)**: Rondon do Pará (PA) e Bom Sucesso, São Félix do Coribe (BA), reconstruídos ato a ato em fontes oficiais.
- **[MCP de gestão da BD: mapa e proposta](https://files.instinct.com/pl7nm8txk6ks-mcp-de-gestao-da-bd-mapa)**: o que o MCP oficial da BD expõe, o que é leitura livre e a proposta objetiva de colaboração.

## Métodos reutilizáveis

O que saiu dessas frentes como método, não só como resultado: [metodos.md](metodos.md).

## Níveis de maturidade

1. **Exploração**: sondagem, hipóteses, reconhecimento de catálogo.
2. **Investigação**: consultas executadas, resultados observados.
3. **Reprodução**: resultado recuperável ou reexecutável (query_ref, SQL, CSV).
4. **Publicável**: revisado, com lastro e limites claros.
5. **Aplicável**: pronto para demonstrar e compartilhar.
6. **Produto**: artefato de uso (app, dossiê, catálogo).

## Rastreabilidade e fontes

- Os resultados de consulta citados têm `query_ref` do executor público da BD, que recupera o resultado original sem reexecução: qr_6cdff61d, qr_523383966, qr_7b381f10, qr_374c2380, qr_ad504f37, qr_0ef8fb01, qr_ceaa9c22, qr_8a918dd1, qr_0454ef447a7a4f19a728c259c9de78ae.
- As sessões de trabalho foram no chatbot da BD nos dias 18, 19 e 20/11/2026.
- Fontes primárias: Banco Central (SICOR), Serviço Florestal Brasileiro (SICAR), IBAMA (embargos e autos), INCRA (SIGEF/SIPRA), INPE (PRODES/DETER), MapBiomas, RAIS/CNAE e PNCP. Cada fonte tem seus próprios termos de uso e licença.
- Os textos e a organização deste diretório seguem as licenças deste repositório: código sob MIT, documentação e curadoria sob CC BY 4.0.
