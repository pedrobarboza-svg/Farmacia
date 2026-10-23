# autenticacao-funcionarios Specification

## Purpose

Define a autenticação integrada entre a interface da farmácia e o Xano, incluindo sessão segura, proteção das páginas operacionais e provisionamento autenticado de funcionários.

## Requirements

### Requirement: Login de funcionário
O sistema SHALL autenticar funcionários ativos usando e-mail e senha e SHALL iniciar uma sessão somente quando o Xano confirmar as credenciais.

#### Scenario: Login com credenciais válidas
- **WHEN** um funcionário ativo informa e-mail e senha válidos
- **THEN** o sistema inicia a sessão autenticada e redireciona o funcionário para a página inicial protegida

#### Scenario: Credenciais inválidas ou funcionário inativo
- **WHEN** o Xano rejeita as credenciais ou a conta está inativa
- **THEN** o sistema não inicia uma sessão e exibe uma mensagem que não revela se o e-mail existe

### Requirement: Proteção e encerramento da sessão
O sistema SHALL exigir uma sessão autenticada para acessar páginas operacionais e SHALL permitir que o funcionário encerre a própria sessão.

#### Scenario: Acesso a uma rota protegida sem sessão
- **WHEN** uma pessoa não autenticada acessa uma página operacional ou `/cadastro`
- **THEN** o sistema redireciona para `/login` sem mostrar conteúdo protegido

#### Scenario: Sessão expirada ou rejeitada
- **WHEN** uma chamada protegida ao Xano retorna HTTP 401
- **THEN** o sistema remove a sessão local, informa que a sessão expirou e redireciona para `/login`

#### Scenario: Logout
- **WHEN** o funcionário solicita sair
- **THEN** o sistema remove a credencial e os dados da sessão e redireciona para `/login`

### Requirement: Proteção da credencial de sessão
O sistema SHALL manter a credencial de autenticação no contexto de sessão do servidor e SHALL impedir sua exposição em conteúdo, variáveis ou armazenamento acessíveis ao navegador.

#### Scenario: Uso da credencial em uma operação protegida
- **WHEN** o sistema chama uma API protegida do Xano
- **THEN** a credencial é enviada somente pelo servidor ao Xano e não é retornada ao navegador como dado de interface

### Requirement: Provisionamento autenticado de funcionário
O sistema SHALL permitir que um funcionário autenticado cadastre outro funcionário com nome, e-mail, senha e cargo, persistindo o cargo sem usá-lo como concessão de permissões.

#### Scenario: Cadastro válido
- **WHEN** um funcionário autenticado envia dados válidos para cadastro
- **THEN** o Xano cria o novo funcionário, armazena a senha de forma segura e retorna somente dados não sensíveis, incluindo o cargo

#### Scenario: Cadastro sem sessão válida
- **WHEN** uma pessoa não autenticada tenta acessar ou enviar o formulário de cadastro
- **THEN** o sistema redireciona para `/login` e o Xano não cria o funcionário

#### Scenario: Dados inválidos ou e-mail duplicado
- **WHEN** o Xano rejeita o cadastro por validação ou duplicidade de e-mail com HTTP 400
- **THEN** o sistema mantém o formulário e apresenta uma mensagem amigável sem apagar os valores não sensíveis

### Requirement: Feedback de falhas de autenticação
O sistema SHALL apresentar feedback compreensível para erros HTTP 400 e 401 do Xano sem expor detalhes internos, credenciais ou hashes.

#### Scenario: Erro de validação HTTP 400
- **WHEN** uma tentativa de login ou cadastro retorna HTTP 400
- **THEN** o sistema apresenta uma mensagem de validação associada à operação e permite corrigir os campos

#### Scenario: Erro HTTP 401
- **WHEN** o login retorna HTTP 401 ou uma operação protegida perde a autenticação
- **THEN** o sistema apresenta feedback apropriado e aplica o comportamento de sessão definido para a operação
