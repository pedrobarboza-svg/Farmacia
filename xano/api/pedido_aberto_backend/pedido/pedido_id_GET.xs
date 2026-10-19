// Get PEDIDO record
query "pedido/{pedido_id}" verb=GET {
  api_group = "pedido_aberto_backend"

  input {
    int pedido_id? filters=min:1
  }

  stack {
    db.get PEDIDO {
      field_name = "id"
      field_value = $input.pedido_id
    } as $model
  
    precondition ($model != null) {
      error_type = "notfound"
      error = "Not Found"
    }
  }

  response = $model
  guid = "v5GHuP0jximF8WD0T2-Hh4pVaTA"
}