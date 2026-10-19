// Status possíveis dos Itens de Pedidos
table STATUS_ITEM {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    text status? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "status", op: "asc"}]}
  ]

  tags = ["status", "sabor"]
  guid = "wQYIPeFDYCQMykGpdA7_ro9Ru3I"
}