query "categorias/{id}" verb=GET {
  api_group = "Farmácia"

  input {
    int id
  }

  stack {
    db.get categorias {
      field_name = "id"
      field_value = $input.id
    } as $categoria
  }

  response = $categoria
  guid = "xUAVXAm-GYFS6oADniySawXYf9A"
}