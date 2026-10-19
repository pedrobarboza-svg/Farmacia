query produtos verb=POST {
  api_group = "Farmácia"

  input {
    int categoria_id {
      table = "categorias"
    }
    text nome filters=trim
    text descricao? filters=trim
    decimal preco filters=min:0
    int estoque filters=min:0
    bool ativo?
  }

  stack {
    db.add produtos {
      data = {
        categoria_id: $input.categoria_id
        nome        : $input.nome
        descricao   : $input.descricao
        preco       : $input.preco
        estoque     : $input.estoque
        ativo       : $input.ativo ?? true
      }
    } as $produto
  }

  response = $produto
  guid = "Vov5PiVxklPVh7odom4m_XZEdGM"
}