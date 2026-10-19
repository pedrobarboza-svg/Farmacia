// Add PEDIDO record
query pedido verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "PEDIDO"
    }
  }

  stack {
    db.add PEDIDO {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $pedido
  }

  response = $pedido
  guid = "oasc5BsJt_jmuc9R0sMmO14ryC0"
}