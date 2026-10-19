query produtos verb=GET {
  api_group = "Farmácia"

  input {
    int categoria_id?
    bool ativo?
  }

  stack {
    db.query produtos {
      where = ($input.categoria_id == null || $db.produtos.categoria_id == $input.categoria_id) && ($input.ativo == null || $db.produtos.ativo == $input.ativo)
      return = {type: "list"}
    } as $produtos
  }

  response = $produtos
  guid = "Szaqsa9-bBgS4qwpMu7P_rQGBVE"
}