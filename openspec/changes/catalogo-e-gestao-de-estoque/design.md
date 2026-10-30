# Design

## Context

Ver [proposal.md](./proposal.md) para a motivação e [spec.md](./specs/catalogo-produtos-estoque/spec.md) para o contrato comportamental.

O grupo Xano `Farmácia` já consulta as tabelas `categorias` e `produtos`. O schema versionado de `produtos` declara `preco_unitario` e `quantidade_estoque`, enquanto os endpoints usam `preco` e `estoque`; além disso, o estoque está opcional no schema. As tabelas legadas `PRODUTO` e `CATEGORIA` pertencem a outro conjunto de APIs e não devem ser misturadas ao catálogo deste grupo. Para esta implementação, os arquivos `.xs` versionados no repositório são a fonte de verdade; o escopo não inclui inspecionar nem alterar diretamente uma instância Xano implantada.

## Goals / Non-Goals

**Goals:**
- Tornar o schema versionado e os endpoints do grupo `Farmácia` coerentes com um único contrato de catálogo.
- Garantir que consultas e vendas usem o mesmo preço e saldo de estoque.
- Atualizar a documentação de domínio para refletir o contrato versionado.

**Non-Goals:**
- Unificar os fluxos legados `PRODUTO`/`PEDIDO`/`ITEM` ou APIs de carrinho.
- Alterar autenticação, motor de desconto ou implementar pedidos com múltiplos itens.
- Integrar gateways de pagamento.
- Executar migração de dados, backup ou implantação numa instância Xano.

## Decisions

1. **Preservar `categorias` e `produtos` como tabelas canónicas.** Os endpoints atuais da farmácia já usam esses identificadores. A alternativa de renomeá-las para `categoria` e `produto` exigiria migrar referências internas sem benefício para o contrato do grupo atual. A documentação de domínio deverá refletir a decisão durante a implementação.

2. **Usar `preco` e `estoque` no schema e na API da farmácia.** Esses nomes já aparecem nos inputs dos endpoints de cadastro, edição e venda e no domínio documentado. `preco` será obrigatório e não negativo; `estoque` será obrigatório, inteiro e não negativo. `categoria_id` continuará sendo obrigatório e referenciando `categorias`. Os campos `preco_unitario` e `quantidade_estoque` não permanecerão como contratos concorrentes após a migração.

3. **A listagem do PDV retorna produtos ativos, inclusive os sem saldo.** A resposta informa preço e estoque atual; estoque zero significa indisponibilidade de venda, não ocultação do produto. O filtro opcional por categoria restringe a lista, e produtos inativos ficam fora da listagem padrão. Isso permite ao funcionário distinguir produto cadastrado sem disponibilidade de produto inexistente.

4. **Provisionar as categorias padrão por inicializador explícito.** Uma função XanoScript idempotente cria cada uma das quatro categorias somente quando seu nome ainda não existe. O GET de categorias permanece somente leitura; a função é executada uma vez no ambiente antes do uso do catálogo, podendo ser executada novamente com segurança.

5. **Registrar a venda com o modelo versionado.** `vendas` guarda os totais, enquanto `itens_venda` guarda produto, quantidade, preço unitário congelado e subtotal do item. O endpoint deve persistir os dois registros sem introduzir campos de item inexistentes em `vendas`.

6. **A venda valida e consome estoque de forma atómica.** Um `UPDATE` condicional parametrizado decrementa o estoque somente quando ainda há saldo suficiente; se nenhuma linha for atualizada, a operação falha como estoque insuficiente. Esse decremento, a criação da venda e do item ficam dentro de `db.transaction`. A condição no próprio `UPDATE` evita a corrida de duas vendas que leem o mesmo saldo antes de atualizá-lo.

## Risks / Trade-offs

- **Schema implantado pode divergir dos arquivos locais.** A mudança alinha o repositório e não migra dados remotos; antes de publicar os schemas, um operador deve inspecionar o ambiente Xano, fazer backup e mapear `preco_unitario`/`quantidade_estoque` para `preco`/`estoque`, resolvendo conflitos com dados confirmados.
- **Clientes existentes podem depender dos nomes antigos na resposta da API.** Identificar consumidores do grupo `Farmácia` e coordenar a mudança de contrato; evitar manter aliases permanentes, pois perpetuariam dois contratos.
- **A atomicidade depende de `db.direct_query` participar da transação.** O XanoScript do MCP valida sintaxe, mas a garantia em runtime precisa ser confirmada antes de publicar; se a operação SQL não participar da transação, não liberar o endpoint até adotar mecanismo equivalente.
- **Schema de vendas pode não corresponder ao estado implantado.** O endpoint local é alinhado a `vendas` e `itens_venda`; não aplicar esse schema em ambientes com dados sem backup e migração próprios.
- **As tabelas legadas têm nomes parecidos e modelos incompatíveis.** Restringir todas as alterações aos arquivos e rotas do grupo `Farmácia`, sem modificar APIs de carrinho/Asaas por associação nominal.

## Repository Implementation and Deployment Boundary

1. Inspecionar os schemas e referências nos arquivos `.xs` locais e tratar esses contratos como fonte de verdade para a alteração.
2. Atualizar os schemas e endpoints locais para os campos canónicos e validar sua sintaxe com o Xano Developer MCP.
3. Validar sintaxe e referências dos arquivos `.xs` no Xano Developer MCP e revisar os caminhos de estoque suficiente/insuficiente e rollback transacional.
4. Não publicar os schemas diretamente numa instância que contenha dados reais sem backup e migração explícita dos campos antigos; confirmar em runtime que a atualização condicional participa da transação antes de liberar a venda. Essas operações exigem avaliação do ambiente e ficam fora desta change.

## Open Questions

Nenhuma decisão de contrato ficou pendente para a proposta. O inventário e a migração de dados de uma instância remota são pré-condições para uma publicação posterior, não para a implementação local desta change.
