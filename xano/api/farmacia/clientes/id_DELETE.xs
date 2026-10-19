query "clientes/{id}" verb=DELETE {
  api_group = "Farmácia"

  input {
    int id
  }

  stack {
    db.edit clientes {
      field_name = "id"
      field_value = $input.id
      data = {ativo: false}
    } as $cliente
  }

  response = $cliente
  guid = "xQhVvh13sUAWTfOFMM2S9y4uFJo"
}