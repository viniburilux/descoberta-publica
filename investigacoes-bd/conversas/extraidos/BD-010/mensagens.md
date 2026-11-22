# BD-010: conversa BD

Origem: https://basedosdados.org/chatbot?t=430dfb1d-63f9-4901-b181-963177941355

Thread: `430dfb1d-63f9-4901-b181-963177941355`. Mensagens: 18.

## 1. USER | 2026-11-20T03:57:27.473545Z

Identificador: `149c51d5-0e9f-49c5-8d4a-115d25d9c2d7`.

Execute exatamente este SQL no BigQuery, sem alterar nada, e me mostre todas as linhas do resultado:

WITH op_imoveis AS (
  SELECT DISTINCT id_referencia_bacen, numero_ordem, REPLACE(id_car, '-', '') AS id_car_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2023 AND id_car IS NOT NULL AND TRIM(id_car) <> ''
),
ops_pub AS (
  SELECT o.id_referencia_bacen, o.numero_ordem,
    MAX(o.valor_parcela_credito) AS valor_parcela_credito,
    MAX(o.area_financiada) AS area_financiada
  FROM `basedosdados.br_bcb_sicor.operacao` o
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` f USING (id_fonte_recurso)
  WHERE o.ano_emissao = 2023 AND f.indicador_recurso_publico = '1'
  GROUP BY 1, 2
),
cont AS (
  SELECT id_referencia_bacen, numero_ordem, COUNT(*) AS n
  FROM op_imoveis GROUP BY 1, 2
),
car AS (
  SELECT id_imovel, area, id_municipio
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
  QUALIFY ROW_NUMBER() OVER (PARTITION BY REPLACE(id_imovel, '-', '') ORDER BY data_extracao DESC) = 1
),
cred AS (
  SELECT c.id_imovel, c.area, c.id_municipio,
    SUM(p.valor_parcela_credito / n.n) AS credito,
    SUM(p.area_financiada / n.n) AS area_fin
  FROM ops_pub p
  JOIN cont n USING (id_referencia_bacen, numero_ordem)
  JOIN op_imoveis i USING (id_referencia_bacen, numero_ordem)
  JOIN car c ON REPLACE(c.id_imovel, '-', '') = i.id_car_norm
  GROUP BY 1, 2, 3
)
SELECT
  COUNT(*) AS imoveis,
  COUNT(DISTINCT id_municipio) AS municipios,
  SUM(credito) AS valor_total,
  COUNTIF(area_fin > area) AS imoveis_area_maior_100,
  SUM(IF(area_fin > area, credito, 0)) AS valor_area_maior_100,
  COUNTIF(area < 1) AS micros_menor_1ha,
  SUM(IF(area < 1, credito, 0)) AS valor_micros
FROM cred

## 2. ASSISTANT | 2026-11-20T03:57:27.492224Z

Identificador: `7c57a7f8-7025-4fc7-ac61-91f8fc039fa5`.

A execução foi concluída exatamente como enviada. O resultado contém **1 linha**:

| imoveis | municipios | valor_total | imoveis_area_maior_100 | valor_area_maior_100 | micros_menor_1ha | valor_micros |
|---:|---:|---:|---:|---:|---:|---:|
| 797.183 | 5.380 | 112.125.325.594,2197 | 76.720 | 18.299.202.226,50192 | 46.343 | 1.109.742.199,6967387 |

## 3. USER | 2026-11-20T03:59:31.890905Z

Identificador: `4ef0506c-bef8-40ff-89b6-325e5f316961`.

Execute exatamente este SQL no BigQuery, sem alterar nada, e me mostre todas as linhas do resultado:

WITH op_imoveis AS (
  SELECT DISTINCT id_referencia_bacen, numero_ordem, REPLACE(id_car, '-', '') AS id_car_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2023 AND id_car IS NOT NULL AND TRIM(id_car) <> ''
),
ops_pub AS (
  SELECT o.id_referencia_bacen, o.numero_ordem,
    MAX(o.valor_parcela_credito) AS valor_parcela_credito,
    MAX(o.area_financiada) AS area_financiada
  FROM `basedosdados.br_bcb_sicor.operacao` o
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` f USING (id_fonte_recurso)
  WHERE o.ano_emissao = 2023 AND f.indicador_recurso_publico = '1'
  GROUP BY 1, 2
),
cont AS (
  SELECT id_referencia_bacen, numero_ordem, COUNT(*) AS n
  FROM op_imoveis GROUP BY 1, 2
),
car AS (
  SELECT id_imovel, area, id_municipio
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
  QUALIFY ROW_NUMBER() OVER (PARTITION BY REPLACE(id_imovel, '-', '') ORDER BY data_extracao DESC) = 1
),
cred AS (
  SELECT c.id_imovel, c.area, c.id_municipio,
    SUM(p.valor_parcela_credito / n.n) AS credito,
    SUM(p.area_financiada / n.n) AS area_fin
  FROM ops_pub p
  JOIN cont n USING (id_referencia_bacen, numero_ordem)
  JOIN op_imoveis i USING (id_referencia_bacen, numero_ordem)
  JOIN car c ON REPLACE(c.id_imovel, '-', '') = i.id_car_norm
  GROUP BY 1, 2, 3
),
ids AS (
  SELECT * FROM UNNEST(['PA-1506187-94551B72659E427F961D2F62CEBA7392','MS-5006606-4693892971CF47B4B2684C3A94950BEE','PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A','BA-2921401-9177991E4861442EACFE3ACDDC06DB91','BA-2928109-0F43ABB998F5484394BAA55A4964A2BD','BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F','BA-2929057-C5D11EE026A64399A6EF36764E8739E9','BA-2913705-C31099AB04E24F15B9941AAAF17DC244','BA-2929057-2483416C90F94058B15FED07A5FE9FB7','RS-4322301-411110B140A543DB906D80C3081D1822','BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70','PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98','BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968','RS-4322301-249321677C5045DC84BE25A36C504F31','RS-4322301-8DD943476D08400A931895B8A17A8BA9','BA-2916500-9222A7C0C77E4E019B498875C6578189','BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB','BA-2902005-876B8A8CE62D40119A8446C4262A5AC7','RS-4322301-0BBDEB7272784E4DACA585E486AE37A9','BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6']) AS id_car
)
SELECT
  i.id_car,
  c.id_municipio,
  c.area AS area_car_ha,
  c.credito AS credito_publico_alocado,
  c.area_fin AS area_financiada_alocada,
  SAFE_DIVIDE(c.area_fin, c.area) * 100 AS razao_pct,
  (c.id_imovel IS NOT NULL) AS presente_no_recorte_publico
FROM ids i
LEFT JOIN cred c ON REPLACE(c.id_imovel, '-', '') = REPLACE(i.id_car, '-', '')
ORDER BY razao_pct DESC

## 4. ASSISTANT | 2026-11-20T03:59:31.910430Z

Identificador: `63f076b0-7d13-4b01-bbe3-5a1865aa9cc9`.

A execução foi concluída exatamente como enviada. O resultado contém **20 linhas**, na ordem retornada pelo BigQuery:

| id_car | id_municipio | area_car_ha | credito_publico_alocado | area_financiada_alocada | razao_pct | presente_no_recorte_publico |
|---|---:|---:|---:|---:|---:|:---:|
| PA-1506187-94551B72659E427F961D2F62CEBA7392 | 1506187 | 0.0001 | 2064413.3207142856 | 318.9294642857143 | 318929464.28571427 | true |
| MS-5006606-4693892971CF47B4B2684C3A94950BEE | 5006606 | 0.0001 | 779963.31 | 210.32 | 210320000.0 | true |
| PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A | 1506161 | 0.0001 | 899153.22 | 155.06 | 155060000.0 | true |
| BA-2921401-9177991E4861442EACFE3ACDDC06DB91 | 2921401 | 0.0001 | 402936.69999999995 | 117.0 | 117000000.0 | true |
| BA-2928109-0F43ABB998F5484394BAA55A4964A2BD | 2928109 | 0.0002 | 520000.0 | 151.17 | 75584999.99999999 | true |
| BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F | 2929057 | 0.0001 | 20000.0 | 68.27 | 68269999.99999999 | true |
| BA-2929057-C5D11EE026A64399A6EF36764E8739E9 | 2929057 | 0.0001 | 29556.66 | 61.86 | 61860000.0 | true |
| BA-2913705-C31099AB04E24F15B9941AAAF17DC244 | 2913705 | 0.0001 | 370819.2 | 60.55 | 60550000.0 | true |
| BA-2929057-2483416C90F94058B15FED07A5FE9FB7 | 2929057 | 0.0001 | 97163.54000000001 | 58.07 | 58070000.0 | true |
| RS-4322301-411110B140A543DB906D80C3081D1822 | 4322301 | 0.0001 | 236913.3333333333 | 53.46666666666667 | 53466666.666666664 | true |
| BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70 | 2930766 | 0.0001 | 207579.35 | 45.76 | 45759999.99999999 | true |
| PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98 | 1506187 | 0.0009 | 1947078.0 | 403.83 | 44870000.0 | true |
| BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968 | 2901601 | 0.0001 | 283131.16000000003 | 43.99 | 43990000.0 | true |
| RS-4322301-249321677C5045DC84BE25A36C504F31 | 4322301 | 0.0001 | 182000.0 | 40.06 | 40060000.0 | true |
| RS-4322301-8DD943476D08400A931895B8A17A8BA9 | 4322301 | 0.0001 | 189600.0 | 37.0 | 37000000.0 | true |
| BA-2916500-9222A7C0C77E4E019B498875C6578189 | 2916500 | 0.0001 | 159167.94 | 36.29 | 36290000.0 | true |
| BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB | 2929057 | 0.0002 | 49448.35 | 70.84 | 35420000.0 | true |
| BA-2902005-876B8A8CE62D40119A8446C4262A5AC7 | 2902005 | 0.0001 | 39292.64 | 33.339999999999996 | 33339999.999999993 | true |
| RS-4322301-0BBDEB7272784E4DACA585E486AE37A9 | 4322301 | 0.0001 | 158545.225 | 33.25 | 33250000.0 | true |
| BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6 | 2926509 | 0.0001 | 120113.49 | 33.04 | 33040000.0 | true |

## 5. USER | 2026-11-20T04:00:54.525316Z

Identificador: `696246e8-8adb-4aba-8297-90ab58e121c7`.

Execute exatamente este SQL no BigQuery, sem alterar nada, e me mostre todas as linhas do resultado:

WITH op_imoveis AS (
  SELECT DISTINCT id_referencia_bacen, numero_ordem, REPLACE(id_car, '-', '') AS id_car_norm
  FROM `basedosdados.br_bcb_sicor.recurso_publico_propriedade`
  WHERE ano_emissao = 2023 AND id_car IS NOT NULL AND TRIM(id_car) <> ''
),
ops_pub AS (
  SELECT o.id_referencia_bacen, o.numero_ordem,
    MAX(o.valor_parcela_credito) AS valor_parcela_credito,
    MAX(o.area_financiada) AS area_financiada
  FROM `basedosdados.br_bcb_sicor.operacao` o
  JOIN `basedosdados.br_bcb_sicor.fonte_recurso` f USING (id_fonte_recurso)
  WHERE o.ano_emissao = 2023 AND f.indicador_recurso_publico = '1'
  GROUP BY 1, 2
),
cont AS (
  SELECT id_referencia_bacen, numero_ordem, COUNT(*) AS n
  FROM op_imoveis GROUP BY 1, 2
),
car AS (
  SELECT id_imovel, area, id_municipio
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
  QUALIFY ROW_NUMBER() OVER (PARTITION BY REPLACE(id_imovel, '-', '') ORDER BY data_extracao DESC) = 1
),
cred AS (
  SELECT c.id_imovel, c.area, c.id_municipio,
    SUM(p.valor_parcela_credito / n.n) AS credito,
    SUM(p.area_financiada / n.n) AS area_fin
  FROM ops_pub p
  JOIN cont n USING (id_referencia_bacen, numero_ordem)
  JOIN op_imoveis i USING (id_referencia_bacen, numero_ordem)
  JOIN car c ON REPLACE(c.id_imovel, '-', '') = i.id_car_norm
  GROUP BY 1, 2, 3
)
SELECT
  COUNTIF(area < 1 AND area_fin > area) AS micros_gt100,
  SUM(IF(area < 1 AND area_fin > area, credito, 0)) AS valor_micros_gt100,
  COUNTIF(area_fin > area) AS imoveis_gt100
FROM cred

## 6. ASSISTANT | 2026-11-20T04:00:54.539321Z

Identificador: `21b72ce6-4446-4ca4-b5ed-8764fea6f8dd`.

A execução foi concluída exatamente como enviada. O resultado contém **1 linha**:

| micros_gt100 | valor_micros_gt100 | imoveis_gt100 |
|---:|---:|---:|
| 4.624 | 542.158.616,6764054 | 76.721 |

## 7. USER | 2026-11-20T05:04:12.650897Z

Identificador: `ec6ba797-58ba-4386-bf7b-a0cc3a43fd0c`.

Usando o dataset br_mapbiomas_estatisticas, execute uma consulta e me mostre todas as linhas: para o município de Rondon do Pará (id_municipio '1506187'), a área em hectares por classe de cobertura e uso da terra nos níveis 1 e 2, para os anos 2017, 2020 e o ano mais recente disponível. Depois, uma segunda consulta: a mesma coisa para o município de São Félix do Coribe (id_municipio '2929057'). Informe qual coleção do MapBiomas está na tabela e quais anos existem.

## 8. ASSISTANT | 2026-11-20T05:04:12.665353Z

Identificador: `e721c3d7-b6a4-4c52-b284-4fc6e46f3955`.

A tabela usa a **Coleção 11 do MapBiomas**. A cobertura disponível vai de **1985 a 2025**, portanto os anos consultados foram **2017, 2020 e 2025**, sendo 2025 o mais recente disponível. As áreas abaixo estão em hectares e foram agregadas por município, ano, bioma, nível 1 e nível 2. Valores exibidos com duas casas decimais.

## Rondon do Pará — id_municipio `1506187`

Bioma: **Amazônia**

| Ano | Nível 1 | Nível 2 | Área (ha) |
|---:|---|---|---:|
| 2017 | Agropecuária | Agricultura | 33.023,41 |
| 2017 | Agropecuária | Mosaico de Usos | 24.227,68 |
| 2017 | Agropecuária | Pastagem | 336.520,75 |
| 2017 | Agropecuária | Silvicultura | 2.176,45 |
| 2017 | Corpo d'Água | Rio, Lago e Oceano | 631,11 |
| 2017 | Floresta | Floresta Alagável | 3.462,27 |
| 2017 | Floresta | Formação Florestal | 420.153,87 |
| 2017 | Floresta | Formação Savânica | 32,61 |
| 2017 | Vegetação Herbácea e Arbustiva | Afloramento Rochoso | 237,90 |
| 2017 | Vegetação Herbácea e Arbustiva | Campo Alagado e Área Pantanosa | 57,57 |
| 2017 | Vegetação Herbácea e Arbustiva | Formação Campestre | 2.778,00 |
| 2017 | Área não Vegetada | Outras Áreas não Vegetadas | 486,23 |
| 2017 | Área não Vegetada | Área Urbanizada | 919,75 |
| 2020 | Agropecuária | Agricultura | 42.809,33 |
| 2020 | Agropecuária | Mosaico de Usos | 30.104,76 |
| 2020 | Agropecuária | Pastagem | 334.469,85 |
| 2020 | Agropecuária | Silvicultura | 2.081,60 |
| 2020 | Corpo d'Água | Rio, Lago e Oceano | 652,76 |
| 2020 | Floresta | Floresta Alagável | 3.432,58 |
| 2020 | Floresta | Formação Florestal | 406.620,61 |
| 2020 | Floresta | Formação Savânica | 31,10 |
| 2020 | Vegetação Herbácea e Arbustiva | Afloramento Rochoso | 236,39 |
| 2020 | Vegetação Herbácea e Arbustiva | Campo Alagado e Área Pantanosa | 60,16 |
| 2020 | Vegetação Herbácea e Arbustiva | Formação Campestre | 2.821,22 |
| 2020 | Área não Vegetada | Outras Áreas não Vegetadas | 461,97 |
| 2020 | Área não Vegetada | Área Urbanizada | 925,27 |
| 2025 | Agropecuária | Agricultura | 62.225,81 |
| 2025 | Agropecuária | Mosaico de Usos | 51.613,96 |
| 2025 | Agropecuária | Pastagem | 341.281,57 |
| 2025 | Agropecuária | Silvicultura | 1.134,61 |
| 2025 | Corpo d'Água | Rio, Lago e Oceano | 691,80 |
| 2025 | Floresta | Floresta Alagável | 3.280,02 |
| 2025 | Floresta | Formação Florestal | 360.506,30 |
| 2025 | Floresta | Formação Savânica | 6,77 |
| 2025 | Vegetação Herbácea e Arbustiva | Afloramento Rochoso | 214,92 |
| 2025 | Vegetação Herbácea e Arbustiva | Campo Alagado e Área Pantanosa | 43,49 |
| 2025 | Vegetação Herbácea e Arbustiva | Formação Campestre | 2.276,70 |
| 2025 | Área não Vegetada | Outras Áreas não Vegetadas | 468,31 |
| 2025 | Área não Vegetada | Área Urbanizada | 963,32 |

## São Félix do Coribe — id_municipio `2929057`

Bioma: **Caatinga**

| Ano | Nível 1 | Nível 2 | Área (ha) |
|---:|---|---|---:|
| 2017 | Agropecuária | Agricultura | 3.499,52 |
| 2017 | Agropecuária | Mosaico de Usos | 123,67 |
| 2017 | Agropecuária | Pastagem | 39.793,97 |
| 2017 | Agropecuária | Silvicultura | 40,58 |
| 2017 | Corpo d'Água | Rio, Lago e Oceano | 306,87 |
| 2017 | Floresta | Formação Florestal | 18.967,02 |
| 2017 | Floresta | Formação Savânica | 105.630,36 |
| 2017 | Vegetação Herbácea e Arbustiva | Afloramento Rochoso | 6.534,70 |
| 2017 | Área não Vegetada | Outras Áreas não Vegetadas | 4,35 |
| 2017 | Área não Vegetada | Área Urbanizada | 266,02 |
| 2020 | Agropecuária | Agricultura | 3.469,50 |
| 2020 | Agropecuária | Mosaico de Usos | 670,26 |
| 2020 | Agropecuária | Pastagem | 39.482,92 |
| 2020 | Agropecuária | Silvicultura | 42,23 |
| 2020 | Corpo d'Água | Rio, Lago e Oceano | 327,84 |
| 2020 | Floresta | Formação Florestal | 18.756,74 |
| 2020 | Floresta | Formação Savânica | 105.584,21 |
| 2020 | Vegetação Herbácea e Arbustiva | Afloramento Rochoso | 6.536,53 |
| 2020 | Área não Vegetada | Outras Áreas não Vegetadas | 5,14 |
| 2020 | Área não Vegetada | Área Urbanizada | 291,70 |
| 2025 | Agropecuária | Agricultura | 4.089,22 |
| 2025 | Agropecuária | Mosaico de Usos | 2.972,13 |
| 2025 | Agropecuária | Pastagem | 45.633,41 |
| 2025 | Agropecuária | Silvicultura | 29,34 |
| 2025 | Corpo d'Água | Rio, Lago e Oceano | 255,70 |
| 2025 | Floresta | Formação Florestal | 17.845,77 |
| 2025 | Floresta | Formação Savânica | 97.394,52 |
| 2025 | Vegetação Herbácea e Arbustiva | Afloramento Rochoso | 6.592,27 |
| 2025 | Área não Vegetada | Outras Áreas não Vegetadas | 33,42 |
| 2025 | Área não Vegetada | Área Urbanizada | 321,28 |

## 9. USER | 2026-11-20T21:05:04.822590Z

Identificador: `f309fb98-84a3-4d39-8413-ceaacdff0e3b`.

Liste os datasets e tabelas da Base dos Dados relacionados a dois temas: (1) CAR/SICAR (Cadastro Ambiental Rural, imóveis rurais) e (2) INCRA (assentamentos, SIGEF, SIPRA, certificação de imóveis). Para cada tabela encontrada, mostre o nome completo (dataset.tabela) e a lista de colunas. Quero saber se existe algo com data de inscrição, data de retificação, status/condição do CAR, e geometria oficial de assentamentos.

## 10. ASSISTANT | 2026-11-20T21:05:04.835427Z

Identificador: `cd92605d-c4d4-4fed-92ee-43d45cad488f`.

## Resultado da busca

### 1. CAR/SICAR

Foi encontrado o dataset **Cadastro Ambiental Rural (CAR)**, do Serviço Florestal Brasileiro, com o identificador `br_sfb_sicar`. Ele possui **10 tabelas**:

| Nome completo | Colunas |
|---|---|
| `br_sfb_sicar.app` | `area`, `condicao`, `data_extracao`, `geometria`, `id_imovel`, `id_municipio`, `sigla_uf`, `status`, `tipo` |
| `br_sfb_sicar.area_consolidada` | `area`, `condicao`, `data_extracao`, `geometria`, `id_imovel`, `id_municipio`, `sigla_uf`, `status`, `tipo` |
| `br_sfb_sicar.area_imovel` | `area`, `condicao`, `data_atualizacao`, `data_criacao`, `data_extracao`, `geometria`, `id_imovel`, `id_municipio`, `modulos_fiscais`, `sigla_uf`, `status`, `tipo` |
| `br_sfb_sicar.area_pousio` | `area`, `condicao`, `data_extracao`, `geometria`, `id_imovel`, `id_municipio`, `sigla_uf`, `status`, `tipo` |
| `br_sfb_sicar.dicionario` | `chave`, `cobertura_temporal`, `id_tabela`, `nome_coluna`, `valor` |
| `br_sfb_sicar.hidrografia` | `condicao`, `data_extracao`, `geometria`, `id_imovel`, `id_municipio`, `sigla_uf`, `status`, `tipo` |
| `br_sfb_sicar.reserva_legal` | `area`, `condicao`, `data_extracao`, `geometria`, `id_imovel`, `id_municipio`, `sigla_uf`, `status`, `tipo` |
| `br_sfb_sicar.servidao_administrativa` | `area`, `condicao`, `data_extracao`, `geometria`, `id_imovel`, `id_municipio`, `sigla_uf`, `status`, `tipo` |
| `br_sfb_sicar.uso_restrito` | `area`, `condicao`, `data_extracao`, `geometria`, `id_imovel`, `id_municipio`, `sigla_uf`, `status`, `tipo` |
| `br_sfb_sicar.vegetacao_nativa` | `area`, `condicao`, `data_extracao`, `geometria`, `id_imovel`, `id_municipio`, `sigla_uf`, `status`, `tipo` |

As colunas `geometria` são do tipo `GEOGRAPHY`, em coordenadas geográficas WGS84. As tabelas temáticas são organizadas por snapshots na coluna `data_extracao`, com cobertura identificada de **2 de junho de 2026 a 4 de agosto de 2026**.

### 2. INCRA

As buscas no catálogo por **INCRA**, **assentamentos**, **SIGEF**, **SIPRA** e **certificação de imóveis** não retornaram um dataset ou tabela identificado como pertencente ao INCRA.

Portanto, não foi encontrada no catálogo consultado uma tabela específica com:

- geometria oficial de perímetros de assentamentos do INCRA;
- cadastro de parcelas do SIGEF;
- registros do SIPRA;
- certificação de imóveis rurais pelo INCRA;
- datas e situações próprias dos processos do INCRA.

## Existência dos campos solicitados

| Informação | Existe? | Onde aparece |
|---|---:|---|
| Data de inscrição do CAR | **Sim** | `br_sfb_sicar.area_imovel.data_criacao` |
| Data de retificação/última alteração do CAR | **Parcialmente** | `br_sfb_sicar.area_imovel.data_atualizacao`, descrita como data da última modificação dos dados do imóvel; não há uma coluna explicitamente chamada “data de retificação” |
| Status do CAR | **Sim** | Coluna `status` nas tabelas do CAR; os códigos documentados são `AT` Ativo, `PE` Pendente, `SU` Suspenso e `CA` Cancelado |
| Condição da análise do CAR | **Sim** | Coluna `condicao`, referente à condição atual da análise no fluxo de validação pelo órgão competente |
| Geometria dos imóveis do CAR | **Sim** | `geometria` em `br_sfb_sicar.area_imovel` e nas tabelas temáticas |
| Geometria oficial de assentamentos do INCRA | **Não encontrada** | A tabela `area_imovel` possui `tipo`, incluindo `AST` — Assentamento de Reforma Agrária —, mas sua geometria é a do imóvel declarado no CAR, não uma geometria oficial do INCRA |

A tabela `br_sfb_sicar.area_imovel` é a mais adequada para informações cadastrais do imóvel: contém área, perímetro, datas, status, tipo do imóvel e geometria. A coluna `tipo` distingue, entre outros, `IRU` — Imóvel Rural, `AST` — Assentamento de Reforma Agrária, e `PCT` — Povos e Comunidades Tradicionais.

## 11. USER | 2026-11-20T21:07:14.577803Z

Identificador: `949e8b6e-edae-4662-9168-cbdcc64e27a7`.

Ótimo. Agora execute na tabela br_sfb_sicar.area_imovel, no snapshot mais recente de data_extracao, uma consulta com id_imovel, data_criacao, data_atualizacao, data_extracao, status, condicao, area, tipo, sigla_uf para estes 18 imóveis: PA-1506187-94551B72659E427F961D2F62CEBA7392, MS-5006606-4693892971CF47B4B2684C3A94950BEE, PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A, BA-2921401-9177991E4861442EACFE3ACDDC06DB91, BA-2928109-0F43ABB998F5484394BAA55A4964A2BD, BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F, BA-2913705-C31099AB04E24F15B9941AAAF17DC244, BA-2929057-2483416C90F94058B15FED07A5FE9FB7, RS-4322301-411110B140A543DB906D80C3081D1822, BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70, BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968, RS-4322301-249321677C5045DC84BE25A36C504F31, RS-4322301-8DD943476D08400A931895B8A17A8BA9, BA-2916500-9222A7C0C77E4E019B498875C6578189, BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB, BA-2902005-876B8A8CE62D40119A8446C4262A5AC7, RS-4322301-0BBDEB7272784E4DACA585E486AE37A9, BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6. Mostre a tabela completa de resultados e a query SQL executada. Depois consulte br_sfb_sicar.dicionario e me diga a definição oficial das colunas data_criacao e data_atualizacao.

## 12. ASSISTANT | 2026-11-20T21:07:14.590290Z

Identificador: `6a00a483-b1d2-4af3-8022-811a55b8a0eb`.

A consulta foi executada para os **18 imóveis**. Como os snapshots são disponibilizados por UF em datas diferentes, o último snapshot disponível para os imóveis solicitados variou entre **2026-08-01 e 2026-08-03**; não havia registros desses imóveis em `2026-08-04`. Os identificadores foram comparados sem os hífens para acomodar o formato armazenado na tabela.

## Resultado completo

| id_imovel | data_criacao | data_atualizacao | data_extracao | status | condicao | area | tipo | sigla_uf |
|---|---|---|---|---|---|---:|---|---|
| BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968 | 2022-06-23 | 2025-04-26 | 2026-08-02 | AT | Aguardando analise | 0,0001 | IRU | BA |
| BA-2902005-876B8A8CE62D40119A8446C4262A5AC7 | 2017-10-27 | 2025-11-06 | 2026-08-02 | AT | Aguardando analise | 0,0001 | IRU | BA |
| BA-2913705-C31099AB04E24F15B9941AAAF17DC244 | 2021-10-09 | 2025-10-11 | 2026-08-02 | AT | Aguardando analise | 0,0001 | IRU | BA |
| BA-2916500-9222A7C0C77E4E019B498875C6578189 | 2018-08-12 | 2024-03-11 | 2026-08-02 | AT | Aguardando analise | 0,0001 | IRU | BA |
| BA-2921401-9177991E4861442EACFE3ACDDC06DB91 | 2023-03-02 | 2025-09-19 | 2026-08-02 | AT | Aguardando analise | 0,0001 | IRU | BA |
| BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6 | 2023-03-15 | 2024-12-18 | 2026-08-02 | AT | Aguardando analise | 0,0001 | IRU | BA |
| BA-2928109-0F43ABB998F5484394BAA55A4964A2BD | 2020-06-18 | 2025-07-29 | 2026-08-02 | AT | Aguardando analise | 0,0002 | IRU | BA |
| BA-2929057-2483416C90F94058B15FED07A5FE9FB7 | 2019-12-10 | 2025-03-12 | 2026-08-02 | AT | Aguardando analise | 0,0001 | IRU | BA |
| BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F | 2019-09-03 | 2024-11-29 | 2026-08-02 | AT | Aguardando analise | 0,0001 | IRU | BA |
| BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB | 2019-04-22 | 2025-11-10 | 2026-08-02 | AT | Aguardando analise | 0,0002 | IRU | BA |
| BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70 | 2020-03-05 | 2024-07-03 | 2026-08-02 | AT | Aguardando analise | 0,0001 | IRU | BA |
| MS-5006606-4693892971CF47B4B2684C3A94950BEE | 2017-12-21 | 2024-04-03 | 2026-08-03 | AT | Aguardando analise | 0,0001 | IRU | MS |
| PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A | 2016-05-20 | 2025-10-18 | 2026-08-03 | PE | Analisado, aguardando atendimento a notificacao | 0,0001 | IRU | PA |
| PA-1506187-94551B72659E427F961D2F62CEBA7392 | 2015-11-20 | 2023-11-03 | 2026-08-03 | PE | Aguardando analise | 0,0001 | IRU | PA |
| RS-4322301-0BBDEB7272784E4DACA585E486AE37A9 | 2016-01-27 | 2026-07-16 | 2026-08-01 | AT | Aguardando analise | 0,0001 | IRU | RS |
| RS-4322301-249321677C5045DC84BE25A36C504F31 | 2016-01-19 | 2024-10-02 | 2026-08-01 | AT | Aguardando analise | 0,0001 | IRU | RS |
| RS-4322301-411110B140A543DB906D80C3081D1822 | 2015-12-17 | 2025-05-10 | 2026-08-01 | AT | Aguardando analise | 0,0001 | IRU | RS |
| RS-4322301-8DD943476D08400A931895B8A17A8BA9 | 2016-03-05 | 2025-05-07 | 2026-08-01 | AT | Aguardando analise | 0,0001 | IRU | RS |

`status` aparece como `AT` para 16 imóveis e `PE` para 2. Todos os imóveis retornaram `tipo = IRU`.

## SQL executado para os imóveis

```sql
WITH ids AS (
  SELECT id_imovel
  FROM UNNEST([
    'PA-1506187-94551B72659E427F961D2F62CEBA7392',
    'MS-5006606-4693892971CF47B4B2684C3A94950BEE',
    'PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A',
    'BA-2921401-9177991E4861442EACFE3ACDDC06DB91',
    'BA-2928109-0F43ABB998F5484394BAA55A4964A2BD',
    'BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F',
    'BA-2913705-C31099AB04E24F15B9941AAAF17DC244',
    'BA-2929057-2483416C90F94058B15FED07A5FE9FB7',
    'RS-4322301-411110B140A543DB906D80C3081D1822',
    'BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70',
    'BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968',
    'RS-4322301-249321677C5045DC84BE25A36C504F31',
    'RS-4322301-8DD943476D08400A931895B8A17A8BA9',
    'BA-2916500-9222A7C0C77E4E019B498875C6578189',
    'BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB',
    'BA-2902005-876B8A8CE62D40119A8446C4262A5AC7',
    'RS-4322301-0BBDEB7272784E4DACA585E486AE37A9',
    'BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6'
  ]) AS id_imovel
),
recente AS (
  SELECT
    a.id_imovel,
    a.data_criacao,
    a.data_atualizacao,
    a.data_extracao,
    a.status,
    a.condicao,
    a.area,
    a.tipo,
    a.sigla_uf,
    ROW_NUMBER() OVER (
      PARTITION BY REPLACE(a.id_imovel, '-', '')
      ORDER BY a.data_extracao DESC
    ) AS rn
  FROM `basedosdados.br_sfb_sicar.area_imovel` a
  WHERE a.data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
    AND REPLACE(a.id_imovel, '-', '') IN (
      SELECT REPLACE(id_imovel, '-', '') FROM ids
    )
)
SELECT
  i.id_imovel,
  r.data_criacao,
  r.data_atualizacao,
  r.data_extracao,
  r.status,
  r.condicao,
  r.area,
  r.tipo,
  r.sigla_uf
FROM ids i
LEFT JOIN recente r
  ON REPLACE(r.id_imovel, '-', '') = REPLACE(i.id_imovel, '-', '')
  AND r.rn = 1
ORDER BY i.id_imovel;
```

## Definições das datas

A consulta ao `br_sfb_sicar.dicionario` não retornou entradas para `data_criacao` ou `data_atualizacao`. As definições disponíveis nos metadados da tabela `area_imovel` são:

- **`data_criacao`**: “Data de inscrição do imóvel no CAR”.
- **`data_atualizacao`**: “Data da última modificação dos dados do imóvel no CAR”.

A consulta feita ao dicionário foi:

```sql
SELECT
  id_tabela,
  nome_coluna,
  valor
FROM `basedosdados.br_sfb_sicar.dicionario`
WHERE nome_coluna IN ('data_criacao', 'data_atualizacao')
ORDER BY id_tabela, nome_coluna, valor;
```

Como não há definição textual dessas duas colunas no dicionário, as descrições acima são as definições de metadados da tabela `area_imovel`.

## 13. USER | 2026-11-20T21:12:16.086665Z

Identificador: `15901bac-3893-4522-b1e8-43557c46d367`.

Controle de qualidade: execute a mesma consulta (id_imovel, data_criacao, data_atualizacao, data_extracao, status, condicao, area, tipo) em br_sfb_sicar.area_imovel, snapshot mais recente por imóvel, para estes 9 IDs cujas datas oficiais de inscrição eu já conheço por outra fonte: PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56, PA-1506187-48EDE9CDCF3947959921871671228876, PA-1506187-8A59FA2709F1467CB9659E8E433E29A2, PA-1506187-2FA6A081B1F745D4800249F665C9DE96, PA-1506187-A4DD4E93695C4B7DA32C7F0DB8CDE959, PA-1506187-34A1DD76FA7D40848D10832D82940BDA, PA-1506187-DAE50532EA2F4A3093A94AA2A6197177, PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98, BA-2929057-C5D11EE026A64399A6EF36764E8739E9. Mostre a tabela completa e a SQL. Depois responda: alguma das 10 tabelas do dataset br_sfb_sicar contém valores declarados de Reserva Legal ou APP (em hectares, por imóvel) ou histórico de retificações (lista de datas/alterações)? Liste quais tabelas teriam algo próximo disso.

## 14. ASSISTANT | 2026-11-20T21:12:16.101251Z

Identificador: `a3e8d27e-bb9a-43b6-bd89-edd542ab5bf8`.

A consulta retornou os **9 imóveis**. O snapshot mais recente disponível para eles é `2026-08-02` para o imóvel da BA e `2026-08-03` para os imóveis do PA.

## Resultado completo

| id_imovel | data_criacao | data_atualizacao | data_extracao | status | condicao | area | tipo |
|---|---|---|---|---|---|---:|---|
| BA-2929057-C5D11EE026A64399A6EF36764E8739E9 | 2019-10-14 | 2026-07-01 | 2026-08-02 | AT | Aguardando analise | 0,0001 | IRU |
| PA-1506187-2FA6A081B1F745D4800249F665C9DE96 | 2015-12-01 | 2025-04-03 | 2026-08-03 | PE | Aguardando analise | 0,0025 | IRU |
| PA-1506187-34A1DD76FA7D40848D10832D82940BDA | 2017-05-07 | 2025-04-15 | 2026-08-03 | PE | Analisado, aguardando atendimento a notificacao | 0,0009 | IRU |
| PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56 | 2016-04-28 | 2023-06-06 | 2026-08-03 | PE | Aguardando analise | 1.350,2239 | IRU |
| PA-1506187-48EDE9CDCF3947959921871671228876 | 2026-03-26 | 2026-03-26 | 2026-08-03 | PE | Analisado, aguardando atendimento a notificacao | 1.288,0856 | IRU |
| PA-1506187-8A59FA2709F1467CB9659E8E433E29A2 | 2020-10-23 | 2025-04-02 | 2026-08-03 | PE | Aguardando analise | 0,0025 | IRU |
| PA-1506187-A4DD4E93695C4B7DA32C7F0DB8CDE959 | 2016-12-30 | 2025-04-03 | 2026-08-03 | PE | Aguardando analise | 0,0025 | IRU |
| PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98 | 2015-11-26 | 2025-04-16 | 2026-08-03 | PE | Analisado, aguardando atendimento a notificacao | 0,0009 | IRU |
| PA-1506187-DAE50532EA2F4A3093A94AA2A6197177 | 2020-10-27 | 2025-04-15 | 2026-08-03 | PE | Analisado, aguardando atendimento a notificacao | 0,0009 | IRU |

O resultado tem **8 imóveis com status `PE`** e **1 com status `AT`**. Todos têm `tipo = IRU`.

## SQL executada

```sql
WITH ids AS (
  SELECT id_imovel
  FROM UNNEST([
    'PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56',
    'PA-1506187-48EDE9CDCF3947959921871671228876',
    'PA-1506187-8A59FA2709F1467CB9659E8E433E29A2',
    'PA-1506187-2FA6A081B1F745D4800249F665C9DE96',
    'PA-1506187-A4DD4E93695C4B7DA32C7F0DB8CDE959',
    'PA-1506187-34A1DD76FA7D40848D10832D82940BDA',
    'PA-1506187-DAE50532EA2F4A3093A94AA2A6197177',
    'PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98',
    'BA-2929057-C5D11EE026A64399A6EF36764E8739E9'
  ]) AS id_imovel
),
recente AS (
  SELECT
    a.id_imovel,
    a.data_criacao,
    a.data_atualizacao,
    a.data_extracao,
    a.status,
    a.condicao,
    a.area,
    a.tipo,
    ROW_NUMBER() OVER (
      PARTITION BY REPLACE(a.id_imovel, '-', '')
      ORDER BY a.data_extracao DESC
    ) AS rn
  FROM `basedosdados.br_sfb_sicar.area_imovel` a
  WHERE a.data_extracao BETWEEN '2026-06-02' AND '2026-08-04'
    AND REPLACE(a.id_imovel, '-', '') IN (
      SELECT REPLACE(id_imovel, '-', '') FROM ids
    )
)
SELECT
  i.id_imovel,
  r.data_criacao,
  r.data_atualizacao,
  r.data_extracao,
  r.status,
  r.condicao,
  r.area,
  r.tipo
FROM ids i
LEFT JOIN recente r
  ON REPLACE(r.id_imovel, '-', '') = REPLACE(i.id_imovel, '-', '')
  AND r.rn = 1
ORDER BY i.id_imovel;
```

## Reserva Legal, APP e histórico de retificações

### Valores declarados de APP por imóvel

**Sim.** A tabela `br_sfb_sicar.app` contém:

- `id_imovel`;
- `area`, em hectares;
- `data_extracao`;
- `status`;
- `condicao`;
- `geometria`;
- `tipo` da APP.

Como pode haver vários polígonos por imóvel, o valor total por imóvel deve ser obtido agregando `SUM(area)` após filtrar o snapshot desejado e, se necessário, o tipo de APP.

### Valores declarados de Reserva Legal por imóvel

**Sim.** A tabela `br_sfb_sicar.reserva_legal` contém a mesma estrutura essencial:

- `id_imovel`;
- `area`, em hectares;
- `data_extracao`;
- `status`;
- `condicao`;
- `geometria`;
- `tipo` da Reserva Legal.

Ela é a tabela adequada para somar a área declarada de Reserva Legal por imóvel. A coluna `tipo` registra a situação da Reserva Legal, como proposta, averbada, aprovada e não averbada.

### Histórico de retificações

**Não foi encontrada uma tabela histórica de retificações**, isto é, uma lista de eventos com todas as datas e alterações sucessivas de cada imóvel.

O que existe é:

- `br_sfb_sicar.area_imovel.data_atualizacao`: data da última modificação dos dados do imóvel;
- `data_extracao`: data do snapshot disponibilizado para a UF;
- repetição dos registros em snapshots diferentes, quando o imóvel aparece em mais de uma extração.

Esses campos permitem comparar snapshots e identificar mudanças entre versões disponíveis, mas não constituem um histórico explícito de retificações com o detalhe de cada alteração.

### Tabelas mais próximas do que foi solicitado

| Necessidade | Tabela | O que contém |
|---|---|---|
| APP declarada | `br_sfb_sicar.app` | Polígonos e áreas de APP por imóvel, com status, condição e snapshot |
| Reserva Legal declarada | `br_sfb_sicar.reserva_legal` | Polígonos e áreas de Reserva Legal por imóvel, com tipo, status, condição e snapshot |
| Data cadastral e última alteração | `br_sfb_sicar.area_imovel` | `data_criacao`, `data_atualizacao`, `data_extracao`, status, condição, área e geometria do imóvel |
| Comparação entre versões | Todas as tabelas temáticas com `data_extracao` | Permitem comparar snapshots, mas não fornecem um log formal de retificações |
| Outros temas ambientais declarados | `area_consolidada`, `area_pousio`, `hidrografia`, `servidao_administrativa`, `uso_restrito`, `vegetacao_nativa` | Áreas e geometrias temáticas por imóvel, também organizadas por snapshot |

## 15. USER | 2026-11-20T21:44:41.931202Z

Identificador: `20c68f10-69b5-4cf5-8707-f6f5fa537237`.

Agora quero as areas AMBIENTAIS DECLARADAS dos mesmos imoveis. Para cada id_imovel da lista abaixo (22 ids), consulte as tabelas br_sfb_sicar.app e br_sfb_sicar.reserva_legal no snapshot mais recente de cada imovel e retorne: (1) por id_imovel, a soma de area (ha) de APP por tipo/situacao; (2) por id_imovel, a soma de area (ha) de reserva legal por tipo/situacao (ex.: proposta, averbada); (3) marque explicitamente os imoveis SEM nenhum poligono nessas duas tabelas. Liste tambem o nome exato das colunas usadas e a data_extracao de cada imovel. Gere um CSV para download com uma linha por id_imovel x tabela x tipo. IDs:
PA-1506187-94551B72659E427F961D2F62CEBA7392
MS-5006606-4693892971CF47B4B2684C3A94950BEE
PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A
BA-2921401-9177991E4861442EACFE3ACDDC06DB91
BA-2928109-0F43ABB998F5484394BAA55A4964A2BD
BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F
BA-2929057-C5D11EE026A64399A6EF36764E8739E9
BA-2913705-C31099AB04E24F15B9941AAAF17DC244
BA-2929057-2483416C90F94058B15FED07A5FE9FB7
RS-4322301-411110B140A543DB906D80C3081D1822
BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70
PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98
BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968
RS-4322301-249321677C5045DC84BE25A36C504F31
RS-4322301-8DD943476D08400A931895B8A17A8BA9
BA-2916500-9222A7C0C77E4E019B498875C6578189
BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB
BA-2902005-876B8A8CE62D40119A8446C4262A5AC7
RS-4322301-0BBDEB7272784E4DACA585E486AE37A9
BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6
PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56
PA-1506187-48EDE9CDCF3947959921871671228876

## 16. ASSISTANT | 2026-11-20T21:44:41.946930Z

Identificador: `fc07745d-9ca1-4d8c-960f-420f264c2a13`.

Foram consultadas as tabelas `app` e `reserva_legal`, selecionando o snapshot mais recente disponível por imóvel em cada tabela e somando `area` por `tipo`. O resultado tem **44 linhas**: uma linha para cada combinação dos 22 imóveis com cada uma das duas tabelas; quando não havia polígono, foi incluída uma linha explícita com `tem_poligono = false` e área zero.

O CSV está disponível para download: **`areas_ambientais_declaradas_corrigido.csv`**.

## Resultado completo

| id_imovel | tabela | data_extracao | tipo_codigo | tipo | area_ha | tem_poligono |
|---|---|---|---|---|---:|:---:|
| BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968 | app | — | — | — | 0 | false |
| BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968 | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0001 | true |
| BA-2902005-876B8A8CE62D40119A8446C4262A5AC7 | app | — | — | — | 0 | false |
| BA-2902005-876B8A8CE62D40119A8446C4262A5AC7 | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0001 | true |
| BA-2913705-C31099AB04E24F15B9941AAAF17DC244 | app | — | — | — | 0 | false |
| BA-2913705-C31099AB04E24F15B9941AAAF17DC244 | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0001 | true |
| BA-2916500-9222A7C0C77E4E019B498875C6578189 | app | — | — | — | 0 | false |
| BA-2916500-9222A7C0C77E4E019B498875C6578189 | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0001 | true |
| BA-2921401-9177991E4861442EACFE3ACDDC06DB91 | app | — | — | — | 0 | false |
| BA-2921401-9177991E4861442EACFE3ACDDC06DB91 | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0001 | true |
| BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6 | app | — | — | — | 0 | false |
| BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6 | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0001 | true |
| BA-2928109-0F43ABB998F5484394BAA55A4964A2BD | app | — | — | — | 0 | false |
| BA-2928109-0F43ABB998F5484394BAA55A4964A2BD | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0002 | true |
| BA-2929057-2483416C90F94058B15FED07A5FE9FB7 | app | — | — | — | 0 | false |
| BA-2929057-2483416C90F94058B15FED07A5FE9FB7 | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0001 | true |
| BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F | app | — | — | — | 0 | false |
| BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0001 | true |
| BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB | app | — | — | — | 0 | false |
| BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0002 | true |
| BA-2929057-C5D11EE026A64399A6EF36764E8739E9 | app | — | — | — | 0 | false |
| BA-2929057-C5D11EE026A64399A6EF36764E8739E9 | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0001 | true |
| BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70 | app | — | — | — | 0 | false |
| BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70 | reserva_legal | 2026-08-02 | ARL_PROPOSTA | Reserva Legal proposta | 0,0001 | true |
| MS-5006606-4693892971CF47B4B2684C3A94950BEE | app | 2026-08-03 | APP_ESCADINHA_RIO_ATE_10 | Área de Preservação Permanente a recompor de rios de até 10 metros | 2,1185 | true |
| MS-5006606-4693892971CF47B4B2684C3A94950BEE | reserva_legal | — | — | — | 0 | false |
| PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A | app | — | — | — | 0 | false |
| PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A | reserva_legal | — | — | — | 0 | false |
| PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56 | app | 2026-08-03 | APP_NASCENTE_OLHO_DAGUA | Área de Preservação Permanente de nascentes ou olhos d'água perenes | 0,7691 | true |
| PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56 | reserva_legal | 2026-08-03 | ARL_PROPOSTA | Reserva Legal proposta | 621,48 | true |
| PA-1506187-48EDE9CDCF3947959921871671228876 | app | 2026-08-03 | APP_RIO_ATE_10 | Área de Preservação Permanente de rios de até 10 metros | 1,8243 | true |
| PA-1506187-48EDE9CDCF3947959921871671228876 | reserva_legal | 2026-08-03 | ARL_PROPOSTA | Reserva Legal proposta | 651,7045 | true |
| PA-1506187-94551B72659E427F961D2F62CEBA7392 | app | — | — | — | 0 | false |
| PA-1506187-94551B72659E427F961D2F62CEBA7392 | reserva_legal | — | — | — | 0 | false |
| PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98 | app | — | — | — | 0 | false |
| PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98 | reserva_legal | — | — | — | 0 | false |
| RS-4322301-0BBDEB7272784E4DACA585E486AE37A9 | app | — | — | — | 0 | false |
| RS-4322301-0BBDEB7272784E4DACA585E486AE37A9 | reserva_legal | — | — | — | 0 | false |
| RS-4322301-249321677C5045DC84BE25A36C504F31 | app | — | — | — | 0 | false |
| RS-4322301-249321677C5045DC84BE25A36C504F31 | reserva_legal | 2026-08-01 | ARL_PROPOSTA | Reserva Legal proposta | 0,0001 | true |
| RS-4322301-411110B140A543DB906D80C3081D1822 | app | — | — | — | 0 | false |
| RS-4322301-411110B140A543DB906D80C3081D1822 | reserva_legal | — | — | — | 0 | false |
| RS-4322301-8DD943476D08400A931895B8A17A8BA9 | app | — | — | — | 0 | false |
| RS-4322301-8DD943476D08400A931895B8A17A8BA9 | reserva_legal | — | — | — | 0 | false |

## Imóveis sem nenhum polígono em APP e Reserva Legal

Os seis imóveis abaixo não possuem polígono em **nenhuma das duas tabelas** no snapshot consultado:

- `PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A`
- `PA-1506187-94551B72659E427F961D2F62CEBA7392`
- `PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98`
- `RS-4322301-0BBDEB7272784E4DACA585E486AE37A9`
- `RS-4322301-411110B140A543DB906D80C3081D1822`
- `RS-4322301-8DD943476D08400A931895B8A17A8BA9`

Há ainda imóveis com polígono em apenas uma das tabelas: o imóvel do MS possui apenas APP; os imóveis `RS-4322301-249321677C5045DC84BE25A36C504F31` e os dez imóveis da BA possuem apenas Reserva Legal.

## 17. USER | 2026-11-20T21:47:33.649511Z

Identificador: `0e342f83-fedf-4d27-bc90-170001fe5725`.

Aprofundando a consulta anterior (mesmos 22 ids, tabelas br_sfb_sicar.app, br_sfb_sicar.reserva_legal e br_sfb_sicar.area_imovel, snapshot mais recente por imovel). Preciso de quatro coisas, com SQL executado e CSV para download:
(1) a coluna condicao (ou equivalente) das geometrias de app e reserva_legal desses imoveis;
(2) para cada um dos 13 micros que tem apenas Reserva Legal proposta (~0,0001-0,0002 ha): a area exata da RL com 6 casas decimais, a area exata do imovel em area_imovel com 6 casas, e a porcentagem do poligono da RL que intersecta o poligono do imovel (ST_AREA da ST_INTERSECTION dividida pela ST_AREA da RL);
(3) para os CARs PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56 e PA-1506187-48EDE9CDCF3947959921871671228876: a area da intersecao entre os poligonos de reserva_legal dos dois (ha) e o percentual em relacao a cada uma;
(4) para o micro MS-5006606-4693892971CF47B4B2684C3A94950BEE: a area exata do poligono de APP e a porcentagem dele que intersecta o poligono do imovel.
IDs (22):
PA-1506187-94551B72659E427F961D2F62CEBA7392
MS-5006606-4693892971CF47B4B2684C3A94950BEE
PA-1506161-EE5157E8CA8B4DF280FC7F9D371FF17A
BA-2921401-9177991E4861442EACFE3ACDDC06DB91
BA-2928109-0F43ABB998F5484394BAA55A4964A2BD
BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F
BA-2929057-C5D11EE026A64399A6EF36764E8739E9
BA-2913705-C31099AB04E24F15B9941AAAF17DC244
BA-2929057-2483416C90F94058B15FED07A5FE9FB7
RS-4322301-411110B140A543DB906D80C3081D1822
BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70
PA-1506187-CEAD1A3AC3E14F5DB2FC0B93E54E7E98
BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968
RS-4322301-249321677C5045DC84BE25A36C504F31
RS-4322301-8DD943476D08400A931895B8A17A8BA9
BA-2916500-9222A7C0C77E4E019B498875C6578189
BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB
BA-2902005-876B8A8CE62D40119A8446C4262A5AC7
RS-4322301-0BBDEB7272784E4DACA585E486AE37A9
BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6
PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56
PA-1506187-48EDE9CDCF3947959921871671228876

## 18. ASSISTANT | 2026-11-20T21:47:33.663251Z

Identificador: `feb8be91-cd72-4491-beef-a893eb2dbeb9`.

As consultas espaciais foram divididas em quatro execuções para respeitar o limite de processamento do BigQuery. Os quatro CSVs estão prontos para download:

- `condicoes_ambientais.csv`
- `micros_rl_intersecao_imovel_corrigido.csv`
- `intersecao_rl_dois_cars.csv`
- `ms_app_intersecao_imovel.csv`

## 1. Condição das geometrias

Foram encontrados registros nas tabelas ambientais para os seguintes imóveis:

| id_imovel | tabela | data_extracao | condicao | n_geometrias |
|---|---|---|---|---:|
| BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968 | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| BA-2902005-876B8A8CE62D40119A8446C4262A5AC7 | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| BA-2913705-C31099AB04E24F15B9941AAAF17DC244 | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| BA-2916500-9222A7C0C77E4E019B498875C6578189 | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| BA-2921401-9177991E4861442EACFE3ACDDC06DB91 | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6 | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| BA-2928109-0F43ABB998F5484394BAA55A4964A2BD | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| BA-2929057-2483416C90F94058B15FED07A5FE9FB7 | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| BA-2929057-C5D11EE026A64399A6EF36764E8739E9 | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70 | reserva_legal | 2026-08-02 | Aguardando analise | 1 |
| MS-5006606-4693892971CF47B4B2684C3A94950BEE | app | 2026-08-03 | Aguardando analise | 1 |
| PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56 | app | 2026-08-03 | Aguardando analise | 99 |
| PA-1506187-3F4B7241FA0D4F60B91CCE115953FD56 | reserva_legal | 2026-08-03 | Aguardando analise | 1 |
| PA-1506187-48EDE9CDCF3947959921871671228876 | app | 2026-08-03 | Analisado, aguardando atendimento a notificacao | 15 |
| PA-1506187-48EDE9CDCF3947959921871671228876 | reserva_legal | 2026-08-03 | Analisado, aguardando atendimento a notificacao | 1 |
| RS-4322301-249321677C5045DC84BE25A36C504F31 | reserva_legal | 2026-08-01 | Aguardando analise | 1 |

Os demais imóveis da lista não apresentaram geometria nas tabelas `app` ou `reserva_legal` nos snapshots consultados.

## 2. Micros com Reserva Legal proposta

A interseção foi calculada sobre as geometrias agregadas por imóvel com `ST_UNION_AGG`. As áreas geométricas foram calculadas com `ST_AREA(geometria) / 10000` e arredondadas para seis casas decimais.

| id_imovel | data_extracao | area_rl_ha | area_imovel_ha | area_intersecao_ha | percentual_rl_intersecta_imovel |
|---|---|---:|---:|---:|---:|
| BA-2901601-2D6EA3618F4A48BF87E2EB78992B2968 | 2026-08-02 | 0,000108 | 0,000100 | 0,000108 | 100,000000% |
| BA-2902005-876B8A8CE62D40119A8446C4262A5AC7 | 2026-08-02 | 0,000100 | 0,000100 | 0,000100 | 100,000000% |
| BA-2913705-C31099AB04E24F15B9941AAAF17DC244 | 2026-08-02 | 0,000066 | 0,000100 | 0,000066 | 100,000000% |
| BA-2916500-9222A7C0C77E4E019B498875C6578189 | 2026-08-02 | 0,000107 | 0,000100 | 0,000107 | 100,000000% |
| BA-2921401-9177991E4861442EACFE3ACDDC06DB91 | 2026-08-02 | 0,000121 | 0,000100 | 0,000121 | 100,000000% |
| BA-2926509-E3BCDCD3078C4BADBC80D0166EACCAF6 | 2026-08-02 | 0,000137 | 0,000100 | 0,000137 | 100,000000% |
| BA-2928109-0F43ABB998F5484394BAA55A4964A2BD | 2026-08-02 | 0,000181 | 0,000200 | 0,000181 | 100,000000% |
| BA-2929057-2483416C90F94058B15FED07A5FE9FB7 | 2026-08-02 | 0,000106 | 0,000100 | 0,000106 | 100,000000% |
| BA-2929057-3DE9EF4059BE416EBC88EAAE603F1B5F | 2026-08-02 | 0,000148 | 0,000100 | 0,000148 | 100,000000% |
| BA-2929057-60EC867CE3FF4AEAA712CD4AE3992CCB | 2026-08-02 | 0,000162 | 0,000200 | 0,000162 | 100,000000% |
| BA-2929057-C5D11EE026A64399A6EF36764E8739E9 | 2026-08-02 | 0,000060 | 0,000100 | 0,000060 | 100,000000% |
| BA-2930766-9CCE04D4FED440E0844D0C38B9C89B70 | 2026-08-02 | 0,000109 | 0,000100 | 0,000109 | 100,000000% |
| RS-4322301-249321677C5045DC84BE25A36C504F31 | 2026-08-01 | 0,000150 | 0,000100 | 0,000150 | 100,000000% |

## 3. Interseção entre as duas Reservas Legais do PA

| data_extracao_a | data_extracao_b | area_rl_a_ha | area_rl_b_ha | area_intersecao_ha | percentual_sobre_a | percentual_sobre_b |
|---|---|---:|---:|---:|---:|---:|
| 2026-08-03 | 2026-08-03 | 623,050325 | 653,350278 | 583,743544 | 93,691235% | 89,346184% |

A interseção corresponde a **583,743544 hectares**; ela representa **93,691235%** da RL do primeiro CAR e **89,346184%** da RL do segundo.

## 4. APP do imóvel do MS

| data_extracao | area_app_ha | area_imovel_ha | area_intersecao_ha | percentual_app_intersecta_imovel |
|---|---:|---:|---:|---:|
| 2026-08-03 | 2,125113 | 0,000100 | 0,000000 | 0,000000% |

## SQL executado

As execuções finais foram divididas em quatro consultas: condições, micros com RL, interseção entre as duas RLs do PA e APP do MS. A lógica principal das quatro foi:

```sql
-- Condições: seleciona os snapshots de 2026-08-01 a 2026-08-03,
-- mantém apenas os 22 IDs e escolhe a data mais recente por imóvel e tabela.
WITH fontes AS (
  SELECT id_imovel, 'app' AS tabela, data_extracao, condicao
  FROM `basedosdados.br_sfb_sicar.app`
  WHERE data_extracao IN ('2026-08-01','2026-08-02','2026-08-03')
    AND id_imovel IN (<os 22 IDs informados>)
  UNION ALL
  SELECT id_imovel, 'reserva_legal', data_extracao, condicao
  FROM `basedosdados.br_sfb_sicar.reserva_legal`
  WHERE data_extracao IN ('2026-08-01','2026-08-02','2026-08-03')
    AND id_imovel IN (<os 22 IDs informados>)
)
SELECT id_imovel, tabela, data_extracao, condicao,
       COUNT(*) AS n_geometrias
FROM fontes
QUALIFY data_extracao = MAX(data_extracao)
  OVER (PARTITION BY id_imovel, tabela)
GROUP BY id_imovel, tabela, data_extracao, condicao;
```

Para os 13 micros, a consulta final usou esta forma:

```sql
WITH rl AS (
  SELECT id_imovel, data_extracao, geometria
  FROM `basedosdados.br_sfb_sicar.reserva_legal`
  WHERE (
      (data_extracao = '2026-08-02' AND STARTS_WITH(id_imovel, 'BA-'))
      OR (data_extracao = '2026-08-01' AND STARTS_WITH(id_imovel, 'RS-'))
    )
    AND id_imovel IN (<os 13 IDs dos micros>)
),
area_imovel AS (
  SELECT id_imovel, data_extracao, area, geometria
  FROM `basedosdados.br_sfb_sicar.area_imovel`
  WHERE data_extracao IN ('2026-08-01', '2026-08-02')
    AND sigla_uf IN ('BA', 'RS')
    AND id_imovel IN (<os 13 IDs dos micros>)
),
rl_agregada AS (
  SELECT id_imovel, MAX(data_extracao) AS data_extracao,
         ST_UNION_AGG(geometria) AS geom_rl
  FROM rl
  GROUP BY id_imovel
),
imovel_recente AS (
  SELECT *
  FROM area_imovel
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY id_imovel ORDER BY data_extracao DESC
  ) = 1
)
SELECT
  r.id_imovel,
  r.data_extracao,
  ROUND(ST_AREA(r.geom_rl) / 10000, 6) AS area_rl_ha,
  ROUND(i.area, 6) AS area_imovel_ha,
  ROUND(ST_AREA(ST_INTERSECTION(r.geom_rl, i.geometria)) / 10000, 6)
    AS area_intersecao_ha,
  ROUND(SAFE_DIVIDE(
    ST_AREA(ST_INTERSECTION(r.geom_rl, i.geometria)),
    ST_AREA(r.geom_rl)
  ) * 100, 6) AS percentual_rl_intersecta_imovel
FROM rl_agregada r
JOIN imovel_recente i USING (id_imovel);
```

Para as duas RLs do PA, a consulta usou `ST_UNION_AGG` para cada CAR e depois:

```sql
ST_AREA(ST_INTERSECTION(geom_rl_a, geom_rl_b)) / 10000
```

Os percentuais foram calculados dividindo essa área de interseção pela área geométrica de cada RL. Para o MS, a mesma lógica foi aplicada entre `ST_UNION_AGG(geometria)` da APP e a geometria de `area_imovel`.

As colunas de origem usadas foram `id_imovel`, `data_extracao`, `condicao`, `geometria` e `area`; em `area_imovel`, também `area` e `geometria`. A coluna `tipo` não foi usada nos cálculos espaciais desta etapa.

