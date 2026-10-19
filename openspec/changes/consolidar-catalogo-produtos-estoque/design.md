# Design

## Context

Ver [proposal.md](./proposal.md) para a motivação e [spec.md](./specs/catalogo-produtos-estoque/spec.md) para o contrato comportamental.

O grupo Xano `Farmácia` já consulta as tabelas `categorias` e `produtos`. O schema versionado de `produtos` declara `preco_unitario` e `quantidade_estoque`, enquanto os endpoints usam `preco` e `estoque`; além disso, o estoque está opcional no schema. As tabelas legadas `PRODUTO` e `CATEGORIA` pertencem a outro conjunto de APIs e não devem ser misturadas ao catálogo deste grupo.

## Goals / Non-Goals

**Goals:**
- Tornar o schema versionado e os endpoints do grupo `Farmácia` coerentes com um único contrato de catálogo.
- Garantir que consultas e vendas usem o mesmo preço e saldo de estoque.
- Planejar uma migração que preserve os dados existentes e permita rollback controlado.

**Non-Goals:**
- Unificar os fluxos legados `PRODUTO`/`PEDIDO`/`ITEM` ou APIs de carrinho.
- Alterar autenticação, motor de desconto ou implementar pedidos com múltiplos itens.
- Integrar gateways de pagamento.

## Decisions

1. **Preservar `categorias` e `produtos` como tabelas canónicas.** Os endpoints atuais da farmácia já usam esses identificadores. A alternativa de renomeá-las para `categoria` e `produto` exigiria migrar referências internas sem benefício para o contrato do grupo atual. A documentação de domínio deverá refletir a decisão durante a implementação.

2. **Usar `preco` e `estoque` no schema e na API da farmácia.** Esses nomes já aparecem nos inputs dos endpoints de cadastro, edição e venda e no domínio documentado. `preco` será obrigatório e não negativo; `estoque` será obrigatório, inteiro e não negativo. `categoria_id` continuará sendo obrigatório e referenciando `categorias`. Os campos `preco_unitario` e `quantidade_estoque` não permanecerão como contratos concorrentes após a migração.

3. **A listagem do PDV retorna produtos ativos, inclusive os sem saldo.** A resposta informa preço e estoque atual; estoque zero significa indisponibilidade de venda, não ocultação do produto. O filtro opcional por categoria restringe a lista, e produtos inativos ficam fora da listagem padrão. Isso permite ao funcionário distinguir produto cadastrado sem disponibilidade de produto inexistente.

4. **A venda valida e consome estoque de forma atómica.** A validação usa o saldo vigente e rejeita quantidade não positiva ou acima do saldo. O registro de venda e a baixa devem ser uma única operação consistente, incluindo concorrência por unidades restantes. A implementação deve usar o mecanismo transacional suportado pelo Xano; a sintaxe e as garantias disponíveis serão confirmadas no Xano Developer MCP antes de escrever XanoScript.

## Risks / Trade-offs

- **Dados já implantados podem usar os campos antigos ou diferir do repositório.** Antes de migrar, inspecionar o schema e os valores efetivos no Xano; mapear `preco_unitario` para `preco` e `quantidade_estoque` para `estoque`, registrar conflitos e não descartar dados até validar o resultado.
- **Clientes existentes podem depender dos nomes antigos na resposta da API.** Identificar consumidores do grupo `Farmácia` e coordenar a mudança de contrato; evitar manter aliases permanentes, pois perpetuariam dois contratos.
- **A atomicidade pode não estar representada nos endpoints atuais.** Validar o mecanismo suportado pelo Xano e cobrir falhas entre criação de venda e baixa de estoque antes da liberação.
- **As tabelas legadas têm nomes parecidos e modelos incompatíveis.** Restringir todas as alterações aos arquivos e rotas do grupo `Farmácia`, sem modificar APIs de carrinho/Asaas por associação nominal.

## Migration Plan

1. Inspecionar no ambiente Xano alvo os schemas efetivos, registros existentes, endpoints consumidores e os valores atuais dos campos antigos.
2. Fazer backup dos dados e definir como resolver registros com valores ausentes ou conflitantes; não inferir preço ou saldo quando não houver fonte confiável.
3. Atualizar o schema e os endpoints para o contrato canónico, fazendo o backfill controlado dos campos e validando contagens, categorias referenciadas, preços e saldos.
4. Validar cadastro, edição, listagem do PDV, venda com saldo suficiente, insuficiência de estoque e concorrência; liberar somente após os invariantes serem confirmados.
5. Em caso de falha, interromper escritas e restaurar schema/dados a partir do backup ou reverter a migração mapeada antes de retomar tráfego.

## Open Questions

Nenhuma decisão de contrato ficou pendente para a proposta. A inspeção do estado real dos dados Xano é pré-condição operacional da implementação, não uma escolha de escopo.
