// Query all STATUS_PEDIDO records
query status_pedido verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query STATUS_PEDIDO {
      return = {type: "list"}
    } as $status_pedido
  }

  response = $status_pedido
  guid = "5FgslEGmB5nTxOIyoUQM72ZSwMo"
}