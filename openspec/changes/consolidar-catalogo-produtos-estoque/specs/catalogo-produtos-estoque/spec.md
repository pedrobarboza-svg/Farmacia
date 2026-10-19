# Spec Delta

## Purpose

Define o catálogo canónico de categorias e produtos da farmácia e garantir que a consulta no PDV e as operações de venda respeitem preço e estoque válidos.

## ADDED Requirements

### Requirement: Categorias canónicas do catálogo
O sistema SHALL manter as categorias da farmácia na tabela canónica `categorias`, com identificador único e nome obrigatório e único. As categorias predefinidas SHALL incluir Remédios, Bebidas, Fraldas e Produtos de Higiene.

#### Scenario: Listar categorias disponíveis
- **WHEN** o PDV solicita as categorias do catálogo
- **THEN** o sistema retorna as categorias existentes, incluindo as quatro categorias predefinidas

#### Scenario: Rejeitar nome de categoria duplicado
- **WHEN** uma categoria é criada ou renomeada para um nome já utilizado
- **THEN** o sistema rejeita a operação e mantém a unicidade do nome

### Requirement: Produtos usam preço e estoque canónicos
O sistema SHALL manter produtos na tabela canónica `produtos`, associados a uma categoria existente, com `nome`, `preco` e `estoque` obrigatórios, preço decimal maior ou igual a zero e estoque inteiro maior ou igual a zero.

#### Scenario: Criar produto válido
- **WHEN** um funcionário cadastra um produto com categoria existente, nome, preço não negativo e estoque inteiro não negativo
- **THEN** o sistema persiste o produto usando os campos canónicos `preco` e `estoque`

#### Scenario: Rejeitar preço ou estoque inválido
- **WHEN** a criação ou edição de um produto informa preço negativo, estoque negativo ou estoque não inteiro
- **THEN** o sistema rejeita a operação e preserva os valores previamente armazenados

#### Scenario: Rejeitar categoria inexistente
- **WHEN** um produto é criado ou editado com uma categoria que não existe
- **THEN** o sistema rejeita a operação e não persiste a referência inválida

### Requirement: Listagem de produtos disponíveis no PDV
O sistema SHALL listar no PDV apenas produtos ativos, permitindo filtro opcional por categoria, e SHALL retornar preço e estoque atuais para cada produto.

#### Scenario: Listar produtos ativos sem filtro de categoria
- **WHEN** o PDV solicita o catálogo sem informar uma categoria
- **THEN** o sistema retorna os produtos ativos com seus preços e estoques atuais

#### Scenario: Filtrar catálogo por categoria
- **WHEN** o PDV solicita o catálogo para uma categoria existente
- **THEN** o sistema retorna somente produtos ativos associados à categoria solicitada

#### Scenario: Produto ativo sem estoque
- **WHEN** um produto ativo possui estoque igual a zero
- **THEN** o sistema o mantém visível na listagem com estoque zero e o identifica como indisponível para venda

#### Scenario: Não listar produto inativo
- **WHEN** um produto está inativo
- **THEN** o sistema não o inclui na listagem padrão do PDV

### Requirement: Venda respeita o estoque disponível
O sistema SHALL aceitar somente quantidades de venda inteiras positivas que não excedam o estoque atual e SHALL registrar a venda e baixar o estoque como uma única operação consistente.

#### Scenario: Venda com estoque suficiente
- **WHEN** uma venda é registrada com quantidade positiva menor ou igual ao estoque disponível
- **THEN** o sistema registra a venda e reduz o estoque exatamente pela quantidade vendida

#### Scenario: Rejeitar quantidade maior que o estoque
- **WHEN** uma venda solicita quantidade superior ao estoque disponível
- **THEN** o sistema rejeita a venda, informa que o estoque é insuficiente para o produto e não altera a venda nem o estoque

#### Scenario: Rejeitar quantidade não positiva
- **WHEN** uma venda solicita quantidade zero, negativa ou não inteira
- **THEN** o sistema rejeita a venda e não altera o estoque

#### Scenario: Concorrência pela última unidade
- **WHEN** duas vendas concorrentes tentam vender uma quantidade cuja soma excede o estoque remanescente
- **THEN** no máximo a venda que ainda couber no estoque é confirmada e o estoque nunca fica negativo
