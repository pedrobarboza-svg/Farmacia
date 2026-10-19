query produtos verb=GET {
  api_group = "Farmácia"

  input {
    int categoria_id? {
      table = "categorias"
    }
  }

  stack {
    db.query produtos {
      where = $db.produtos.ativo == true && ($input.categoria_id == null || $db.produtos.categoria_id == $input.categoria_id)
      eval = {
        disponivel: $db.produtos.estoque > 0
      }
      return = {type: "list"}
    } as $produtos
  }

  response = $produtos
  guid = "Szaqsa9-bBgS4qwpMu7P_rQGBVE"
}