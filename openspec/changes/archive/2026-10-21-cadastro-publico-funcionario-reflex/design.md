# Design

## Context

Consulte `proposal.md` para a motivação e `specs/cadastro-publico-funcionario/spec.md` para o contrato observável. Atualmente `/cadastro` usa `AuthState.require_auth`, `register_employee` exige token, e `POST /farmacia-final/funcionarios` declara autenticação Xano e aceita `ativo` no input. O campo `cargo` é texto descritivo e não implementa autorização.

## Goals / Non-Goals

**Goals:**
- Tornar o fluxo público de cadastro funcional de ponta a ponta, sem credencial preexistente.
- Garantir que o servidor, e não o visitante, decida que a nova conta fica ativa.
- Reaproveitar a identidade visual e os componentes de marca entre login e cadastro.
- Manter validação de dados, unicidade do e-mail e proteção de senha/resposta.

**Non-Goals:**
- Criar aprovação, verificação de e-mail, convite ou recuperação de senha.
- Definir permissões com base no cargo ou criar RBAC.
- Alterar o fluxo de login ou expor credenciais no navegador.

## Decisions

### Cadastro público no endpoint existente

Remover a exigência de autenticação de `POST /farmacia-final/funcionarios` e da rota Reflex `/cadastro`; atualizar o cliente Xano para não enviar token nessa operação. Reutilizar o endpoint preserva o caminho já usado pela tela e evita duplicar contrato.

Alternativa considerada: criar um endpoint separado de signup público mantendo o provisionamento autenticado. Isso preservaria a semântica de provisionamento, mas duplicaria validações e criaria dois fluxos de cadastro; não foi escolhida para esta mudança.

### Estado ativo controlado pelo backend

Remover `ativo` dos inputs aceitos no endpoint público e criar os registros com `ativo: true` definido no servidor. A validação de e-mail duplicado permanece, respaldada pelo índice único já existente; falhas de unicidade também devem terminar sem sucesso ou registro duplicado. Reutilizar a senha tipada como `password` no Xano mantém o mecanismo seguro já usado.

Alternativa considerada: aceitar `ativo` no payload como hoje. Foi descartada porque permitiria que visitantes controlassem o estado da própria conta.

### Confirmação sem autenticação automática

Após criação bem-sucedida, não iniciar sessão nem devolver token. Exibir confirmação e orientar a pessoa a entrar pela página `/login`; erros de validação permanecem no formulário, com valores não sensíveis preservados.

Alternativa considerada: autenticar automaticamente após cadastro. Não foi escolhida para manter o login como operação de autenticação explícita e evitar transportar uma nova credencial no fluxo público.

### Interface alinhada entre as rotas

Reutilizar `_brand_header` e `_language_selector` no cadastro; manter Português como idioma inicial. Construir campos com ícones de usuário, e-mail e cadeado; cargo permanece input de texto, sem enumeração que sugira autorização inexistente. Usar o mesmo fundo, card, cores e estilo de foco/hover do login. O link de login aponta para `/login`.

## Risks / Trade-offs

- **[Qualquer visitante pode criar uma conta ativa de funcionário]** → Comportamento solicitado e aceito; não existe verificação de e-mail nem aprovação neste escopo. Não expor permissões pelo campo cargo e manter validações, senha segura e unicidade. A operação deve ser aplicada somente após revisão explícita do risco no Xano.
- **[Abuso automatizado ou crescimento de contas]** → O endpoint torna-se público; não há mecanismo de rate limit ou CAPTCHA identificado no projeto. Não alegar proteção inexistente; avaliar mitigação separada antes de disponibilizar publicamente em produção.
- **[Erro de deploy entre frontend e API]** → Publicar primeiro a mudança Xano e depois o frontend; a versão atual do formulário protegido permanece compatível durante a transição.
- **[Exposição de dados em respostas]** → Retornar apenas campos não sensíveis; nunca incluir senha, hash ou token e não registrar payloads de credenciais.

## Migration Plan

1. Validar o script e contrato do endpoint Xano antes de importação, conferindo acesso sem autenticação, fixação de `ativo=true`, duplicidade e resposta sem dados sensíveis.
2. Aplicar somente o endpoint revisado na branch autorizada pelo usuário. Nesta execução, a criação de `dev` foi negada pelo plano do workspace e o usuário autorizou explicitamente aplicar em `v1` live após revisar a prévia.
3. Publicar a página Reflex sem guarda de autenticação em `/cadastro`; verificar ligação do login, retorno ao login e erros.
4. Rollback: restaurar autenticação no endpoint Xano e `require_auth` na rota Reflex. Contas ativas criadas enquanto o cadastro público esteve aberto não são removidas automaticamente e precisam ser revisadas separadamente.
