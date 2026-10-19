// Query all CARRINHO records
query carrinho verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query CARRINHO {
      return = {type: "list"}
      addon = [
        {
          name : "PRODUTO"
          input: {PRODUTO_id: $output.produto_id}
          as   : "_produto"
        }
      ]
    } as $carrinho
  }

  response = $carrinho
  guid = "vZLa7S0PLmTA2xiSlyON3MDTU3o"
}