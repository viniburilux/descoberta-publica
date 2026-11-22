# Reproduzir os pacotes BD

## Abrir os resultados

1. Baixe ou clone este repositório.
2. Abra `originais/bd_reconciliation/outputs/app/index.html` no navegador. O mapa e os dados estão incorporados no HTML.
3. Para trabalhar em tabela, abra `originais/bd_reconciliation/outputs/mapa_credito_rural_municipal_2023_nomeado.csv`. São 5.380 linhas de municípios, além do cabeçalho.
4. Para as frentes territoriais, use os GeoJSON em `originais/pacote_evidencias_20261120/`, os TIFFs em `originais/versoes/lulc_10m_evidencias_v2/` e as notas em `originais/drive-2026-11-20/`.

## Gerar SQL e recomputar métricas

Requer Python 3, somente biblioteca padrão. A partir desta pasta:

```bash
python3 reproducao/verificar.py /tmp/reproducao-bd
```

O comando gera as consultas das quatro famílias, compara os bytes dos 21 SQLs com os originais, recalcula as métricas usando as contagens registradas e reconstrói o HTML da aplicação. Os originais permanecem intactos.

Resultado local de 22/11/2026:

| Verificação | Resultado |
|---|---|
| Geração SQL | 21/21 arquivos idênticos aos originais |
| IBAMA | 2/2 checks aprovados |
| PRODES × MapBiomas | 1/1 check aprovado |
| RAIS × CNAE | 2/2 checks aprovados |
| SICOR × CAR | 3/3 checks aprovados |
| App HTML | Gerado; diferença entre versões apenas na pontuação do título da aba |

[Registro da execução](reproducao/2026-11-22/verificacao.json) · [Relatórios](reproducao/2026-11-22/reports/).

O gerador HTML original tem um caminho absoluto em `BASE`. O comando acima adapta esse caminho apenas na cópia de execução, sem editar o arquivo original.

## Consultar o catálogo

```bash
cd originais/bd_reconciliation
python3 source/catalog_query.py --list
python3 source/catalog_query.py --relationship sicor_car
python3 source/catalog_query.py --relationship sicor_car --field cobertura_observada
```

## Executar a reconciliação em dados atuais

Os SQLs em `originais/bd_reconciliation/outputs/sql/` usam BigQuery Standard SQL e os nomes de tabelas da BD presentes na investigação original. Abra a consulta no executor BD ou no seu ambiente BigQuery, execute e salve o export em uma nova pasta datada. Preserve o identificador da consulta, o período e a versão do resultado.

## Recalcular as interseções territoriais

O verificador original está em `originais/pacote_evidencias_20261120/verificar.py`. Dependências: `shapely` e `pyproj`.

```bash
python3 verificar.py alvo.json longitude latitude
python3 verificar.py alvo.json poligono_referencia.json
```

Os arquivos de entrada são respostas GeoJSON em EPSG:4326. As notas de cada pacote registram as camadas e os recortes usados.

## Conferir integridade

O [manifesto](manifesto-originais.json) registra caminho, tamanho e SHA-256 de cada arquivo original publicado. Os nomes dos arquivos e suas versões foram preservados. Os resultados novos desta organização ficam em `reproducao/`, separados dos originais.
