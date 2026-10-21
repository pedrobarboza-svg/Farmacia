# cadastro-publico-funcionario Specification

## Purpose

Permitir que uma pessoa sem sessão crie uma conta de funcionário pela interface pública da farmácia. A conta é ativada imediatamente após validação dos dados pelo backend.

## Requirements

### Requirement: Acesso público ao cadastro
O sistema SHALL permitir que visitantes não autenticados abram a página de cadastro de funcionário e SHALL permitir o envio dos dados sem credencial de funcionário.

#### Scenario: Abrir cadastro a partir do login
- **WHEN** um visitante seleciona “Não tem uma conta? Cadastre-se” em `/login`
- **THEN** o sistema navega para `/cadastro` e mostra o formulário público de criação de conta

#### Scenario: Acessar cadastro diretamente
- **WHEN** um visitante não autenticado abre `/cadastro`
- **THEN** o sistema mostra a página de cadastro sem redirecioná-lo para `/login`

### Requirement: Criar e ativar conta pública
O sistema SHALL validar os campos obrigatórios e criar uma conta ativa de funcionário sem exigir sessão autenticada, definindo o estado ativo no backend e aceitando somente cargos ativos cadastrados.

#### Scenario: Cadastro público válido
- **WHEN** um visitante envia nome, e-mail válido, senha e um cargo ativo cadastrado usando um e-mail ainda não cadastrado
- **THEN** o sistema cria um funcionário ativo e confirma o cadastro sem retornar senha, hash ou credencial de sessão

#### Scenario: Visitante tenta definir o estado da conta
- **WHEN** o payload de cadastro contém um campo `ativo`
- **THEN** o backend ignora ou rejeita esse campo e aplica o estado ativo definido pelo servidor

#### Scenario: Campos obrigatórios ausentes ou inválidos
- **WHEN** o visitante envia nome, e-mail, senha ou cargo ausente ou inválido
- **THEN** o backend rejeita o cadastro sem criar funcionário e o sistema apresenta feedback amigável

#### Scenario: Cargo não cadastrado ou inativo
- **WHEN** o visitante envia um cargo inexistente ou marcado como inativo
- **THEN** o backend rejeita o cadastro sem criar funcionário e o sistema informa que deve ser selecionado um cargo disponível

#### Scenario: E-mail já cadastrado
- **WHEN** o visitante envia um e-mail que já pertence a um funcionário
- **THEN** o backend rejeita o cadastro sem criar registro duplicado e o sistema preserva os campos não sensíveis para correção

### Requirement: Proteção dos dados de cadastro
O sistema SHALL armazenar senhas com o mecanismo seguro de senha do Xano e SHALL excluir senha, hash e tokens da resposta pública, da interface e dos logs.

#### Scenario: Resposta de cadastro
- **WHEN** o backend cria um funcionário por cadastro público
- **THEN** a resposta contém apenas dados não sensíveis do funcionário e não inclui senha, hash ou token

#### Scenario: Falha interna no cadastro
- **WHEN** uma falha de rede, protocolo ou servidor impede o cadastro
- **THEN** a interface apresenta uma mensagem genérica sem expor detalhes internos, dados de credencial ou conteúdo bruto da resposta

### Requirement: Interface de cadastro alinhada à marca
A página pública de cadastro SHALL compartilhar a identidade visual da página de login, carregar cargos disponíveis do backend e oferecer navegação de retorno para login.

#### Scenario: Exibir formulário de cadastro
- **WHEN** o visitante abre `/cadastro` e a lista de cargos está disponível
- **THEN** a página exibe o seletor de idioma com Português como padrão, o cabeçalho DROGA-NONIMO com ícone “+%”, o título “Criar conta de funcionário”, o subtítulo de cadastro e campos de nome, e-mail, senha e cargo com ícones, sendo cargo um Select preenchido com cargos ativos

#### Scenario: Listar cargos sem autenticação
- **WHEN** a interface solicita as opções de cargo para um visitante não autenticado
- **THEN** o backend retorna os cargos cadastrados e ativos sem exigir credencial de funcionário

#### Scenario: Falha ao carregar cargos
- **WHEN** a lista de cargos não puder ser carregada ou não contiver opções
- **THEN** a interface apresenta feedback amigável e impede o envio do cadastro até que haja uma opção válida

#### Scenario: Retornar ao login
- **WHEN** o visitante seleciona “Já tem uma conta? Faça login”
- **THEN** o sistema navega para `/login`
