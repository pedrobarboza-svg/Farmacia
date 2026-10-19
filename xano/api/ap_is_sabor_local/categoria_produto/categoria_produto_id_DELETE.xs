// Delete Categoria_Produto record.
query "categoria_produto/{categoria_produto_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int categoria_produto_id? filters=min:1
  }

  stack {
    db.del Categoria_Produto {
      field_name = "id"
      field_value = $input.categoria_produto_id
    }
  }

  response = null
  guid = "KRTipUUKKk6DS9fqDMLsGf85ZjY"
}