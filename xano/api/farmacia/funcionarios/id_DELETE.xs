query "funcionarios/{id}" verb=DELETE {
  api_group = "Farmácia"

  input {
    int id
  }

  stack {
    db.edit funcionarios {
      field_name = "id"
      field_value = $input.id
      data = {ativo: false}
    } as $funcionario
  }

  response = $funcionario
  guid = "2PDWSE1y2WiVNefL0R-xRqh2aNo"
}