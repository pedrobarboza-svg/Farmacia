query "farmacia-final/produtos" verb=POST {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    text nome filters=trim
    text descricao? filters=trim
    text imagem_url? filters=trim
    decimal preco filters=min:0
    int estoque filters=min:0
    int categoria_id
  }

  stack {
    precondition (($input.imagem_url == null) || ((($input.imagem_url|strlen) > 7) && (($input.imagem_url|starts_with:"http://") || (($input.imagem_url|strlen) > 8) && ($input.imagem_url|starts_with:"https://")))) {
      error_type = "inputerror"
      error = "IMAGEM_URL_INVALIDA: informe uma URL HTTP ou HTTPS válida."
    }
  
    precondition ($input.preco == ($input.preco|round:2)) {
      error_type = "inputerror"
      error = "PRECO_INVALIDO: informe o preço com no máximo duas casas decimais."
    }
  
    db.get farmacia_final_categorias {
      field_name = "id"
      field_value = $input.categoria_id
    } as $categoria
  
    precondition (($categoria != null) && $categoria.ativo) {
      error_type = "inputerror"
      error = "CATEGORIA_INVALIDA: selecione uma categoria ativa."
    }
  
    db.add farmacia_final_produtos {
      data = {
        nome        : $input.nome
        descricao   : $input.descricao
        imagem_url  : $input.imagem_url
        preco       : $input.preco
        estoque     : $input.estoque
        categoria_id: $input.categoria_id
        ativo       : true
      }
    } as $produto
  }

  response = $produto
  guid = "_D0Z_8msO8WlEuNolw0KyNOB7ZI"
}