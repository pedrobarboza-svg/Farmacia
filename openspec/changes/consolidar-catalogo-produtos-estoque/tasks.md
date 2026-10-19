# Tasks

## 1. Canonicalizar o schema e migrar os dados

- [x] 1.1 Inspecionar os schemas `xano/table/categorias.xs` e `xano/table/produtos.xs` e todos os endpoints da API `Farmácia`; verificar num inventário de referências que campos e tabelas legadas não serão confundidos com o catálogo canónico.
- [x] 1.2 Revisar as referências locais a `preco_unitario` e `quantidade_estoque` e estabelecer o limite de publicação sem migração remota; verificar que a change documenta a migração/backup como pré-condição separada para qualquer implantação em ambiente com dados.
- [x] 1.3 Atualizar `xano/table/categorias.xs` e `xano/table/produtos.xs` para o contrato canónico, incluindo nome de categoria único, vínculo de categoria obrigatório, preço decimal e estoque inteiro obrigatórios; validar os schemas com o Xano Developer MCP.
- [x] 1.4 Reconciliar `docs/domain-model.md` com `categorias`/`produtos`, `preco`/`estoque` e as restrições acordadas; verificar que não permanecem nomes de tabela ou campos contraditórios para o catálogo da farmácia.

## 2. Alinhar gestão do catálogo e listagem no PDV

- [x] 2.1 Alinhar cadastro, edição, consulta e listagem de produtos para ler e gravar `preco` e `estoque`, rejeitando categoria inexistente, preço negativo e estoque negativo ou não inteiro; validar cada endpoint com o Xano Developer MCP e casos de entrada válidos/inválidos.
- [x] 2.2 Garantir unicidade de nome e disponibilidade das quatro categorias predefinidas com uma função XanoScript inicializadora idempotente, mantendo GET somente leitura; documentar a execução inicial e validar a sintaxe e as verificações de existência antes de cada inserção.
- [x] 2.3 Ajustar a listagem do PDV para retornar somente produtos ativos, aceitar filtro opcional por categoria e apresentar preço e estoque atuais, mantendo produtos ativos com estoque zero identificados como indisponíveis; validar cenários sem filtro, filtrado, inativo e sem saldo.
- [x] 2.4 Atualizar a documentação dos endpoints e do contrato de resposta do catálogo, verificando que exemplos e nomes dos campos correspondem aos endpoints validados.

## 3. Proteger a baixa de estoque na venda

- [x] 3.1 Alinhar a venda aos schemas locais `vendas` e `itens_venda`, validando produto ativo e quantidade inteira positiva antes de registrar; validar todos os arquivos alterados no Xano Developer MCP.
- [x] 3.2 Decrementar estoque por atualização SQL condicional dentro de `db.transaction`, junto com os registros de venda e item; validar sintaxe e a condição de saldo suficiente/insuficiente, sem alegar garantia em runtime antes de executar no Xano.
- [x] 3.3 Fazer verificação integrada estática dos endpoints e schemas alterados pelo Xano Developer MCP e buscas por referências antigas; documentar que confirmação de persistência, rollback e concorrência exige execução no workspace Xano e não foi feita nesta etapa local.
