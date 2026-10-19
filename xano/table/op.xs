// Produtos cadastrados que podem ser incluídos como Itens de Pedidos dos Cliente
table OP {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    int pedido_id? {
      table = "PEDIDO"
    }
  
    int status_oe_id?=1 {
      table = "STATUS_OE"
    }
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]

  tags = ["sabor"]
  guid = "mg8S7HukB8B7ATqGuu2jTi9EFVw"
}