# Design

## Context

O domínio em [docs/domain-model.md](../../../docs/domain-model.md) define os nomes lógicos `funcionario`, `cliente`, `categorias`, `produtos`, `pedido` e `item_pedido`. O workspace Xano é compartilhado por mais de uma aplicação e já possui objetos e registros com nomes sobrepostos; por exemplo, a tabela `PEDIDO` serve um fluxo legado com relações próprias, e `produtos` usa campos de estoque diferentes. A especificação existente `catalogo-produtos-estoque` define o comportamento lógico do catálogo.

## Goals / Non-Goals

**Goals:**
- Entregar um schema físico namespaced no Xano, alinhado às entidades lógicas documentadas e isolado dos objetos existentes.
- Expor APIs sob o prefixo `/farmacia-final/*`, sem sobrescrever rotas já publicadas.
- Fazer do fechamento do pedido a única operação que confirma valores, status e baixa de estoque.
- Preservar a autenticação por funcionário sem renomear `senha_hash`.

**Non-Goals:**
- Migrar, renomear ou alterar dados e schemas existentes no workspace compartilhado.
- Implementar pagamentos reais, gateways ou autorização baseada em papéis não definidos no modelo atual.
- Reescrever as APIs de catálogo já cobertas por `catalogo-produtos-estoque`.

## Decisions

### Schema canónico e campos

Os nomes lógicos e relações seguem o modelo de domínio; os nomes físicos terão prefixo `farmacia_final_`: `farmacia_final_funcionario`, `farmacia_final_cliente`, `farmacia_final_categorias`, `farmacia_final_produtos`, `farmacia_final_pedido` e `farmacia_final_item_pedido`. Os tipos Xano incluem `int`, `text`, `email`, `password`, `decimal`, `bool`, `timestamp` e `enum`. `farmacia_final_funcionario.senha_hash` será declarado como tipo Xano `password`, que armazena hash e permite `security.check_password`; o nome lógico do campo permanece conforme documentação. A tabela de funcionários terá `auth = true` para permitir tokens emitidos para `auth = "farmacia_final_funcionario"`.

Os campos monetários usam `decimal` com mínimo zero. `pedido` começa com totais zero e status `rascunho`; o backend recalcula subtotal, desconto e total no fechamento. `item_pedido.preco_unitario` registra o preço capturado quando o item é adicionado. `pedido.created_at` é atualizado no fechamento para representar o momento da venda concluída, conforme a descrição do domínio.

### Autenticação e provisionamento

O login consulta o funcionário pelo e-mail, exige conta ativa, verifica a senha com `security.check_password` e emite token por `security.create_auth_token`. Assim se preserva `senha_hash` sem armazenar senha em texto simples. `POST /funcionarios` exigirá token de funcionário; o modelo atual não define papel de administrador, portanto não se presume uma distinção de privilégios inexistente. A inicialização da primeira conta deve ocorrer por procedimento administrativo seguro fora de um endpoint público.

Alternativas consideradas: reutilizar `pedido`/`cliente`/`produtos` existentes ou renomear os campos de domínio. Rejeitadas porque o workspace é compartilhado e os objetos existentes possuem dados e relações de outros fluxos; as instruções do projeto também proíbem renomear campos sem atualizar a documentação.

### Contratos REST

Os endpoints pertencem ao grupo existente `Farmácia`, mantendo seu canonical atual, mas todos os novos caminhos usam o prefixo `/farmacia-final/` para evitar colisões com rotas existentes. Todos exigem autenticação de funcionário, exceto `POST /farmacia-final/auth/login`. O contrato inclui:

| Método | Caminho | Função |
|---|---|---|
| POST | `/farmacia-final/auth/login` | Validar credenciais e emitir token |
| POST | `/farmacia-final/funcionarios` | Provisionar funcionário autenticado |
| GET, POST | `/farmacia-final/clientes`, `/farmacia-final/clientes/cpf/{cpf}` | Consultar ou cadastrar cliente |
| GET, POST, PATCH | `/farmacia-final/categorias`, `/farmacia-final/categorias/{id}` | Consultar, cadastrar e editar categorias |
| POST | `/farmacia-final/categorias/inicializar` | Criar idempotentemente as quatro categorias iniciais |
| GET, POST, PATCH | `/farmacia-final/produtos`, `/farmacia-final/produtos/{id}` | Consultar catálogo e gerir produtos |
| POST, GET | `/farmacia-final/pedidos`, `/farmacia-final/pedidos/{id}` | Abrir pedido em rascunho e consultar pedidos do funcionário |
| POST, PATCH, DELETE | `/farmacia-final/pedidos/{id}/itens`, `/farmacia-final/pedidos/{id}/itens/{item_id}` | Incluir, atualizar ou remover item antes do fechamento |
| POST | `/farmacia-final/pedidos/{id}/fechar` | Validar, calcular, baixar estoque e concluir |
| GET | `/farmacia-final/relatorios/vendas` | Retornar totais diário, últimos sete dias e mês corrente |

Respostas de sucesso usam 200 ou 201. Erros seguem `{ "code": "ERROR_CODE", "message": "Descrição amigável" }`; entradas inválidas, credenciais inválidas, CPF duplicado, pedido em estado incorreto e estoque insuficiente devem ter códigos específicos. Produtos referenciados por vendas não são apagados: a gestão os desativa com `ativo = false`.

### Fechamento e concorrência

O endpoint de fechamento calcula subtotal a partir dos itens persistidos e executa todas as alterações dentro de `db.transaction`. Uma atualização condicional de estado (`status = rascunho` → `concluido`) reivindica o pedido uma única vez; atualizações condicionais de estoque exigem `estoque >= quantidade`. A leitura dos itens ocorre após a reivindicação dentro da transação. Inclusão, edição e remoção de itens também bloqueiam condicionalmente a linha do pedido dentro de transação, serializando mudanças concorrentes com o fechamento. Se qualquer atualização não afetar exatamente um registro, uma precondição falha dentro da transação e todas as alterações são revertidas. Em seguida, o backend aplica 15% se e somente se o cliente existir e subtotal for estritamente superior a R$ 100,00, arredonda os valores monetários a centavos, grava os totais e atualiza `created_at` para a data efetiva da venda. O endpoint rejeita pedidos sem itens e não permite novo abatimento em pedido já concluído.

O pagamento continua simulado: não há API de cobrança, transação financeira ou integração com provedor. `concluido` identifica o fechamento do pedido no backend.

### Isolamento e reversão

Os seis nomes físicos namespaced e o prefixo de rota evitam sobrescrita dos objetos atuais, sem migrar registros. O snapshot integral da branch foi obtido antes da aplicação e fica em armazenamento local da sessão. O push será parcial, limitado explicitamente aos novos arquivos `.xs`, com transação habilitada e prévia `--dry-run`. Não usar `--sync`, `--delete`, `--records` ou `--truncate`. Se o push falhar, a transação do Xano reverte o import. Para reversão posterior, remover somente os objetos `farmacia_final_*` e rotas `/farmacia-final/*` após backup dos novos registros; não alterar tabelas compartilhadas.

## Risks / Trade-offs

- [Workspace é compartilhado e não há branch de desenvolvimento no plano atual] → manter isolamento em tabelas e rotas namespaced; limitar o push aos arquivos da Change e revisar a prévia antes de aplicar em `v1`.
- [Índice único detecta CPF duplicado apenas na gravação concorrente] → manter índice único no banco e tratar a violação como erro de conflito padronizado, além da validação prévia.
- [Fechamentos concorrentes podem bloquear linhas de estoque] → atualizar estoque condicionalmente dentro da transação e testar disputas por últimas unidades.
- [O modelo não define papel administrativo] → proteger provisionamento com autenticação, não expor cadastro anônimo e não inventar permissões por cargo.
- [O modelo não possui `concluido_at`] → atualizar `created_at` no fechamento para que os relatórios por período usem a data efetiva de conclusão.
