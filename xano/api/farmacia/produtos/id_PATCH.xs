query "produtos/{id}" verb=PATCH {
  api_group = "Farmácia"

  input {
    int id {
      table = "produtos"
    }
    int categoria_id? {
      table = "categorias"
    }
    text nome? filters=trim
    text descricao? filters=trim
    decimal preco? filters=min:0
    int estoque? filters=min:0
    bool ativo?
  }

  stack {
    var $updates {
      value = {}
    }

    conditional {
      if ($input.categoria_id != null) {
        var.update $updates { value = $updates|set:"categoria_id":$input.categoria_id }
      }
    }

    conditional {
      if ($input.nome != null) {
        var.update $updates { value = $updates|set:"nome":$input.nome }
      }
    }

    conditional {
      if ($input.descricao != null) {
        var.update $updates { value = $updates|set:"descricao":$input.descricao }
      }
    }

    conditional {
      if ($input.preco != null) {
        var.update $updates { value = $updates|set:"preco":$input.preco }
      }
    }

    conditional {
      if ($input.estoque != null) {
        var.update $updates { value = $updates|set:"estoque":$input.estoque }
      }
    }

    conditional {
      if ($input.ativo != null) {
        var.update $updates { value = $updates|set:"ativo":$input.ativo }
      }
    }

    db.patch produtos {
      field_name = "id"
      field_value = $input.id
      data = $updates
    } as $produto
  }

  response = $produto
  guid = "DCpSIN8GTbjh4sig15qrf7Aazk8"
}