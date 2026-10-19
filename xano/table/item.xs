// Itens de Pedidos realizados pelos Clientes
table ITEM {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    int pedido_id? {
      table = "PEDIDO"
    }
  
    int[1:] qtd?
    decimal valor_unit?
    decimal subtotal?
    int produto_id? {
      table = "PRODUTO"
    }
  
    int status_item_id?=3 {
      table = "STATUS_ITEM"
    }
  
    text descricao? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {
      type : "btree|unique"
      field: [
        {name: "pedido_id", op: "asc"}
        {name: "produto_id", op: "asc"}
      ]
    }
  ]

  tags = ["item", "sabor"]
  guid = "VhQnueatBUOyF4NGQGzAxY1gW1Y"
}