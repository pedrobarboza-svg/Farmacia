query "farmacia-final/produtos" verb=POST {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    text nome filters=trim
    text descricao? filters=trim
    decimal preco filters=min:0
    int estoque filters=min:0
    int categoria_id
  }

  stack {
    precondition ($input.preco == ($input.preco|round:2)) {
      error_type = "inputerror"
      error = "PRECO_INVALIDO: informe o preço com no máximo duas casas decimais."
    }

    db.get farmacia_final_categorias {
      field_name = "id"
      field_value = $input.categoria_id
    } as $categoria

    precondition (($categoria != null) && ($categoria.ativo == true)) {
      error_type = "inputerror"
      error = "CATEGORIA_INVALIDA: selecione uma categoria ativa."
    }

    db.add farmacia_final_produtos {
      data = {
        nome: $input.nome
        descricao: $input.descricao
        preco: $input.preco
        estoque: $input.estoque
        categoria_id: $input.categoria_id
        ativo: true
      }
    } as $produto
  }

  response = $produto
  guid = "_D0Z_8msO8WlEuNolw0KyNOB7ZI"
}
