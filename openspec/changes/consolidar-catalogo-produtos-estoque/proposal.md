# Proposal

## Why

O catálogo da farmácia possui tabelas declaradas com campos de preço e estoque diferentes dos usados pelos endpoints, enquanto o domínio documentado usa uma terceira convenção. Essa divergência impede que cadastro, edição, listagem no PDV e venda operem de forma confiável sobre o mesmo estoque.

## What Changes

- Definir `categorias` e `produtos` como tabelas canónicas do catálogo da farmácia, preservando os nomes já usados pelo grupo de APIs `Farmácia`.
- Alinhar o schema e os endpoints de produtos aos campos `preco` e `estoque`, com preço não negativo e estoque inteiro não negativo.
- Definir regras verificáveis para vínculo obrigatório de produto a categoria, disponibilidade de produtos ativos no PDV e prevenção de venda acima do estoque disponível.
- Manter a mudança limitada ao catálogo e ao controle de estoque da farmácia; pedidos com múltiplos itens, descontos e relatórios permanecem fora deste escopo.

## Capabilities

### New Capabilities

- `catalogo-produtos-estoque`: Modelo canónico de categorias e produtos, gestão de preço/estoque e disponibilidade/listagem de produtos no PDV.

### Modified Capabilities

Nenhuma. O projeto ainda não possui specs publicadas; esta mudança introduz uma capacidade nova.

## Impact

- Tabelas Xano `categorias` e `produtos`, atualmente definidas em `xano/table/categorias.xs` e `xano/table/produtos.xs`.
- Endpoints Xano de categorias e produtos no grupo `Farmácia`, principalmente cadastro, edição, consulta e listagem usados pelo PDV.
- Endpoint de venda existente, na medida necessária para validar e atualizar o estoque usando o modelo canónico. Não inclui processamento real de pagamentos.
- Documentação do domínio, que atualmente descreve `categoria`/`produto` e campos `preco`/`estoque`; a implementação deverá reconciliar a nomenclatura publicada com a decisão desta change.
