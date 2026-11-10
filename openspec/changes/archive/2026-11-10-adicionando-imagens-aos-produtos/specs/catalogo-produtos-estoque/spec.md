# Spec Delta

## ADDED Requirements

### Requirement: Catálogo retorna imagem opcional do produto

O sistema SHALL incluir a URL de imagem opcional de cada produto nas respostas de criação, edição e listagem do catálogo, preservando o comportamento atual quando a imagem não existir.

#### Scenario: Listar produto com imagem

- **WHEN** o catálogo consulta um produto que possui URL de imagem
- **THEN** a resposta inclui a URL associada ao produto

#### Scenario: Listar produto sem imagem

- **WHEN** o catálogo consulta um produto sem URL de imagem
- **THEN** a resposta inclui o produto sem uma referência de imagem utilizável e mantém preço, estoque e categoria
