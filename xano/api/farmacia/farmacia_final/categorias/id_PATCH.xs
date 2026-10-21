query "farmacia-final/categorias/{id}" verb=PATCH {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    int id
    text nome? filters=trim
    text descricao? filters=trim
    bool ativo?
  }

  stack {
    db.get farmacia_final_categorias {
      field_name = "id"
      field_value = $input.id
    } as $existente

    precondition ($existente != null) {
      error_type = "notfound"
      error = "CATEGORIA_NAO_ENCONTRADA: a categoria não existe."
    }

    var $updates {
      value = {}
    }

    conditional {
      if ($input.nome != null) {
        var.update $updates.nome {
          value = $input.nome
        }
      }
    }

    conditional {
      if ($input.descricao != null) {
        var.update $updates.descricao {
          value = $input.descricao
        }
      }
    }

    conditional {
      if ($input.ativo != null) {
        var.update $updates.ativo {
          value = $input.ativo
        }
      }
    }

    precondition (($updates|is_empty) == false) {
      error_type = "inputerror"
      error = "ATUALIZACAO_VAZIA: informe ao menos um campo."
    }

    db.patch farmacia_final_categorias {
      field_name = "id"
      field_value = $input.id
      data = $updates
    } as $categoria
  }

  response = $categoria
  guid = "2nO7zB6fodTFI2PXP9lzUvsVgM8"
}
