# Spec Delta

## Purpose

Define como funcionários autenticam-se no backend e como a API protege operações de gestão, sem expor credenciais ou permitir acesso não autenticado.

## ADDED Requirements

### Requirement: Autenticação de funcionários
O sistema SHALL autenticar funcionários por e-mail e senha validada no backend e SHALL emitir credencial de sessão somente para contas ativas.

#### Scenario: Login válido
- **WHEN** um funcionário ativo informa credenciais válidas
- **THEN** a API retorna a credencial de autenticação e os dados públicos do funcionário, sem retornar senha ou hash

#### Scenario: Credenciais inválidas ou conta inativa
- **WHEN** as credenciais são inválidas ou a conta está inativa
- **THEN** a API rejeita o login sem revelar se o e-mail existe e não emite credencial

### Requirement: Proteção das operações de gestão
O sistema SHALL exigir autenticação válida de funcionário para operações de gestão de funcionários, clientes, catálogo, pedidos e relatórios, exceto login e consulta pública explicitamente prevista.

#### Scenario: Requisição sem credencial
- **WHEN** uma requisição protegida não apresenta credencial válida
- **THEN** a API rejeita a requisição sem executar alterações ou revelar dados protegidos

#### Scenario: Provisionar funcionário
- **WHEN** um funcionário é provisionado por operação autorizada
- **THEN** a API exige autenticação e valida e-mail único, e não permite cadastro público anônimo
