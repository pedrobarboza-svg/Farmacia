query "farmacia-final/categorias" verb=GET {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {}

  stack {
    db.query farmacia_final_categorias {
      where = $db.farmacia_final_categorias.ativo == true
      sort = {nome: "asc"}
      return = {type: "list"}
    } as $categorias
  }

  response = $categorias
  guid = "C8iXbbeCXoAkOxOtQ4s4bsgchSE"
}
