// Delete PRODUTO record.
query "produto/{produto_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int produto_id? filters=min:1
  }

  stack {
    db.del PRODUTO {
      field_name = "id"
      field_value = $input.produto_id
    }
  }

  response = null
  guid = "xvzH6chfwMieGQ2xRplcLyjD3v0"
}