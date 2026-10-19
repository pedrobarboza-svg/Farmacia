// Delete CARRINHO record.
query "carrinho/{carrinho_id}" verb=DELETE {
  api_group = "AuthSaborLocal"

  input {
    int carrinho_id? filters=min:1
  }

  stack {
    db.del "" {
      field_name = "id"
      field_value = $input.carrinho_id
    }
  }

  response = null
  guid = "OcFHrtmVBCQTWV1eIFu6GpV6mSo"
}