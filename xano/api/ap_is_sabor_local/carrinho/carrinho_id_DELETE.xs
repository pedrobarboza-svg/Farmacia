// Delete CARRINHO record.
query "carrinho/{carrinho_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int carrinho_id? filters=min:1
  }

  stack {
    db.del CARRINHO {
      field_name = "id"
      field_value = $input.carrinho_id
    }
  }

  response = null
  guid = "YXaKwV70QGC-kqAihaNKbEhxC_Q"
}