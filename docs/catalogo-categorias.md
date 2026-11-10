# Inicialização das categorias da farmácia

As categorias padrão são criadas pelo endpoint autenticado
`POST /farmacia-final/categorias/inicializar`.

## Execução inicial

1. Sincronize/publice no workspace Xano a tabela
   `xano/table/farmacia_final_categorias.xs` e o endpoint
   `xano/api/farmacia/farmacia_final/categorias/inicializar_POST.xs`.
2. No editor do Xano, autentique-se como funcionário e execute
   `POST /farmacia-final/categorias/inicializar`, sem parâmetros.
3. Confirme a resposta e consulte `GET /farmacia-final/categorias`; devem aparecer
   as categorias ativas da tabela `farmacia_final_categorias`.

O endpoint verifica cada nome antes de inserir. Pode ser executado novamente sem
criar duplicatas; o índice único de `farmacia_final_categorias.nome` também
protege a unicidade.

O inicializador é chamado pelo frontend antes de carregar o estoque. O endpoint
GET permanece somente de leitura. Em ambiente com dados preexistentes, faça
backup e avalie conflitos antes de aplicar alterações de schema ou executar a
inicialização.

## Contrato do catálogo no PDV

Os endpoints de produtos usam `preco` e `estoque`, conforme o schema canónico
`farmacia_final_produtos`, com `categoria_id` referenciando
`farmacia_final_categorias`.

### Listagem

`GET /farmacia-final/produtos` lista produtos ativos. O filtro `categoria_id` é
opcional:

```http
GET /farmacia-final/produtos?categoria_id=1
```

A resposta inclui o preço e o saldo atuais. Produtos ativos sem saldo continuam visíveis e têm `disponivel: false`:

```json
[
  {
    "id": 12,
    "categoria_id": 1,
    "nome": "Produto de exemplo",
    "descricao": null,
    "imagem_url": "https://example.com/produto.png",
    "preco": 12.5,
    "estoque": 0,
    "ativo": true,
    "disponivel": false
  }
]
```

### Cadastro e edição

`POST /farmacia-final/produtos` requer `categoria_id`, `nome`, `preco` e
`estoque`; `descricao` e `imagem_url` são opcionais e `ativo` assume `true`
quando omitido. `imagem_url`, quando informado, deve ser uma URL absoluta
HTTP ou HTTPS; uma string vazia remove a referência na edição.

```json
{
  "categoria_id": 1,
  "nome": "Produto de exemplo",
  "descricao": "Descrição opcional",
  "imagem_url": "https://example.com/produto.png",
  "preco": 12.5,
  "estoque": 8
}
```

`PATCH /farmacia-final/produtos/{id}` aceita os mesmos campos como alterações
parciais. Campos omitidos permanecem inalterados. Preço deve ser não negativo,
estoque deve ser inteiro não negativo e `categoria_id` deve referenciar uma
categoria existente.

### Venda e baixa de estoque

`POST /farmacia-final/pedidos/{id}/fechar` valida que o produto está ativo e
que `quantidade` é um inteiro positivo. O pedido usa
`farmacia_final_pedido`, os itens usam `farmacia_final_item_pedido` e os
produtos usam `farmacia_final_produtos`; o estoque é decrementado
condicionalmente dentro da transação.

A validação feita nesta alteração é estática pelo Xano Developer MCP. Antes da publicação, execute o endpoint no workspace Xano para confirmar persistência, rollback e concorrência, em particular que `db.direct_query` participa da transação naquele ambiente.
