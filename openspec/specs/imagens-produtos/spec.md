# imagens-produtos Specification

## Purpose

Permite identificar visualmente produtos da farmácia por meio de uma URL de imagem, mantendo a referência associada ao produto no catálogo e disponível para as telas operacionais.

## Requirements

### Requirement: Produto pode ter imagem por URL

O sistema SHALL permitir que um produto tenha uma URL de imagem opcional, persistida junto ao registro do produto e retornada nas consultas do catálogo.

#### Scenario: Cadastrar produto com URL de imagem

- **WHEN** um funcionário cadastra um produto informando uma URL de imagem
- **THEN** o sistema persiste a URL em `farmacia_final_produtos` e retorna a referência no produto

#### Scenario: Cadastrar produto sem imagem

- **WHEN** um funcionário cadastra um produto sem informar uma URL
- **THEN** o sistema persiste o produto sem imagem e conclui o cadastro normalmente

#### Scenario: Editar imagem do produto

- **WHEN** um funcionário edita um produto e informa ou altera sua URL de imagem
- **THEN** o sistema atualiza a URL persistida e a retorna nas consultas posteriores

#### Scenario: Remover imagem do produto

- **WHEN** um funcionário edita um produto e deixa a URL de imagem vazia
- **THEN** o sistema remove a referência da imagem sem alterar os demais dados do produto

### Requirement: Cadastro exibe campo de imagem abaixo da categoria

O sistema SHALL exibir um campo para URL de imagem imediatamente abaixo do dropdown de categoria no cadastro e na edição de produtos.

#### Scenario: Preencher URL no formulário

- **WHEN** o funcionário informa uma URL no campo abaixo da categoria e salva o produto
- **THEN** a URL é enviada ao backend e fica associada ao produto

#### Scenario: Visualizar prévia antes de salvar

- **WHEN** o funcionário informa uma URL de imagem no formulário
- **THEN** o formulário exibe a imagem imediatamente acima do botão "Salvar"

#### Scenario: Exibir imagem na listagem

- **WHEN** um produto listado possui uma URL de imagem persistida
- **THEN** a tela de estoque exibe a imagem ou sua representação visual associada ao produto
