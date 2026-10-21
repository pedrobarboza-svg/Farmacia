query "farmacia-final/produtos/{id}" verb=PATCH {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    int id
    text nome? filters=trim
    text descricao? filters=trim
    decimal preco? filters=min:0
    int estoque? filters=min:0
    int categoria_id?
    bool ativo?
  }

  stack {
    db.get farmacia_final_produtos {
      field_name = "id"
      field_value = $input.id
    } as $existente

    precondition ($existente != null) {
      error_type = "notfound"
      error = "PRODUTO_NAO_ENCONTRADO: o produto não existe."
    }

    var $updates {
      value = {}
    }

    conditional {
      if ($input.nome != null) {
        var.update $updates.nome { value = $input.nome }
      }
    }
    conditional {
      if ($input.descricao != null) {
        var.update $updates.descricao { value = $input.descricao }
      }
    }
    conditional {
      if ($input.preco != null) {
        precondition ($input.preco == ($input.preco|round:2)) {
          error_type = "inputerror"
          error = "PRECO_INVALIDO: informe o preço com no máximo duas casas decimais."
        }

        var.update $updates.preco { value = $input.preco }
      }
    }
    conditional {
      if ($input.estoque != null) {
        var.update $updates.estoque { value = $input.estoque }
      }
    }
    conditional {
      if ($input.categoria_id != null) {
        db.get farmacia_final_categorias {
          field_name = "id"
          field_value = $input.categoria_id
        } as $categoria

        precondition (($categoria != null) && ($categoria.ativo == true)) {
          error_type = "inputerror"
          error = "CATEGORIA_INVALIDA: selecione uma categoria ativa."
        }

        var.update $updates.categoria_id { value = $input.categoria_id }
      }
    }
    conditional {
      if ($input.ativo != null) {
        var.update $updates.ativo { value = $input.ativo }
      }
    }

    precondition (($updates|is_empty) == false) {
      error_type = "inputerror"
      error = "ATUALIZACAO_VAZIA: informe ao menos um campo."
    }

    db.patch farmacia_final_produtos {
      field_name = "id"
      field_value = $input.id
      data = $updates
    } as $produto
  }

  response = $produto
  guid = "oo5_BoQ5kqQ8B0RAhtkvxxK-wMM"
}
