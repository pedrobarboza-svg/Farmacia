# Spec Delta

## Purpose

Permite identificar e cadastrar clientes com CPF único para associar compras, aplicando validação no backend e sem exigir cliente em vendas sem desconto elegível.

## ADDED Requirements

### Requirement: Cadastro e busca de clientes por CPF
O sistema SHALL validar no backend que o CPF contém exatamente 11 dígitos numéricos e SHALL impedir que dois clientes tenham o mesmo CPF.

#### Scenario: Cadastro de cliente válido
- **WHEN** um funcionário autenticado cadastra nome e CPF válido ainda não utilizado
- **THEN** a API cria o cliente e retorna seus dados públicos com HTTP 201

#### Scenario: CPF inválido ou duplicado
- **WHEN** o CPF não possui 11 dígitos numéricos ou já pertence a outro cliente
- **THEN** a API rejeita o cadastro, retorna erro padronizado e não cria novo registro

#### Scenario: Buscar cliente por CPF
- **WHEN** um funcionário autenticado consulta um CPF válido
- **THEN** a API retorna o cliente correspondente ou resposta de não encontrado sem expor credenciais

### Requirement: Cliente opcional no pedido
O sistema SHALL permitir pedidos sem cliente associado e SHALL exigir cliente existente antes de aplicar desconto de fidelidade.

#### Scenario: Pedido sem cliente
- **WHEN** um pedido é fechado sem `cliente_id`
- **THEN** o pedido pode ser concluído se os demais dados forem válidos e seu desconto é zero

#### Scenario: Associar cliente inexistente
- **WHEN** um pedido informa um `cliente_id` que não existe
- **THEN** a API rejeita a operação e não aplica desconto nem conclui o pedido
