query "farmacia-final/categorias/{id}" verb=GET {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    int id
  }

  stack {
    db.get farmacia_final_categorias {
      field_name = "id"
      field_value = $input.id
    } as $categoria

    precondition ($categoria != null) {
      error_type = "notfound"
      error = "CATEGORIA_NAO_ENCONTRADA: a categoria não existe."
    }
  }

  response = $categoria
  guid = "3GSGdAB9QfIiIQmP2LKMYIBgKv4"
}
