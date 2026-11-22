# Catálogo de relacionamentos (missão 3)

Catálogo consultável dos relacionamentos entre bases públicas investigados na infraestrutura da Base dos Dados.

Cada registro em `catalog/relationships/<id>.json` contém: bases e tabelas, entidades relacionadas, campos e chaves, consultas de referência, transformações necessárias, cardinalidade, cobertura observada, problemas conhecidos, evidências e arquivos, versões e datas, status de validação.

Os registros referenciam as configs executáveis em `../../configs/relationships/` em vez de duplicá-las: o catálogo é a camada de consulta e proveniência; a config é a camada de execução.

## Consultar

```bash
python3 ../source/catalog_query.py --list
python3 ../source/catalog_query.py --relationship sicor_car
python3 ../source/catalog_query.py --relationship sicor_car --field cobertura_observada
python3 ../source/catalog_query.py --table br_bcb_sicor
```

## Integração com o ecossistema (avaliação inicial)

- **LuxOS:** o catálogo adota a regra de evidência do LuxOS (Existe/Especificado/Implementado/Utilizado/Integrado/Validado/Reutilizável) no campo `status_validacao` de cada registro. O LuxOS aponta para esta linha sem copiá-la; uma entrada no catálogo de componentes do LuxOS é o passo de integração correspondente.
- **LuxMemory:** a camada de proveniência (fonte, thread, query_ref, data de observação) segue o modelo de registro do LuxMemory; a inclusão desta linha no CAPABILITY_MAP é o passo correspondente.
- **Lux-Lab:** esta linha segue o padrão de pasta própria com manifest, inputs, outputs e docs.
- Detalhes e decisões pendentes em `../docs/integracao_luxmemory_luxos.md`.

## Metadados da BD via GraphQL pública (sem conta, sem custo)

Endpoint: `POST https://backend.basedosdados.org/graphql` (público, sem autenticação;
o `/graphql` do site responde 405 a POST; o backend próprio é outro host).
Exemplo: `{ allDataset(first:1, slug:"sicor"){ edges{ node{ slug namePt organizations{edges{node{slug}}} tables(first:60){edges{node{slug}}} } } } }`.
Atenção: o slug do dataset na API de metadados NÃO é o id BigQuery
(ex.: `basedosdados.br_bcb_sicor` = dataset slug `sicor`; `br_mapbiomas_estatisticas` = `estatisticas`).
Cada registro do catálogo carrega o bloco `metadados_bd` preenchido por essa rota (20/11/2026).

