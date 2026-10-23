# Proposal

## Why

O sistema já autentica funcionários e redireciona para uma rota protegida, mas essa rota ainda exibe apenas uma saudação simples. Um dashboard operacional permitirá que o funcionário navegue pelos módulos principais e acompanhe rapidamente vendas, estoque e medicamentos recentes em uma interface consistente do DROGA-NONIMO.

## What Changes

- Criar um dashboard principal em Reflex na rota protegida `/dashboard`.
- Adicionar sidebar com links protegidos para Estoque, Vendas e Usuários.
- Adicionar header com a marca DROGA-NONIMO, nome e cargo do funcionário logado e ação de logout.
- Exibir cards de Vendas do dia, Alertas de estoque baixo e Total de medicamentos.
- Exibir tabela responsiva com medicamentos cadastrados recentemente ou movimentações recentes.
- Preservar a proteção de autenticação existente para a página e para os links operacionais.
- Manter os dados apresentados em estado explícito e preparado para integração com Xano, sem criar pagamento real ou alterar regras de estoque nesta Change.

## Capabilities

### New Capabilities

- `dashboard-operacional`: Dashboard protegido para navegação operacional, resumo de indicadores e listagem de atividade recente.

### Modified Capabilities

Nenhuma.

## Impact

- Frontend Reflex em `farmaciaFinal/farmaciaFinal.py`.
- Possível extensão de estado em `farmaciaFinal/auth_state.py` ou novo estado dedicado ao dashboard.
- Integração futura ou existente com endpoints Xano de produtos, estoque e vendas; contratos de dados devem respeitar `docs/domain-model.md`.
- Testes automatizados de proteção da rota, navegação, indicadores e tabela.
- Fora do escopo: gateway de pagamento real, novas permissões por cargo, alteração de tabelas Xano, criação de endpoints de vendas/estoque e implementação completa dos módulos vinculados.
