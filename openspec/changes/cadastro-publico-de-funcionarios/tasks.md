# Tasks

## 1. Tornar o endpoint Xano público com ativação controlada

- [x] 1.1 Atualizar `POST /farmacia-final/funcionarios` para aceitar chamadas sem autenticação, remover `ativo` do input e definir `ativo: true` no backend; validar o script pelo Xano Developer MCP e confirmar que a resposta não inclui senha, hash ou token.
- [x] 1.2 Cobrir cadastro sem token, campos inválidos, e-mail duplicado, payload adulterado com `ativo: false` e resposta segura em testes de contrato; confirmar que não há duplicidade mesmo sob restrição única.
- [x] 1.3 Atualizar documentação do modelo/segurança para registrar ativação pública imediata, cargo descritivo e risco de contas ativas abertas; revisar que nenhum campo ou tabela existente mudou sem documentação.

## 2. Implementar a interface e o fluxo público no Reflex

- [x] 2.1 Remover a guarda de autenticação apenas de `/cadastro` e concluir a página com seletor PT-BR padrão, cabeçalho compartilhado, card, campos com ícones e link “Já tem uma conta? Faça login”; testar acesso direto e navegação do link do login.
- [x] 2.2 Ajustar `AuthState` e cliente Xano para enviar cadastro sem token, sem iniciar sessão após sucesso e com mensagens seguras para HTTP 400, duplicidade e falha de rede; testar preservação dos campos não sensíveis e ausência de credenciais no estado/resposta.
- [x] 2.3 Executar os testes automatizados de interface/estado e `reflex compile --dry`; verificar visualmente `/cadastro` e o retorno para `/login`.

## 3. Validar a integração e a publicação

- [ ] 3.1 Revisar a prévia e obter confirmação antes de aplicar na branch autorizada; se `dev` não puder ser criada, registrar autorização explícita para `v1` live, verificar que só o endpoint mudou e confirmar que o runtime não exige token.
- [ ] 3.2 Executar teste integrado sem sessão: criar conta ativa, entrar com ela, rejeitar e-mail duplicado e campos inválidos, confirmar resposta sem dados sensíveis e validar navegação entre `/login` e `/cadastro`; registrar resultados e confirmar que `cargo` não concede permissões.
