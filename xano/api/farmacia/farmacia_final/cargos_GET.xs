query "farmacia-final/cargos" verb=GET {
  api_group = "Farmácia"

  input {}

  stack {
    db.query farmacia_final_cargo {
      where = $db.farmacia_final_cargo.ativo == true
      sort = {nome: "asc"}
      return = {type: "list"}
    } as $cargos
  }

  response = {
    cargos: $cargos|map:{id: $$.id, nome: $$.nome}
  }
  guid = "CXSNaUey39FHdIZe8wKMIv3xzdE"
}
