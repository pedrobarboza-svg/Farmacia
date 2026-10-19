// Query all ENDERECO records
query endereco verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query ENDERECO {
      return = {type: "list"}
    } as $endereco
  }

  response = $endereco
  guid = "fpNn0nNzTUKacmCwck3EJJoyph0"
}