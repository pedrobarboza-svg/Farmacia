query produtos verb=POST {
  api_group = "Farmácia"

  input {
    int categoria_id
    text nome
    text descricao?
    decimal preco
    int estoque?
    bool ativo?
  }

  stack {
    db.add produtos {
      data = {
        categoria_id: $input.categoria_id
        nome        : $input.nome
        descricao   : $input.descricao
        preco       : $input.preco
        estoque     : $input.estoque ?? 0
        ativo       : $input.ativo ?? true
      }
    } as $produto
  }

  response = $produto
  guid = "Vov5PiVxklPVh7odom4m_XZEdGM"
}