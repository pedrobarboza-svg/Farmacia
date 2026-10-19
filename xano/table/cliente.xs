// Clientes que se cadastraram como User e que podem fazer pedidos
table CLIENTE {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    text cpf? filters=trim
    text celular? filters=trim
    int status_cliente_id? {
      table = "STATUS_CLIENTE"
    }
  
    int user_id? {
      table = "user"
    }
  
    text customer_id? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "cpf", op: "asc"}]}
  ]

  tags = ["cliente", "sabor"]
  guid = "vP-3dKGfcevw5pdlR1aqd3GIqmA"
}