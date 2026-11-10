# Design

## Context

Consulte `proposal.md` para a motivação. A aplicação Reflex já possui a rota protegida `/dashboard`, o estado de autenticação com nome, e-mail e cargo do funcionário e o logout que limpa a sessão. A página atual ainda é uma saudação simples, e o domínio define produtos, categorias, estoque, pedidos e itens de pedido como fontes possíveis para os dados do painel.

## Goals / Non-Goals

**Goals:**

- Transformar `/dashboard` em uma área operacional visualmente consistente com a identidade DROGA-NONIMO.
- Centralizar a composição da sidebar, header, cards e tabela em componentes Reflex reutilizáveis.
- Manter a guarda de autenticação existente e impedir que o cargo seja tratado como permissão.
- Modelar estados de carregamento, vazio e erro para dados de resumo e atividade recente.
- Permitir evolução posterior para endpoints Xano sem acoplar a interface a dados fictícios confirmados.

**Non-Goals:**

- Implementar os módulos completos de Estoque, Vendas ou Usuários.
- Criar autorização por cargo ou novos endpoints Xano.
- Alterar tabelas, regras de desconto, baixa de estoque ou processamento de pagamentos.

## Decisions

### Componentes Reflex nativos e layout responsivo

Usar `rx.hstack` para a estrutura principal, com sidebar de largura fixa e conteúdo flexível, e `rx.vstack`/`rx.grid` para header, cards e tabela. Essa abordagem preserva a exigência de Reflex exclusivo e permite adaptar o conteúdo a telas menores.

Alternativa considerada: introduzir componentes React ou CSS externo. Rejeitada porque adicionaria tecnologia de frontend fora da arquitetura definida e duplicaria o sistema de estilos.

### Sidebar com destinos protegidos explícitos

Os links serão renderizados como destinos operacionais nomeados (`/estoque`, `/vendas` e `/usuarios`) e as páginas poderão ser adicionadas como telas protegidas ou estados de indisponibilidade nesta Change. A sidebar não será usada como mecanismo de autorização; a guarda de sessão continua sendo obrigatória em cada rota.

Alternativa considerada: links visuais sem destino funcional. Rejeitada porque não atende à navegação operacional solicitada.

### Estado do dashboard separado da autenticação

Manter os dados de indicadores e atividade recente em estado dedicado ao dashboard, deixando `AuthState` responsável apenas por sessão e identidade. O estado deverá expor valores tipados e estados explícitos de carregamento/erro, sem retornar sucesso para dados que falharam.

Alternativa considerada: armazenar todos os indicadores em `AuthState`. Rejeitada porque mistura ciclo de vida de sessão com dados operacionais e dificulta recarregamento independente.

### Dados reais quando o contrato estiver disponível

Usar contratos Xano existentes de produtos, estoque e pedidos quando disponíveis; caso uma fonte ainda não exista, a interface deve representar ausência/indisponibilidade claramente em vez de simular valores confirmados. A tabela deverá aceitar uma forma comum de linha para medicamento recente ou movimentação.

Alternativa considerada: hardcode de métricas e medicamentos para preencher a tela. Rejeitada porque apresentaria dados fictícios como dados da farmácia.

## Risks / Trade-offs

- [Os endpoints de métricas e atividade recente podem não estar disponíveis] → Implementar estados vazio/indisponível e deixar a integração isolada no estado do dashboard.
- [Links podem apontar para páginas ainda não implementadas] → Criar destinos protegidos mínimos ou sinalizar indisponibilidade de forma explícita, sem remover a proteção.
- [Muitos cards e tabela podem prejudicar telas pequenas] → Usar grid responsivo, overflow horizontal controlado e sidebar adaptável.
- [Erro de carregamento pode deixar o painel parcialmente vazio] → Exibir feedback por seção e manter header/sidebar funcionais.

## Migration Plan

1. Criar o estado e os componentes visuais do dashboard sem alterar o contrato de autenticação.
2. Adicionar ou atualizar as rotas protegidas do dashboard e dos destinos da sidebar.
3. Conectar as fontes Xano disponíveis e mapear respostas para indicadores e linhas recentes.
4. Validar estados autenticado, não autenticado, vazio e erro com testes Reflex.
5. Em caso de rollback, restaurar a composição anterior da página `/dashboard`; a sessão e os dados Xano permanecem inalterados.
