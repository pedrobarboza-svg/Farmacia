# Tasks

## 1. Catálogo de cargos no Xano

- [x] 1.1 Criar `farmacia_final_cargo` com nome único e estado ativo; provisionar Atendente, Farmacêutico, Gerente, Repositor, Caixa e Estagiário sem duplicidades e validar os scripts Xano.
- [x] 1.2 Criar `GET /farmacia-final/cargos` público, ordenado por nome e limitado a cargos ativos; validar que resposta e autenticação correspondem ao contrato e documentar tabela/endpoint em `docs/domain-model.md`.

## 2. Validar cargo no cadastro público

- [x] 2.1 Atualizar `POST /farmacia-final/funcionarios` para rejeitar cargos inexistentes ou inativos sem mudar o campo textual nem a resposta atual; validar o script Xano e confirmar que cargos válidos continuam criando funcionários ativos.
- [x] 2.2 Adicionar testes de contrato para cargo válido, ausente, desconhecido e inativo, incluindo garantia de que a tentativa inválida não cria funcionário; executar a suíte direcionada de testes Xano.

## 3. Integrar o dropdown no Reflex

- [x] 3.1 Implementar no cliente Xano a leitura e validação da resposta `{ "cargos": [...] }`, com tratamento explícito de falhas; cobrir URL, formato, resposta vazia e erros com testes unitários.
- [x] 3.2 Carregar cargos ao abrir `/cadastro`, vincular as opções a um `rx.select` com seleção inicialmente vazia e impedir envio durante falha/lista vazia; testar carregamento, seleção, bloqueio e preservação dos campos.

## 4. Verificação integrada

- [x] 4.1 Executar os testes direcionados e `reflex compile --dry`; validar no navegador opções disponíveis, estados de erro/vazio e seleção, e confirmar no endpoint publicado que a listagem é pública e o cadastro rejeita cargo inativo.
