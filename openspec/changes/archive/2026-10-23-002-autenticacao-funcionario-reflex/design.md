# Design

## Context

See [proposal.md](./proposal.md) for motivation and scope. A aplicação atual é um esqueleto Reflex (`reflex==0.10.0`); `httpx` já está disponível. O login Xano `POST /farmacia-final/auth/login` retorna `authToken` e dados públicos do funcionário, e o token expira em 24 horas. O endpoint `POST /farmacia-final/funcionarios` exige autenticação e aceita `nome`, `email`, `senha` e `ativo`; a tabela não possui `cargo`. O primeiro funcionário é provisionado administrativamente.

## Goals / Non-Goals

**Goals:**
- Integrar os formulários Reflex às rotas Xano namespaced existentes.
- Não expor o token JWT no browser nem criar rota pública de provisionamento.
- Persistir `cargo` como metadado do funcionário, sem atribuir permissões por esse campo.
- Preservar dados existentes e compatibilidade das chamadas Xano atuais.

**Non-Goals:**
- Criar uma nova política de papéis/permissões, signup anônimo ou bootstrap público.
- Fazer do cargo um mecanismo de autorização.
- Implementar recuperação de senha, MFA ou pagamento real.

## Decisions

### Sessão e proteção de páginas

Guardar o token somente no estado Reflex mantido no servidor por sessão e nunca vinculá-lo a uma variável renderizada no cliente. Embora `rx.Cookie` ofereça opções como `secure` e `same_site`, seu valor permanece acessível ao código do navegador; para este fluxo, o estado server-side evita expor o JWT na superfície do cliente. A sessão também mantém somente os dados públicos necessários do funcionário. O token não será copiado para logs.

Verificar a sessão durante o carregamento de cada página protegida e novamente antes de cada chamada protegida; a navegação no frontend não substitui autenticação no Xano. A página `/login` é pública. `/cadastro` e as demais páginas operacionais exigem sessão, coerente com o contrato atual de `POST /funcionarios`. Após login bem-sucedido, navegar para `/`; logout remove os dados de sessão e volta a `/login`. A duração efetiva é limitada à expiração de 24 horas do token Xano.

Alternativa considerada: armazenar JWT em cookie de browser, inclusive com atributos de segurança. Rejeitada porque o requisito pede manter a credencial fora do armazenamento acessível ao browser e o estado Reflex é isolado por sessão no servidor.

### Integração com Xano

Executar as requisições com `httpx` em handlers Reflex no servidor, usando a URL base configurada por ambiente e não embutida nos componentes. O login envia e-mail e senha a `/farmacia-final/auth/login`; o cadastro envia nome, e-mail, senha e cargo a `/farmacia-final/funcionarios` com o token da sessão no cabeçalho `Authorization: Bearer`. Não persistir senha depois do envio nem incluir credenciais em mensagens de erro.

Mapear HTTP 400 para erro de validação compreensível sem remover nome, e-mail ou cargo digitados; mapear HTTP 401 do login para mensagem genérica de credenciais inválidas e HTTP 401 de uma operação autenticada para encerramento da sessão e retorno ao login. Timeout, indisponibilidade e respostas inesperadas devem produzir feedback genérico explícito e registro server-side sem token, senha ou corpo sensível. Não tratar falhas como sucesso.

Alternativa considerada: chamar Xano diretamente pelo browser. Rejeitada porque exigiria expor o token ao cliente e duplicaria a lógica de sessão.

### Campo `cargo` no contrato Xano

Adicionar `cargo` como texto opcional à tabela `farmacia_final_funcionario` para não exigir migração destrutiva nem backfill dos funcionários já existentes. O endpoint protegido passa a exigir cargo não vazio em novos cadastros e inclui o cargo nos dados públicos de resposta. O campo não participa da autenticação nem altera a autorização atual, que continua baseada apenas em funcionário autenticado. Atualizar o modelo de domínio e os scripts `.xs` versionados.

Alternativa considerada: escolher uma enumeração de cargos e associar permissões. Rejeitada porque o projeto não define lista de cargos nem matriz de autorização; inventá-las permitiria atribuir privilégios sem requisito aprovado. A primeira conta continua a ser criada pelo procedimento administrativo existente e não depende deste formulário.

### Interface e feedback

Usar componentes Reflex nativos para formulários e mensagens visíveis. Validar e-mail e campos obrigatórios antes do envio, mantendo validações autoritativas no Xano. Desabilitar o envio durante a requisição para evitar duplicidade; apresentar erros de campo/retorno sem incluir conteúdo bruto da resposta da API.

## Risks / Trade-offs

- [O estado de sessão pode ser perdido se o processo Reflex for reiniciado ou o token expirar] → redirecionar para `/login` e não oferecer sucesso offline; validar a credencial nas operações Xano.
- [Adicionar `cargo` ao contrato Xano pode conflitar com alterações concorrentes no workspace compartilhado `v1`] → atualizar somente a tabela e endpoint namespaced, revisar diff/prévia e exigir confirmação explícita antes de aplicar.
- [O campo `cargo` pode ser confundido com autorização] → documentar que é metadado e manter todas as permissões iguais às atuais.
- [Erros da API podem conter detalhes internos] → traduzir status conhecidos e não apresentar corpos desconhecidos nem dados sensíveis ao usuário.

## Migration Plan

1. Atualizar documentação do domínio e scripts Xano para acrescentar `cargo` opcional sem alterar registros existentes; exigir valor não vazio somente em novos provisionamentos.
2. Validar os scripts e aplicar a alteração namespaced no Xano após revisão e confirmação explícita; manter rollback restrito ao campo/endpoint alterados e preservar dados cadastrados.
3. Implementar o estado Reflex server-side, os handlers HTTP e as páginas, com URL Xano configurada no ambiente.
4. Testar login válido/inválido, guarda de páginas, cadastro, logout, expiração/401, HTTP 400 e indisponibilidade do Xano sem expor credenciais.
