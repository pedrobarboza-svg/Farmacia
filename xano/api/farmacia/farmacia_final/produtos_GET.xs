query "farmacia-final/produtos" verb=GET {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    int categoria_id?
  }

  stack {
    db.query farmacia_final_produtos {
      where = ($db.farmacia_final_produtos.ativo == true) && (($input.categoria_id == null) || ($db.farmacia_final_produtos.categoria_id == $input.categoria_id))
      sort = {nome: "asc"}
      return = {type: "list"}
    } as $produtos
  }

  response = $produtos
  guid = "iw0Sq0dlWbClRnYG2xSnpEX4O4Q"
}
