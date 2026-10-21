query "farmacia-final/produtos/{id}" verb=GET {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    int id
  }

  stack {
    db.get farmacia_final_produtos {
      field_name = "id"
      field_value = $input.id
    } as $produto

    precondition ($produto != null) {
      error_type = "notfound"
      error = "PRODUTO_NAO_ENCONTRADO: o produto não existe."
    }
  }

  response = $produto
  guid = "NbHjMRHbPhwXPdCnWQjMgQ65p70"
}
