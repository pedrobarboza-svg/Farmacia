# Change 001 — Schema e APIs Xano da farmaciaFinal

Esta é a referência de schema e deployment da Change 001. Os scripts XanoScript individuais em [xano/table/](../../xano/table) e [xano/api/farmacia/farmacia_final/](../../xano/api/farmacia/farmacia_final) são a fonte executável e foram validados pelo Xano Developer MCP.

## Isolamento no workspace compartilhado

O workspace `149200`, branch `v1`, contém outras aplicações e objetos com nomes e rotas coincidentes. Esta implementação **não** altera, renomeia, migra nem importa registros para os objetos existentes. Ela cria seis tabelas novas com prefixo `farmacia_final_` e endpoints sob `/farmacia-final/*`.

| Entidade lógica | Tabela Xano |
|---|---|
| `funcionario` | `farmacia_final_funcionario` |
| `cliente` | `farmacia_final_cliente` |
| `categorias` | `farmacia_final_categorias` |
| `produtos` | `farmacia_final_produtos` |
| `pedido` | `farmacia_final_pedido` |
| `item_pedido` | `farmacia_final_item_pedido` |

## Modelo de dados

Os tipos são os tipos nativos Xano. Todos os campos `id` são inteiros auto-incrementais e chave primária.

| Tabela | Campo | Tipo e restrições |
|---|---|---|
| `farmacia_final_funcionario` | `nome` | `text`, obrigatório |
| | `email` | `email`, obrigatório e único |
| | `senha_hash` | `password`, obrigatório e sensível; o Xano armazena o hash |
| | `ativo` | `bool`, padrão `true` |
| | `created_at` | `timestamp`, padrão `now` |
| `farmacia_final_cliente` | `nome` | `text`, obrigatório |
| | `cpf` | `text`, obrigatório e único; a API exige 11 dígitos |
| | `created_at` | `timestamp`, padrão `now` |
| `farmacia_final_categorias` | `nome` | `text`, obrigatório e único |
| | `descricao` | `text`, opcional |
| | `ativo` | `bool`, padrão `true` |
| `farmacia_final_produtos` | `nome` | `text`, obrigatório |
| | `descricao` | `text`, opcional |
| | `preco` | `decimal`, mínimo zero |
| | `estoque` | `int`, mínimo zero |
| | `ativo` | `bool`, padrão `true` |
| | `categoria_id` | `int`, FK para `farmacia_final_categorias.id` |
| `farmacia_final_pedido` | `funcionario_id` | `int`, FK para `farmacia_final_funcionario.id` |
| | `cliente_id` | `int`, FK opcional para `farmacia_final_cliente.id` |
| | `status` | `enum`: `rascunho`, `concluido`, `cancelado`; padrão `rascunho` |
| | `subtotal`, `desconto`, `total` | `decimal`, mínimo zero; todos começam em zero |
| | `created_at` | `timestamp`, padrão `now`; atualizado ao fechar a venda |
| `farmacia_final_item_pedido` | `pedido_id` | `int`, FK para `farmacia_final_pedido.id` |
| | `produto_id` | `int`, FK para `farmacia_final_produtos.id` |
| | `quantidade` | `int`, mínimo 1 |
| | `preco_unitario` | `decimal`, mínimo zero; preço capturado ao incluir o item |

Índices únicos: e-mail de funcionário, CPF de cliente e nome de categoria. Preços, estoque, quantidades e valores do pedido também são validados nas APIs.

## Endpoints REST

Todas as rotas exigem token de funcionário, exceto login. O primeiro funcionário precisa ser provisionado por procedimento administrativo seguro no Xano; não existe endpoint público de bootstrap. Depois do login, execute `POST /farmacia-final/categorias/inicializar` uma vez para garantir as quatro categorias base sem duplicatas.

| Método | Caminho | Operação |
|---|---|---|
| `POST` | `/farmacia-final/auth/login` | Autenticar funcionário ativo e emitir token |
| `POST` | `/farmacia-final/funcionarios` | Provisionar funcionário autenticado |
| `GET`, `POST` | `/farmacia-final/clientes` | Listar e cadastrar clientes |
| `GET` | `/farmacia-final/clientes/cpf/{cpf}` | Buscar cliente por CPF |
| `GET`, `POST` | `/farmacia-final/categorias` | Listar e criar categorias |
| `GET`, `PATCH` | `/farmacia-final/categorias/{id}` | Ler e editar categoria |
| `POST` | `/farmacia-final/categorias/inicializar` | Inserir idempotentemente Remédios, Bebidas, Fraldas e Produtos de Higiene |
| `GET`, `POST` | `/farmacia-final/produtos` | Listar produtos ativos e criar produto |
| `GET`, `PATCH` | `/farmacia-final/produtos/{id}` | Ler, editar ou desativar produto |
| `GET`, `POST` | `/farmacia-final/pedidos` | Listar pedidos próprios e abrir pedido em rascunho |
| `GET` | `/farmacia-final/pedidos/{id}` | Consultar pedido e itens |
| `POST` | `/farmacia-final/pedidos/{id}/itens` | Adicionar item sem abater estoque |
| `PATCH`, `DELETE` | `/farmacia-final/pedidos/{id}/itens/{item_id}` | Alterar ou remover item em rascunho |
| `POST` | `/farmacia-final/pedidos/{id}/fechar` | Calcular valores, baixar estoque e concluir pedido |
| `GET` | `/farmacia-final/relatorios/vendas` | Consultar total diário, últimos sete dias e mês corrente |

As respostas de sucesso são os registros/listas solicitados. As precondições Xano usam os tipos HTTP adequados; a resposta de erro mantém o envelope Xano `{ "code": "...", "message": "..." }`, com o código de domínio no início da mensagem.

## Integridade do fechamento

O preço unitário é capturado do produto quando o item é adicionado; valores enviados pelo cliente não são aceitos para cálculo. A rota de fechamento reivindica condicionalmente o pedido em estado `rascunho`, lê os itens e, na mesma transação, decrementa cada produto por `UPDATE ... WHERE estoque >= quantidade AND ativo = TRUE`. A alteração concorrente dos itens bloqueia condicionalmente a linha do pedido na mesma transação, evitando que itens entrem ou saiam enquanto ocorre o fechamento. Qualquer produto indisponível, estoque insuficiente ou falha aborta a transação e reverte a reivindicação do pedido e todas as baixas.

O subtotal é calculado no backend. O desconto é `15%` arredondado a centavos somente se houver cliente existente e o subtotal for estritamente maior que `R$ 100,00`; nos demais casos é zero. O total é subtotal menos desconto. O status muda para `concluido` dentro da mesma transação; repetir o fechamento não desconta estoque novamente. Não há processamento de pagamento real.

## Scripts executáveis

**Tabelas** — aplicar cada `.xs` em [xano/table/](../../xano/table):

- [farmacia_final_funcionario.xs](../../xano/table/farmacia_final_funcionario.xs)
- [farmacia_final_cliente.xs](../../xano/table/farmacia_final_cliente.xs)
- [farmacia_final_categorias.xs](../../xano/table/farmacia_final_categorias.xs)
- [farmacia_final_produtos.xs](../../xano/table/farmacia_final_produtos.xs)
- [farmacia_final_pedido.xs](../../xano/table/farmacia_final_pedido.xs)
- [farmacia_final_item_pedido.xs](../../xano/table/farmacia_final_item_pedido.xs)

**APIs** — os 22 endpoints `.xs` ficam em [xano/api/farmacia/farmacia_final/](../../xano/api/farmacia/farmacia_final). Cada arquivo declara seu caminho HTTP e usa o grupo existente `Farmácia`.

## Aplicação controlada

O snapshot de `v1` e o plano de reversão estão registrados no [design](./001-criar-tabelas-e-apis-xano/design.md). Faça somente push parcial dos arquivos namespaced, com transação habilitada. Primeiro gere e revise a prévia:

```powershell
xano workspace push -d .\xano -w 149200 -b v1 `
  -i "table/farmacia_final_*.xs" `
  -i "api/farmacia/farmacia_final/**/*.xs" `
  --transaction --dry-run
```

Só após revisar a prévia e obter confirmação explícita, repita o comando removendo `--dry-run`. Não usar `--sync`, `--delete`, `--records` ou `--truncate`; assim o push não migra registros nem modifica objetos remotos fora do namespace. A branch `dev` não está disponível no plano atual do workspace.
