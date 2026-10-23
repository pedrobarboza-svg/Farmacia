# Tasks

## 1. Estender o contrato autenticado de funcionário

- [x] 1.1 Atualizar `docs/domain-model.md` para documentar `cargo` como texto opcional, sem efeito de autorização; verificar que o modelo distingue novos cadastros de registros preexistentes.
- [x] 1.2 Atualizar `xano/table/farmacia_final_funcionario.xs` e `xano/api/farmacia/farmacia_final/funcionarios_POST.xs` para armazenar e retornar `cargo` em novos cadastros, mantendo autenticação obrigatória e respostas sem senha/hash; validar os scripts pelo Xano Developer MCP.
- [x] 1.3 Cobrir compatibilidade e validações do contrato: funcionário antigo sem `cargo` continua autenticável, novo cadastro sem cargo é rejeitado, e e-mail duplicado não cria registro; verificar nos testes do endpoint ou em testes de contrato.

## 2. Implementar integração Reflex server-side

- [x] 2.1 Configurar a URL base do Xano por ambiente e criar chamadas server-side com timeout explícito; verificar com testes que URL ausente/falha de rede gera erro visível e não resposta de sucesso.
- [x] 2.2 Implementar estado de sessão isolado por usuário, mantendo o JWT fora das variáveis de interface; verificar em testes que sessões não compartilham tokens e que a credencial não aparece nos dados renderizados ou logs.
- [x] 2.3 Implementar chamadas de login e provisionamento com os payloads existentes, incluindo `cargo` apenas no cadastro; verificar por testes de contrato o caminho, método, cabeçalho e corpo enviados ao Xano.
- [x] 2.4 Mapear HTTP 400, HTTP 401, timeout e resposta inesperada para feedback e encerramento de sessão apropriados; verificar testes de cada resultado sem expor senha, token ou corpo sensível.

## 3. Criar páginas e controles de acesso

- [x] 3.1 Criar `/login` com validação de e-mail/senha, estado de envio e mensagens amigáveis; verificar login aceito, rejeição e redirecionamento para `/`.
- [x] 3.2 Criar `/cadastro` com nome, e-mail, senha e cargo, acessível somente com sessão autenticada; verificar validações locais e preservação dos valores não sensíveis após HTTP 400.
- [x] 3.3 Proteger a página inicial e demais páginas operacionais no carregamento e nas operações server-side, e implementar logout; verificar acesso direto sem sessão, sessão expirada, logout e retorno a `/login`.
- [x] 3.4 Executar verificação de compilação/build Reflex e testes automatizados das páginas e fluxos; corrigir erros e confirmar que o token não é enviado ao browser.

## 4. Validar e aplicar a extensão Xano

- [x] 4.1 Validar todos os scripts Xano afetados e revisar a prévia de import parcial limitada à tabela e ao endpoint namespaced; verificar que nenhuma tabela, rota ou registro legado será alterado.
- [x] 4.2 Após confirmação explícita da prévia, aplicar a extensão em `v1` e confirmar por pull que o campo `cargo` é opcional para dados existentes e obrigatório no endpoint de novos cadastros.
- [ ] 4.3 Executar verificação integrada de login, cadastro autenticado, duplicidade, HTTP 400/401, expiração e logout; registrar os resultados e confirmar que nenhum caminho cria funcionário anonimamente.
