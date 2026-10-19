// Query all CARRINHO records
query carrinho verb=GET {
  api_group = "AuthSaborLocal"

  input {
  }

  stack {
    db.query "" {
      return = {type: "list"}
    } as $carrinho
  }

  response = $carrinho
  guid = "ZzMzcWTVb8fls9Abgp3OrPuCRlc"
}