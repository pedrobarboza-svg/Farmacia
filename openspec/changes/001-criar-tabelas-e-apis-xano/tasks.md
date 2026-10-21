# Tasks

## 1. Reconciliar o modelo existente

- [x] 1.1 Inventariar tabelas e registros no workspace Xano de destino e comparar com o schema canónico documentado.
- [x] 1.2 Definir e validar o mapeamento físico namespaced (`farmacia_final_*`) e o prefixo `/farmacia-final/*`, garantindo que nenhum objeto legado seja sobrescrito.
- [x] 1.3 Preparar e verificar o snapshot completo de `v1` e o plano de reversão restrito aos novos objetos namespaced.

## 2. Criar e validar as tabelas

- [x] 2.1 Aplicar as seis tabelas namespaced (`farmacia_final_*`) por import parcial transacional, sem alterar tabelas existentes.
- [x] 2.2 Confirmar tipos, valores padrão, chaves estrangeiras, índices únicos de e-mail/CPF/nome de categoria e restrições de valores não negativos.
- [ ] 2.3 Inicializar e verificar as quatro categorias predefinidas em `farmacia_final_categorias`, sem duplicatas.

## 3. Implementar autenticação e cadastro

- [x] 3.1 Implementar login com verificação de senha em `senha_hash`, bloqueio de contas inativas e emissão de token Xano.
- [x] 3.2 Implementar provisionamento autenticado de funcionários e garantir que nenhum endpoint público cria contas.
- [x] 3.3 Implementar cadastro e busca de clientes com validação de CPF de 11 dígitos e unicidade sob concorrência.

## 4. Expor APIs de catálogo e pedidos

- [x] 4.1 Expor endpoints novos sob `/farmacia-final/*`, protegidos por token, sem substituir rotas publicadas.
- [x] 4.2 Implementar criação de pedido em rascunho e inclusão, atualização e remoção de itens sem baixar estoque antes do fechamento.
- [x] 4.3 Implementar fechamento atômico com validação de todos os itens, atualização condicional do estoque, desconto de 15% e status `concluido`.
- [x] 4.4 Implementar leitura do pedido e relatórios diário, últimos sete dias e mensal, excluindo pedidos não concluídos.

## 5. Verificar e publicar

- [x] 5.1 Validar todos os arquivos XanoScript pelo Xano Developer MCP e corrigir erros de parser antes de importar.
- [ ] 5.2 Testar subtotal igual, abaixo e acima de R$ 100,00, pedido sem cliente e arredondamento do desconto a centavos.
- [ ] 5.3 Testar estoque suficiente/insuficiente, concorrência pela última unidade, rollback após falha e repetição de fechamento.
- [x] 5.4 Validar respostas HTTP e erros JSON padronizados, confirmar que nenhum objeto legado foi alterado e concluir a verificação pós-push.
