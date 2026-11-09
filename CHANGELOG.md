# Changelog

## v0.1.2 (08/11/2026)
- Segunda varredura independente de dados pessoais no campo `objeto`: 785 CPFs válidos por dígito verificador em formatações não cobertas pela v0.1.1 (sem pontuação, com espaços, mista), 101 ocorrências adicionais em contexto de CPF, 212 números de RG, 192 e-mails de provedores pessoais e 21 endereços residenciais co-ocorrentes mascarados. Resíduo zero na reverificação dos padrões; 494.446 linhas preservadas (contagem idêntica por UF/ano). Manifesto novo (manifest_v012.json); manifest_v01.json cobre apenas os arquivos inalterados.
- `ferramentas`: `duplicatas_auditoria.parquet` recebeu o mesmo tratamento.
- Passada complementar (mesma edição): 48 números de documentos de identidade em grafias alternativas ("Doc./Carteira/Cédula de Identidade", variações de caixa), 2 endereços residenciais restantes e 123 nomes de famílias beneficiárias de auxílio-moradia/aluguel social mascarados. Reverificação independente: resíduo zero dos padrões; 494.446 linhas preservadas.

## v0.1.1 (08/11/2026)
- Primeira edição saneada: 2.504 CPFs pontuados, 1.784 sequências de 11 dígitos com contexto de CPF, 38 RGs e 37 endereços residenciais co-ocorrentes com CPF/RG mascarados no campo `objeto`. Nomes de pessoas físicas mantidos (decisão editorial). Preparada após a retirada temporária do download público da v0.1.

## v0.1 (08/11/2026)
- Primeira publicação, no repositório Descoberta Pública (GitHub). Licenças adotadas pelo autor: MIT (código) e CC BY 4.0 (curadoria, documentação e derivados); textos em LICENSE-CODE e LICENSE-DATA. README reescrito para o repositório; conteúdo de dados, ferramentas e derivados idêntico ao candidato v0.1.

## v0.1-candidata (08/11/2026)
- Pacote candidato à publicação, derivado do acervo consolidado (recorte: modalidade inexigibilidade, publicação 01/01/2025 a 06/11/2026; lacuna 22–31/08/2026; 494.446 registros).
- Removida a coluna interna de proveniência com links restritos (`url_drive_origem`); contagens conferidas após a transformação.
- Derivados incluídos: classificação do objeto v6.3 (sidecar, resumos, validação amostral, classificador). Sinais exploratórios de triagem (anomalias, descobertas temáticas) ficaram fora deste candidato — material exploratório ponto-a-ponto, não camada de reutilização; seguem no pacote privado completo.
- Docs reescritos para o escopo do candidato: dicionário com semântica real de `link_origem` e nota de fuso; limitações com lacuna de agosto explícita; licença em proposta de duas faixas (código MIT, curadoria CC BY 4.0) com distinção entre permissões lidas e licença nominal não localizada.
- Manifesto com SHA256 de todos os arquivos do candidato.

## v0.0 (06/11/2026)
- Consolidação interna: 27 UFs + complemento, dedupe, dimensão de municípios, manifestos com SHA256 dos 621 arquivos brutos (100% verificados).
