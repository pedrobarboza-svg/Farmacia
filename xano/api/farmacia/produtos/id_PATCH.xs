query "produtos/{id}" verb=PATCH {
  api_group = "Farmácia"

  input {
    int id
    int categoria_id?
    text nome?
    text descricao?
    decimal preco?
    int estoque?
    bool ativo?
  }

  stack {
    db.edit produtos {
      field_name = "id"
      field_value = $input.id
      data = {
        categoria_id: $input.categoria_id
        nome        : $input.nome
        descricao   : $input.descricao
        preco       : $input.preco
        estoque     : $input.estoque
        ativo       : $input.ativo
      }
    } as $produto
  }

  response = $produto
  guid = "DCpSIN8GTbjh4sig15qrf7Aazk8"
}