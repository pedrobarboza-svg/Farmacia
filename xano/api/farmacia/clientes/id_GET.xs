query "clientes/{id}" verb=GET {
  api_group = "Farmácia"

  input {
    int id
  }

  stack {
    db.get clientes {
      field_name = "id"
      field_value = $input.id
    } as $cliente
  }

  response = $cliente
  guid = "T-xxnYVtS3ubffVMZBOix2DtQ80"
}