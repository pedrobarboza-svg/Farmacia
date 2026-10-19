# Tasks

## 1. Canonicalizar o schema e migrar os dados

- [ ] 1.1 Inspecionar no Xano os schemas e registros efetivos de `categorias` e `produtos`, identificar referências e campos antigos; verificar a inspeção com um inventário de contagens, nulidades e conflitos antes de qualquer alteração.
- [ ] 1.2 Fazer backup e mapear `preco_unitario` para `preco` e `quantidade_estoque` para `estoque`, resolvendo valores ausentes ou conflitantes com fonte confirmada; verificar o mapeamento comparando amostras e totais antes/depois.
- [ ] 1.3 Atualizar `xano/table/categorias.xs` e `xano/table/produtos.xs` para o contrato canónico, incluindo nome de categoria único, vínculo de categoria obrigatório, preço decimal e estoque inteiro obrigatórios; validar os schemas com o Xano Developer MCP.
- [ ] 1.4 Reconciliar `docs/domain-model.md` com `categorias`/`produtos`, `preco`/`estoque` e as restrições acordadas; verificar que não permanecem nomes de tabela ou campos contraditórios para o catálogo da farmácia.

## 2. Alinhar gestão do catálogo e listagem no PDV

- [ ] 2.1 Alinhar cadastro, edição, consulta e listagem de produtos para ler e gravar `preco` e `estoque`, rejeitando categoria inexistente, preço negativo e estoque negativo ou não inteiro; validar cada endpoint com o Xano Developer MCP e casos de entrada válidos/inválidos.
- [ ] 2.2 Garantir unicidade de nome e disponibilidade das quatro categorias predefinidas nos endpoints de categoria; validar criação/renomeação duplicada e listagem das categorias no Xano.
- [ ] 2.3 Ajustar a listagem do PDV para retornar somente produtos ativos, aceitar filtro opcional por categoria e apresentar preço e estoque atuais, mantendo produtos ativos com estoque zero identificados como indisponíveis; validar cenários sem filtro, filtrado, inativo e sem saldo.
- [ ] 2.4 Atualizar a documentação dos endpoints e do contrato de resposta do catálogo, verificando que exemplos e nomes dos campos correspondem aos endpoints validados.

## 3. Proteger a baixa de estoque na venda

- [ ] 3.1 Atualizar o endpoint de venda para validar quantidade inteira positiva, produto vendável e estoque disponível antes de registrar a operação; validar a sintaxe XanoScript pelo Xano Developer MCP e confirmar erros sem escrita parcial.
- [ ] 3.2 Tornar atómicos o registro da venda e o abatimento do estoque, incluindo concorrência pelo saldo restante; validar que falha ou concorrência não cria venda inconsistente nem estoque negativo.
- [ ] 3.3 Executar a verificação integrada de cadastro, edição, listagem do PDV e venda com estoque suficiente/insuficiente, confirmando valores e saldos persistidos no Xano.
