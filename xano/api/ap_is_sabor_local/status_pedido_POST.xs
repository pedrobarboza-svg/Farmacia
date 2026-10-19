// Add STATUS_PEDIDO record
query status_pedido verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "STATUS_PEDIDO"
    }
  }

  stack {
    db.add STATUS_PEDIDO {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $status_pedido
  }

  response = $status_pedido
  guid = "JfMG8rDUdmq-XwhxR8-M0IVPR_w"
}