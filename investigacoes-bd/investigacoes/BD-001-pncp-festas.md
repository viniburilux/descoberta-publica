# BD-001: Garimpo PNCP, festas e eventos

- **Tema:** contratações de festas, shows e eventos no PNCP, consultadas pela base da Base dos Dados.
- **Quando:** 18/11/2026, no chatbot da BD.
- **Pergunta:** o que os dados do PNCP na BD revelam sobre gastos com festas nos municípios?
- **Como foi feito:** sondagem do dataset PNCP, filtros por objeto, SQL executado pelo chatbot (com o log de chamadas inspecionado) e ranqueamento de casos.
- **Resultados:** top 5 de casos extremos: Alcobaça (R$ 120 mi estimados contra R$ 120 mil homologados), Lafaiete Coutinho (R$ 0,01 estimado contra R$ 308,4 mil homologados), Palmas de Monte Alto (R$ 2,04 contra R$ 599,9 mil), Porto Seguro (cachês repetidos) e Mata de São João (R$ 3.898 por habitante). Mais uma lista de cerca de 10 candidatos.
- **O que aprendemos:** o padrão "valor estimado diferente do valor homologado" funciona como gancho de descoberta, e os casos cidade-personagem são o formato que puxa investigação.
- **Hipóteses abertas:** nenhum caso foi verificado fora da base. Os valores são de registro, não de pagamento. Divergência entre estimado e homologado é inconsistência a verificar, não conclusão.
- **Maturidade:** Investigação (2 de 6).
- **Rastreio:** conversa no chatbot da BD em 18/11/2026.

## Como reproduzir

No chatbot da BD, sobre o dataset do PNCP: filtrar o objeto por termos de festa, show e evento, ordenar por valor estimado e homologado e ranquear as divergências. A conversa original é de 18/11/2026.

## Saída pronta: esqueleto de história

- Gancho: o que um município pequeno diz que vai pagar, e o que de fato homologa, em festa.
- Personagens: Alcobaça (R$ 120 mi estimados contra R$ 120 mil homologados), Mata de São João (R$ 3.898 por habitante), Lafaiete Coutinho, Palmas de Monte Alto, Porto Seguro.
- Antes de publicar: voltar ao ato original de cada caso no portal do PNCP. Os valores são de registro, não de pagamento.
