# Tasks

## 1. Modelar o estado do dashboard

- [x] 1.1 Criar estado Reflex dedicado para indicadores, atividade recente, carregamento, vazio e erro, mantendo a autenticação em `AuthState`; verificar tipos e estados sem valores fictícios confirmados.
- [x] 1.2 Mapear as fontes Xano disponíveis para vendas do dia, estoque baixo, medicamentos e movimentações, preservando os nomes definidos em `docs/domain-model.md`; verificar contratos com testes de cliente e tratamento explícito de HTTP/indisponibilidade.

## 2. Construir a experiência visual protegida

- [x] 2.1 Refatorar `/dashboard` em componentes Reflex nativos com sidebar, header, cards e tabela responsiva; verificar compilação com `reflex compile --dry`.
- [x] 2.2 Adicionar links protegidos para `/estoque`, `/vendas` e `/usuarios`, criando destinos protegidos mínimos ou estados de indisponibilidade sem expor conteúdo a sessões inválidas; verificar redirecionamento sem autenticação.
- [x] 2.3 Exibir no header o nome/cargo do funcionário e o botão Sair integrado ao logout existente; verificar que logout limpa a sessão e retorna a `/login`.
- [x] 2.4 Implementar os cards de Vendas do dia, Alertas de estoque baixo e Total de medicamentos com estados neutro, carregando e indisponível; verificar que falhas não são apresentadas como sucesso.
- [x] 2.5 Implementar a tabela de medicamentos ou movimentações recentes com ordenação decrescente, colunas identificadoras e estados de dados disponíveis, vazio e erro; verificar renderização sem registros e preservação das demais seções.

## 3. Testar e documentar a integração

- [x] 3.1 Adicionar testes automatizados para guarda da rota, navegação lateral, identidade do funcionário, logout, indicadores e estados da tabela; verificar a suíte focada e os cenários de sessão inválida.
- [x] 3.2 Atualizar a documentação diretamente relacionada ao dashboard e executar `reflex compile --dry` junto com a suíte completa de testes; verificar que autenticação e cadastro existentes permanecem sem regressões.

## Workflow follow-up

- Arquivar a Change após concluir as tarefas e revisar os cenários da especificação.
