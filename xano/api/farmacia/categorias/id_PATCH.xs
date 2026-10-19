query "categorias/{id}" verb=PATCH {
  api_group = "Farmácia"

  input {
    int id
    text nome?
    text descricao?
  }

  stack {
    db.edit categorias {
      field_name = "id"
      field_value = $input.id
      data = {nome: $input.nome, descricao: $input.descricao}
    } as $categoria
  }

  response = $categoria
  guid = "1m6PtO2yxZmm1be3n9nLHjsR5AU"
}