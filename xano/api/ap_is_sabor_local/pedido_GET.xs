// Query all PEDIDO records
query pedido verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query PEDIDO {
      return = {type: "list"}
    } as $pedido
  }

  response = $pedido
  guid = "gQ36GH8t9oaMXr-GBmqWmtN0lfc"
}