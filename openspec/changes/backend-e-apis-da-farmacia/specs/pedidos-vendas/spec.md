# Spec Delta

## Purpose

Define o ciclo de vida dos pedidos de venda da farmácia, garantindo cálculo confiável de valores, desconto elegível, baixa de estoque e métricas de vendas concluídas.

## ADDED Requirements

### Requirement: Montagem de pedido e itens
O sistema SHALL permitir que funcionário autenticado crie pedido em rascunho e gerencie itens com quantidades inteiras positivas e preços unitários obtidos do catálogo no backend.

#### Scenario: Criar pedido e incluir item válido
- **WHEN** um funcionário autenticado cria pedido e adiciona produto ativo com quantidade positiva
- **THEN** o pedido permanece `rascunho`, registra o preço unitário vigente e o estoque ainda não é alterado

#### Scenario: Produto ou quantidade inválida
- **WHEN** um item referencia produto inexistente/inativo ou tem quantidade não positiva ou não inteira
- **THEN** a API rejeita a alteração e preserva o pedido e o estoque

#### Scenario: Editar pedido já fechado
- **WHEN** uma requisição tenta incluir, alterar ou remover item de pedido que não está em `rascunho`
- **THEN** a API rejeita a alteração sem modificar pedido, itens ou estoque

### Requirement: Fechamento atômico do pedido
O sistema SHALL validar e concluir o pedido em uma única operação atômica que persiste totais, status e baixa de estoque de todos os itens.

#### Scenario: Fechamento com estoque suficiente
- **WHEN** um pedido em rascunho com itens válidos é fechado e todos os produtos têm estoque suficiente
- **THEN** o sistema baixa as quantidades, calcula subtotal, desconto e total, e grava status `concluido` como uma única operação

#### Scenario: Estoque insuficiente em qualquer item
- **WHEN** pelo menos um item excede o estoque disponível no momento do fechamento
- **THEN** a API retorna erro `ESTOQUE_INSUFICIENTE` com mensagem amigável e reverte todas as baixas e alterações do fechamento

#### Scenario: Pedidos concorrentes disputam estoque
- **WHEN** fechamentos concorrentes solicitam quantidades cuja soma excede o estoque remanescente
- **THEN** somente operações que couberem no estoque são concluídas e o estoque nunca fica negativo

#### Scenario: Repetir fechamento
- **WHEN** um pedido já concluído recebe nova solicitação de fechamento
- **THEN** a API não baixa estoque novamente e retorna o estado já concluído ou erro de conflito sem efeitos adicionais

### Requirement: Desconto e total do pedido
O sistema SHALL aplicar desconto de 15% somente quando o subtotal calculado pelo backend for maior que R$ 100,00 e houver cliente existente associado; valores monetários SHALL ser persistidos com duas casas decimais.

#### Scenario: Cliente identificado e subtotal acima do limite
- **WHEN** pedido com cliente existente tem subtotal superior a R$ 100,00
- **THEN** a API calcula desconto de 15%, arredondado a centavos, e total igual a subtotal menos desconto

#### Scenario: Subtotal no limite ou cliente ausente
- **WHEN** subtotal é igual ou inferior a R$ 100,00 ou o pedido não tem cliente associado
- **THEN** o desconto é R$ 0,00 e o total é igual ao subtotal

#### Scenario: Valores calculados não são confiados ao cliente
- **WHEN** a requisição informa subtotal, desconto, total ou preço unitário próprios
- **THEN** o backend ignora esses valores e recalcula usando itens e preços vigentes armazenados

### Requirement: Relatórios de vendas concluídas
O sistema SHALL disponibilizar totais de vendas diários, dos últimos sete dias e do mês corrente considerando somente pedidos com status `concluido`.

#### Scenario: Consultar métricas
- **WHEN** funcionário autenticado solicita o relatório de vendas
- **THEN** a API retorna totais separados para dia, últimos sete dias e mês corrente, excluindo rascunhos e pedidos cancelados
