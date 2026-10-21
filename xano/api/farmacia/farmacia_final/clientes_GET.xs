query "farmacia-final/clientes" verb=GET {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {}

  stack {
    db.query farmacia_final_cliente {
      sort = {nome: "asc"}
      return = {type: "list"}
    } as $clientes
  }

  response = $clientes
  guid = "YW25jILwcYeVIG9QXW8sGwCOIFI"
}
