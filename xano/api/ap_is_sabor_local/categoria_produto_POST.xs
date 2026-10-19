// Add Categoria_Produto record
query categoria_produto verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "Categoria_Produto"
    }
  }

  stack {
    db.add Categoria_Produto {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $categoria_produto
  }

  response = $categoria_produto
  guid = "fhhIVSghLoSqvNNF6-ZnY0QT4aA"
}