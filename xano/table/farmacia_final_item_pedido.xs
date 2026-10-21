table farmacia_final_item_pedido {
  auth = false

  schema {
    int id
    int pedido_id {
      table = "farmacia_final_pedido"
    }
    int produto_id {
      table = "farmacia_final_produtos"
    }
    int quantidade filters=min:1
    decimal preco_unitario filters=min:0
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "pedido_id", op: "asc"}]}
    {type: "btree", field: [{name: "produto_id", op: "asc"}]}
  ]
  guid = "Rfsfpa75WImDaBpwB3UzIKC1izo"
}
