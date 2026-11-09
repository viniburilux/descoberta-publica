# Validacao amostral da categorizacao (07/11/2026)

Metodo: amostras aleatorias (semente fixa) lidas uma a uma por IA, comparando rotulo antigo
(LLM, 2025-2026) vs categorizador deterministico v6.2. O processo antigo era interpretacao
por LLM registro a registro; o novo e um conjunto de regras deterministicas DESTILADO desse
comportamento - nao e o mesmo metodo e nao reproduz o LLM integralmente. Concordancia com os
rotulos antigos e usada como referencia de fidelidade, NAO como prova de correcao: os rotulos
antigos contem erros e inconsistencias proprios (exemplos abaixo).

## Amostra A - 30 divergencias BA (rotulo antigo != v6.2)
- v6.2 claramente melhor (9): ex. "profissionais do setor artistico na Mostra Cultural de
  Pocoes" (antigo=outros); capoeira "apresentacao cultural" (antigo=outros); assinatura anual
  de jornal (antigo=outros); treinamento em gestao (antigo=saude); mecanica/borracharia da
  frota (antigo=capacitacao); bilhete de passagem (antigo=capacitacao).
- Rotulo antigo melhor (4): pagamento de auto de infracao ao Conselho de Farmacia (v6.2=saude
  por "farmacia"; e pagamento administrativo); locacao de imovel rural p/ abastecimento de
  agua (contrato e aluguel); sistema de cotacao eletronica (v6.2=manutencao por palavra de
  contexto); "advocaticios" sem cedilha (v6.0 perdia - CORRIGIDO em v6.2 via ADVOCA*).
- Empate / decisao de desenho documentada (7): credenciamento-de-saude (antigo dividia 777
  saude vs 296 credenciamento; v6.2 = dominio-primeiro, sempre saude); credenciamento MEI de
  transporte escolar (v6.2 = transporte, categoria nova); locacao de imovel p/ almoxarifado
  de medicamentos (v6.2 = locacao, contrato e aluguel).
- Ambiguos/inconclusivos (10): textos genericos ou truncados onde os dois lados sao fracos
  (ex. "Concursos Publicos" antigo=capacitacao; "Contratacao direta Lei 13.303" sem objeto
  visivel).
Leitura: nas divergencias decidiveis DESTA amostra, o v6.2 se mostrou no minimo tao
defensavel quanto o rotulo antigo. A amostra de 30 nao estima taxa nacional nem prova
superioridade global. O acordo de 87,8% e concordancia com os rotulos antigos, apenas.

## Divergencia intencional documentada - EROCP "entrega de agua"
787 registros da Operacao Carro Pipa (variante "entrega de agua aos municipios atendidos pela
EROCP/6a RM") eram "outros" (776) ou "transporte" (11) no esquema antigo. v6.2 os classifica
como `agua` propositalmente: validado por leitura (Amostra C) - sao abastecimento de agua.
So isso explica ~2,8pp do "desacordo" BA: e melhoria semantica, nao regressao.

## Amostra B - 30 "outros" nacionais (residual)
- Corretamente outros (22): convenios, taxas, cartorio, fatura eletrica, arbitragem esportiva,
  patrocinios, anuidades, itens de catalogo sem verbo (municao, lubrificante, generos
  alimenticios) - cauda longa heterogenea, sem mega-balde restante.
- Limítrofes (6): palestras, docente de pos-graduacao, aprendizagem SENAI, avaliacao atuarial,
  "INTERNACAO" (uma palavra), publicidade - plausiveis em capacitacao/consultoria/saude, mas
  sem padrao limpo que nao gere falsos positivos piores. "INTERNACAO" foi absorvido em saude.
- Erros reais encontrados e corrigidos (2): "advocaticios" -> consultoria; contrato de imovel
  com "LOCADOR" -> locacao.
Conclusao honesta: o residual 18,3% e cauda longa heterogenea com ~20-25% de limítrofes;
NAO e "so boilerplate". Novas subdivisoes so com evidencia de volume (nenhuma passou no corte).

## Amostra C - 25 "agua" nacional
25/25 corretos. Composicao: Operacao Carro Pipa / EROCP-Exercito (~11), contratos com
concessionaria de agua+esgoto (~12), poco artesiano/locacao de caminhao-pipa (~2).
A categoria e "abastecimento de agua e saneamento", mais larga que so carro-pipa - documentado.

## Amostra D - 20 "transporte" nacional (v6.1d)
17/20 corretos (transporte escolar MEI ~11, passagens aereas, rodoviario interestadual,
mudanca institucional). Desvios: 2 EROCP-agua (CORRIGIDOS em v6.2 -> agua), 1 nome de
secretaria ("Infraestrutura, Transportes e Obras"), 2 servicos postais/Correios (limítrofe).
Na amostra lida: 17/20 corretos; os 2 erros de agua geraram correcao de regra. Amostra
unica nao estima precisao nacional da categoria.

## Verificacoes de qualidade da base
- Campo de data: `publicacao` (timestamp ISO). ano_publicacao == ano de publicacao em 100%
  dos 494.446 registros; publicacao nunca nula. Janelas por mes de publicacao.
- Repeticoes suspeitas: 10.108 grupos com mesmo orgao+objeto+valor em linhas com
  numero_controle distinto. Nenhuma linha removida; todos os IDs unicos preservados.
  Contadas por janela nas colunas dup_suspeita_* como SUSPEITAS - causa nao examinada;
  podem ser renovacoes, adesoes, reenvios ou registros legitimos distintos.
- Valores: somas excluem registros com valor_estimado/homologado > R$1bi (erros de registro);
  estimado e homologado NUNCA somados entre si (colunas separadas). Contrato unico > R$50M em
  janela municipal gera flag_valor_atipico=SIM - candidato a validacao, NAO anomalia confirmada.
