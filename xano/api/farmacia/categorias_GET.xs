query categorias verb=GET {
  api_group = "Farmácia"

  input {
  }

  stack {
    db.query categorias {
      return = {type: "list"}
    } as $categorias
  }

  response = $categorias
  guid = "ENwQR-vNDqDS_nTNUckTyZOe7Mk"
}