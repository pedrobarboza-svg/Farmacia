query "produtos/{id}" verb=DELETE {
  api_group = "Farmácia"

  input {
    int id
  }

  stack {
    db.edit produtos {
      field_name = "id"
      field_value = $input.id
      data = {ativo: false}
    } as $produto
  }

  response = $produto
  guid = "q8xjJ4jmoaWhqJVlzcp07Jll_Wk"
}