# Proposal

## Why

O domínio da farmácia define entidades e regras para funcionários, clientes, pedidos e itens, mas o backend contém schemas legados com nomes e campos diferentes e ainda não oferece um contrato completo para o fluxo de venda. Esta change propõe um schema inicial canónico e APIs Xano que preservam autenticação, desconto e estoque em operações consistentes.

## What Changes

- Definir o schema Xano isolado em tabelas `farmacia_final_*` para funcionários, clientes, categorias, produtos, pedidos e itens, incluindo tipos, relações, unicidade e valores iniciais das categorias.
- Especificar APIs REST sob `/farmacia-final/*` para autenticação, cadastro e consulta de clientes, gestão de catálogo, montagem e fechamento de pedidos e relatórios de vendas.
- Definir o fechamento do pedido como a operação que calcula valores, aplica desconto elegível, baixa estoque e muda o status para `concluido` dentro de uma transação.
- Documentar no arquivo solicitado `openspec/changes/001-criar-tabelas-e-apis-xano.md` a referência técnica e os exemplos XanoScript para criação/aplicação no backend.
- Manter os objetos preexistentes do workspace Xano intactos: o destino contém outras aplicações e dados nas tabelas `pedido`, `cliente`, `produtos` e entidades legadas.
- Não incluir processamento real de pagamentos; o estado `concluido` representa o fechamento simulado da venda, sem integração com gateway.

## Capabilities

### New Capabilities

- `autenticacao-funcionarios`: autenticação e proteção das operações da farmácia por funcionário.
- `identificacao-clientes`: cadastro e busca de clientes com CPF único e associação opcional à venda.
- `pedidos-vendas`: montagem, fechamento, cálculo de desconto, consistência de estoque e consultas de vendas.

### Modified Capabilities

Nenhuma. A capacidade existente `catalogo-produtos-estoque` já especifica categorias, produtos e baixa consistente de estoque; esta change define o schema e os contratos de API sem alterar esse comportamento.

## Impact

- Backend Xano: criação de seis tabelas namespaced e endpoints isolados no grupo da API da farmácia; scripts e tabelas já existentes permanecem inalterados.
- Migração: não haverá migração nem reutilização de registros existentes nesta aplicação; o schema namespaced evita colisões e preserva dados de outros fluxos do workspace.
- Segurança: as senhas não serão retornadas pela API; operações de gestão exigirão autenticação de funcionário. A política de provisionamento inicial de funcionários deve evitar cadastro público não autenticado.
- Integridade: o fechamento deve validar todos os itens e estoque disponível antes de confirmar qualquer alteração, aplicar 15% somente com cliente e subtotal estritamente acima de R$ 100,00, e reverter integralmente em caso de falha.
