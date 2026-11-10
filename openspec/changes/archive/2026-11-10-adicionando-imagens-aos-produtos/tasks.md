# Tasks

## 1. Backend e contrato de produto

- [x] 1.1 Adicionar o campo opcional `imagem_url` ao schema `farmacia_final_produtos`, preservando registros existentes, e validar o schema Xano.
- [x] 1.2 Atualizar os endpoints Xano de criação e edição para aceitar URL HTTP/HTTPS ou ausência, rejeitando formatos inválidos; verificar com validação XanoScript.
- [x] 1.3 Atualizar os endpoints Xano de consulta para retornar `imagem_url` sem alterar produtos que não possuem imagem; cobrir payloads com e sem imagem nos testes de cliente.

## 2. Cliente e estado Reflex

- [x] 2.1 Estender o modelo e as chamadas do `xano_client` para transportar `imagem_url` em GET, POST e PATCH; verificar com testes unitários de serialização e validação.
- [x] 2.2 Adicionar o estado da URL de imagem ao fluxo de criação e edição do `StockState`, incluindo validação de URL e remoção por campo vazio; verificar com testes de estado ou cliente.
- [x] 2.3 Atualizar o formulário Reflex para exibir o campo de URL imediatamente abaixo do dropdown, mostrar prévia acima do botão "Salvar" e manter o campo opcional; verificar com `reflex compile --dry`.

## 3. Exibição e documentação

- [x] 3.1 Exibir a imagem do produto na listagem de estoque quando houver URL e um placeholder quando estiver ausente ou falhar, sem ocultar os dados textuais; verificar manualmente os dois casos.
- [x] 3.2 Atualizar a documentação do catálogo com o campo `imagem_url`, seu formato aceito e o comportamento opcional; verificar os exemplos contra o contrato dos endpoints.
- [x] 3.3 Executar a suíte de testes relacionada ao catálogo e o teste integrado de cadastro/edição com URL e sem URL, confirmando persistência em `farmacia_final_produtos`.

## Workflow follow-up

- Arquivar a change após a implementação e validação dos testes.
