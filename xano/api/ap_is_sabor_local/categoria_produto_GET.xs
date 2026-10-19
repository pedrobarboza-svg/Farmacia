// Query all Categoria_Produto records
query categoria_produto verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query Categoria_Produto {
      return = {type: "list"}
    } as $categoria_produto
  }

  response = $categoria_produto
  guid = "5rhYuEHMzQWIB1cMK1jOz2PLDf4"
}