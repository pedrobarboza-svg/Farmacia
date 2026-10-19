query "funcionarios/{id}" verb=GET {
  api_group = "Farmácia"

  input {
    int id
  }

  stack {
    db.get funcionarios {
      field_name = "id"
      field_value = $input.id
    } as $funcionario
  }

  response = $funcionario
  guid = "P9_Lr0lo9XBz3iyn_KHQNhmKQu8"
}