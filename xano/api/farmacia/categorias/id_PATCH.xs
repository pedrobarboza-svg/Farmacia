query "categorias/{id}" verb=PATCH {
  api_group = "Farmácia"

  input {
    int id {
      table = "categorias"
    }
    text nome? filters=trim
    text descricao? filters=trim
  }

  stack {
    var $updates {
      value = {}
    }

    conditional {
      if ($input.nome != null) {
        db.query categorias {
          where = $db.categorias.nome == $input.nome && $db.categorias.id != $input.id
          return = {type: "exists"}
        } as $categoria_existente

        precondition ($categoria_existente == false) {
          error_type = "badrequest"
          error = "Já existe uma categoria com esse nome."
        }

        var.update $updates { value = $updates|set:"nome":$input.nome }
      }
    }

    conditional {
      if ($input.descricao != null) {
        var.update $updates { value = $updates|set:"descricao":$input.descricao }
      }
    }

    db.patch categorias {
      field_name = "id"
      field_value = $input.id
      data = $updates
    } as $categoria
  }

  response = $categoria
  guid = "1m6PtO2yxZmm1be3n9nLHjsR5AU"
}