query categorias verb=POST {
  api_group = "Farmácia"

  input {
    text nome filters=trim
    text descricao? filters=trim
  }

  stack {
    db.has categorias {
      field_name = "nome"
      field_value = $input.nome
    } as $categoria_existente

    precondition ($categoria_existente == false) {
      error_type = "badrequest"
      error = "Já existe uma categoria com esse nome."
    }

    db.add categorias {
      data = {nome: $input.nome, descricao: $input.descricao}
    } as $categoria
  }

  response = $categoria
  guid = "f5-EK-KbkY1RGMyXpHGzK9jiFv0"
}