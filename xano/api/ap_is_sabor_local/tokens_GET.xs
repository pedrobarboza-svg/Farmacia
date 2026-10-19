// Query all tokens records
query tokens verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query tokens {
      return = {type: "list"}
    } as $tokens
  }

  response = $tokens
  guid = "lHUjmNbVj-P8ajbthBN_fSnlKtA"
}