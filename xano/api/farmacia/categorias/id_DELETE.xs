query "categorias/{id}" verb=DELETE {
  api_group = "Farmácia"

  input {
    int id
  }

  stack {
    db.del categorias {
      field_name = "id"
      field_value = $input.id
    }
  }

  response = true
  guid = "iOadY_r_Q0lvKDgyS2iuTZpfVM4"
}