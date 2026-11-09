# Categorizacao da base nacional PNCP - v6.3 (REFERENCIA ATUAL), corrigida em 07/11/2026

Principio de organizacao: categorizar a base ANTES da descoberta editorial
(coletar -> categorizar -> enriquecer -> observar).
Recorte da base: modalidade 9 (Inexigibilidade) apenas, 2025 + 2026 parcial - nao sao
todas as compras publicas do Brasil.

## Metodo (honesto)
O processo antigo classificava por interpretacao de LLM, registro a registro, sobre o texto
do objeto (28.306 registros BA 2025/2026 rotulados assim). O que existe agora e um
classificador DETERMINISTICO (regras por palavra-chave com prioridade de dominio) destilado
desses rotulos - metodo diferente, validado por amostragem lida por IA
(VALIDACAO_AMOSTRAL.md). Concordancia com os rotulos antigos: 87,8% na BA - medida de
fidelidade/concordancia apenas (nao e precisao nacional nem prova de correcao): parte das divergencias e melhoria semantica validada
(ex.: 787 registros EROCP de entrega de agua que o esquema antigo deixava em "outros"),
parte e ruido dos rotulos antigos (ex.: credenciamento-de-saude dividido 777x296),
parte e limítrofe genuino. Nao reproduz integralmente o processo antigo.

## Categorias
9 do esquema antigo (artistico, locacao, outros, consultoria, capacitacao, saude, aquisicao,
credenciamento, manutencao; subcats de artistico: forro_sao_joao, carnaval, outros_show)
+ 2 derivadas da observacao do corpus nacional: `agua` (abastecimento de agua e saneamento,
incl. Operacao Carro Pipa; 3,1% da base) e `transporte` (escolar, passagens, fretes; 0,5%).

## Correcao v6.3 (07/11/2026, mesma noite) - LEIA PRIMEIRO
Na verificacao linha a linha dos rankings de montante, a v6.2 mostrou erro semantico
material: qualquer texto com "SAO JOAO" ou "QUADRILHA" era classificado artistico,
capturando nomes de cidade/bairro (hospital em "Barra de Sao Joao", Casimiro de Abreu,
R$48M; merenda escolar de "Sao Joao de Meriti", R$23M) e "ginastica artistica"
(vale-transporte de Sao Roque, R$4,2M). A v6.3 exige contexto de festa para SAO JOAO,
remove o nome do proprio municipio do texto antes de classificar e remove "GINASTICA
ARTISTICA". Efeito nacional: artistico 122.871 -> 121.556 registros; subcategoria
forro_sao_joao 17.025 -> 13.166; outros_show 87.455 -> 89.999 (recebendo realocados).
Arquivos v6.2 PRESERVADOS com sufixo _v62 no nome; arquivos _v63 sao a referencia.
Nao usar numeros v6.2 para montantes.

## Distribuicao nacional v6.3 (494.446 registros, modalidade 9 - Inexigibilidade, 2025 + 2026 parcial)
artistico 24,6% | outros 18,3% | capacitacao 15,6% | aquisicao 9,0% | saude 8,7% |
locacao 7,9% | consultoria 6,2% | manutencao 3,6% | agua 3,1% | credenciamento 2,5% | transporte 0,5%
Subcats de artistico: outros_show 89.999, carnaval 18.391, forro_sao_joao 13.166.

## Arquivos deste pacote
- `categorizar_v63.py` - classificador deterministico, sem dependencias externas.
- `sidecar_categorias_v63.csv` - numero_controle -> categoria, subcategoria (junta com a
  base por numero_controle).
- `resumo_categoria_uf_ano_v63.csv` - n + somas estimado/homologado (separadas) por
  categoria x UF x ano de publicacao. Valores acima de R$ 1 bi por registro entram como 0
  (inconsistencias obvias da fonte); na v6.3, registros cujo valor e ~1000x o valor escrito
  no proprio objeto tambem sao excluidos das SOMAS de estimado (18 registros, R$ 71,7M;
  homologado mantido como registrado).
- `observacao_municipio_2025_vs_2026_v63.csv` - por municipio (esfera M) x categoria: janela
  comparavel jan-abr de cada ano, totais de ano, maior contrato por janela, contagens de
  quase-duplicatas suspeitas, flag_valor_atipico. Campo de data: `publicacao`. Mesmas
  exclusoes de valor do resumo.
- `VALIDACAO_AMOSTRAL.md` - leitura amostral das divergencias, do residual e das categorias
  novas, com o que foi corrigido e o que ficou limítrofe.
