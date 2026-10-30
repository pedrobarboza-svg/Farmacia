# Spec Delta

## Purpose

Definir um dashboard operacional protegido para que funcionários acompanhem os principais indicadores da farmácia e acessem os módulos de estoque, vendas e usuários em um único painel.

## ADDED Requirements

### Requirement: Dashboard protegido e navegação operacional
O sistema SHALL exibir o dashboard principal somente para funcionários autenticados e SHALL disponibilizar navegação lateral para Estoque, Vendas e Usuários.

#### Scenario: Funcionário autenticado acessa o dashboard
- **WHEN** um funcionário com sessão válida acessa `/dashboard`
- **THEN** o sistema exibe a sidebar, o header, os indicadores e a atividade recente

#### Scenario: Pessoa não autenticada acessa o dashboard
- **WHEN** uma pessoa sem sessão válida acessa `/dashboard`
- **THEN** o sistema redireciona para `/login` sem exibir conteúdo operacional

#### Scenario: Navegação para módulo operacional
- **WHEN** um funcionário autenticado seleciona Estoque, Vendas ou Usuários na sidebar
- **THEN** o sistema navega para o destino protegido correspondente sem remover a sessão

### Requirement: Identificação do funcionário e encerramento
O sistema SHALL exibir o nome do funcionário autenticado no header e SHALL oferecer uma ação visível para encerrar a sessão.

#### Scenario: Header com funcionário autenticado
- **WHEN** o dashboard é renderizado com uma sessão válida
- **THEN** o header exibe o nome do funcionário e, quando disponível, seu cargo

#### Scenario: Logout pelo dashboard
- **WHEN** o funcionário seleciona o botão Sair
- **THEN** o sistema remove a sessão e redireciona para `/login`

### Requirement: Indicadores resumidos da farmácia
O sistema SHALL exibir cards identificados para Vendas do dia, Alertas de estoque baixo e Total de medicamentos.

#### Scenario: Indicadores disponíveis
- **WHEN** o dashboard carrega os dados resumidos
- **THEN** cada card exibe seu título, valor atual e unidade ou contexto compreensível

#### Scenario: Falha ou ausência de dados de indicadores
- **WHEN** os dados de um indicador não estão disponíveis
- **THEN** o sistema exibe um estado neutro ou mensagem de indisponibilidade sem apresentar valores inventados como confirmados

### Requirement: Atividade recente de medicamentos
O sistema SHALL exibir uma tabela com os medicamentos cadastrados recentemente ou movimentações recentes, incluindo informação suficiente para identificar cada registro.

#### Scenario: Existem registros recentes
- **WHEN** há medicamentos ou movimentações recentes disponíveis
- **THEN** a tabela exibe os registros em ordem decrescente de recência com nome, categoria ou tipo de movimento, data e situação ou quantidade

#### Scenario: Não existem registros recentes
- **WHEN** não há medicamentos ou movimentações recentes
- **THEN** o sistema exibe uma mensagem de estado vazio no lugar de uma tabela sem contexto

#### Scenario: Dados recentes indisponíveis
- **WHEN** a consulta de atividade recente falha
- **THEN** o sistema informa que os dados não puderam ser carregados e preserva o restante do dashboard
