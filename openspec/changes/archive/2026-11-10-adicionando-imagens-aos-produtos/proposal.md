# Proposal

## Why

O cadastro de produtos atualmente não permite associar uma imagem ao medicamento, dificultando a identificação visual no estoque e no PDV. Uma URL de imagem é suficiente para o fluxo atual e evita a necessidade de armazenamento de arquivos no servidor.

## What Changes

- Adicionar um campo opcional de URL de imagem ao produto.
- Exibir o campo de imagem imediatamente abaixo do dropdown de categoria no cadastro e na edição de produtos.
- Persistir a URL na tabela `farmacia_final_produtos`.
- Incluir a URL nas APIs de criação, edição e consulta de produtos.
- Exibir a imagem associada na listagem de estoque quando houver uma URL válida.
- Manter o cadastro funcional quando a URL estiver vazia.
- Não incluir upload de arquivos, processamento de imagens ou integração com armazenamento externo nesta change.

## Capabilities

### New Capabilities

- `imagens-produtos`: Associar, persistir e exibir imagens de produtos por URL.

### Modified Capabilities

- `catalogo-produtos-estoque`: Produtos passam a aceitar e retornar uma URL de imagem opcional, sem alterar as regras de preço, estoque ou categoria.

## Impact

- Backend Xano: schema `farmacia_final_produtos` e endpoints `/farmacia-final/produtos`.
- Cliente Reflex: modelo `Product`, estado do estoque, formulário de cadastro/edição e listagem de produtos.
- Documentação e testes do catálogo.
- Nenhuma nova dependência externa; a imagem será referenciada por URL.
