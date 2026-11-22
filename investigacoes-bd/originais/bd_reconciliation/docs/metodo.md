# Método de reconciliação (consolidado das investigações executadas na BD)

Sequência que resolveu os 4 relacionamentos registrados. O componente (`reconcile.py`) parametriza essas etapas por configuração; as etapas 3–5 são as que exigem diagnóstico real e são a contribuição central.

1. **Inspeção de formato das chaves**: comprimento, caracteres, presença de nulos/vazios. (Ex.: `id_car` sem hífen 41 chars vs `id_imovel` com hífen 43 chars.)
2. **Join literal de controle**: mede a falha bruta. No SICOR×CAR deu exatamente 0 correspondências; o zero é o sintoma de incompatibilidade de representação, não de ausência de relação.
3. **Diagnóstico de representação**: comparar amostras das chaves dos dois lados; identificar diferenças de case, espaços, separadores e formato estrutural (ex.: `UF-cod_munic-uuid` embutido no `id_imovel`).
4. **Normalização parametrizada**: `REPLACE(UPPER(TRIM(chave)), '-', '')` nos dois lados. Guardar a transformação na config, não em SQL solto.
5. **Alinhamento temporal/snapshot**: quando um lado é particionado por extração (CAR por UF/data_extracao), unir os snapshots relevantes antes do join.
6. **Cobertura por denominação explícita**: sempre declarar o denominador (registros vs ids distintos; termos preenchidos vs todos os registros). O caso IBAMA mostra que 99,94% e 82,77% são as duas leituras honestas do mesmo join.
7. **Classificação de resíduos**: a) erro de formatação de chave (corrigível por normalização); b) ausência real de registro no diretório (ex.: subclasses CNAE 9999999, 8630505); c) granularidade (join correto, grão de agregação inadequado). Registrar a classe observada na config.
8. **Regressão de números de destaque**: ao reexecutar, comparar as coberturas com os números registrados (`report.py`); divergência > tolerância (0,01pp) trava o relatório.

## Transferência demonstrada

- SICOR×CAR → PRODES×MapBiomas e RAIS×CNAE e IBAMA autos×embargos: mesma suite de diagnóstico, configurações distintas (chave composta, diretório, chave direta). Nenhuma linha de código alterada entre os casos.
- O componente cobre o que foi efetivamente executado; a suite 04 (cobertura) gera a forma-base do join, e refinamentos caso a caso (unir snapshots por UF) ficam registrados na config como `alinhamento_temporal`.
