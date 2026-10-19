// Get Categoria_Produto record
query "categoria_produto/{categoria_produto_id}" verb=GET {
  api_group = "APIs SaborLocal"

  input {
    int categoria_produto_id? filters=min:1
  }

  stack {
    db.get Categoria_Produto {
      field_name = "id"
      field_value = $input.categoria_produto_id
    } as $categoria_produto
  
    precondition ($categoria_produto != null) {
      error_type = "notfound"
      error = "Not Found."
    }
  }

  response = $categoria_produto
  guid = "eftXBcZUQHAphdrX_8a-TSq7BgA"
}