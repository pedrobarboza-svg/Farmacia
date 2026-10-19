query "produtos/{id}" verb=GET {
  api_group = "Farmácia"

  input {
    int id
  }

  stack {
    db.get produtos {
      field_name = "id"
      field_value = $input.id
    } as $produto
  }

  response = $produto
  guid = "lUXOXNpr96wfv9RhMfn6L-KCKNE"
}