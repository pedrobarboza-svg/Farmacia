# Inicialização das categorias da farmácia

As categorias padrão são criadas pela função XanoScript `Farmacia/inicializar_categorias`.

## Execução inicial

1. Sincronize/publice no workspace Xano os arquivos `.xs` de `xano/table/categorias.xs` e `xano/function/inicializar_categorias.xs`.
2. No editor do Xano, abra a função **Farmacia/inicializar_categorias** e execute-a pelo recurso de teste/execução da função, sem parâmetros.
3. Confirme a resposta `{ "status": "ok" }` e consulte `GET /categorias`; devem aparecer Remédios, Bebidas, Fraldas e Produtos de Higiene.

A função verifica cada nome antes de inserir. Pode ser executada novamente sem criar duplicatas; o índice único de `categorias.nome` também protege a unicidade.

O inicializador deve ser executado antes de cadastrar produtos. Ele não é chamado pelo endpoint GET, que permanece somente de leitura. Em ambiente com dados preexistentes, faça backup e avalie conflitos antes de aplicar alterações de schema ou executar a inicialização.

## Contrato do catálogo no PDV

Os endpoints de produtos usam `preco` e `estoque`, conforme o schema canónico `produtos`.

### Listagem

`GET /produtos` lista produtos ativos. O filtro `categoria_id` é opcional:

```http
GET /produtos?categoria_id=1
```

A resposta inclui o preço e o saldo atuais. Produtos ativos sem saldo continuam visíveis e têm `disponivel: false`:

```json
[
  {
    "id": 12,
    "categoria_id": 1,
    "nome": "Produto de exemplo",
    "descricao": null,
    "preco": 12.5,
    "estoque": 0,
    "ativo": true,
    "disponivel": false
  }
]
```

### Cadastro e edição

`POST /produtos` requer `categoria_id`, `nome`, `preco` e `estoque`; `descricao` é opcional e `ativo` assume `true` quando omitido.

```json
{
  "categoria_id": 1,
  "nome": "Produto de exemplo",
  "descricao": "Descrição opcional",
  "preco": 12.5,
  "estoque": 8
}
```

`PATCH /produtos/{id}` aceita os mesmos campos como alterações parciais. Campos omitidos permanecem inalterados. Preço deve ser não negativo, estoque deve ser inteiro não negativo e `categoria_id` deve referenciar uma categoria existente.

### Venda e baixa de estoque

`POST /vendas` valida que o produto está ativo e que `quantidade` é um inteiro positivo. A venda é gravada em `vendas`, o item em `itens_venda` e o estoque é decrementado condicionalmente dentro da transação; sem saldo suficiente, a operação deve falhar sem persistir a venda ou o item. A forma de pagamento registrada pelo endpoint permanece `simulado`.

A validação feita nesta alteração é estática pelo Xano Developer MCP. Antes da publicação, execute o endpoint no workspace Xano para confirmar persistência, rollback e concorrência, em particular que `db.direct_query` participa da transação naquele ambiente.
