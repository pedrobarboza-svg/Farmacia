query "farmacia-final/categorias" verb=POST {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    text nome filters=trim
    text descricao? filters=trim
  }

  stack {
    db.get farmacia_final_categorias {
      field_name = "nome"
      field_value = $input.nome
    } as $existente

    precondition ($existente == null) {
      error_type = "inputerror"
      error = "CATEGORIA_DUPLICADA: já existe uma categoria com este nome."
    }

    db.add farmacia_final_categorias {
      data = {
        nome: $input.nome
        descricao: $input.descricao
        ativo: true
      }
    } as $categoria
  }

  response = $categoria
  guid = "cdYCRw-W9VqMOdDUS9yqHGjrKK8"
}
