// Query all SOLCANCELAMENTO records
query solcancelamento verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query SOLCANCELAMENTO {
      return = {type: "list"}
    } as $solcancelamento
  }

  response = $solcancelamento
  guid = "dS6VUDh0kCF4f5QuC6IGlOJtkkk"
}