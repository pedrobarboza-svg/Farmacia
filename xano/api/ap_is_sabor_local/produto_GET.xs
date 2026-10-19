// Query all PRODUTO records
query produto verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query PRODUTO {
      return = {type: "list"}
    } as $produto
  }

  response = $produto
  guid = "J7ddp6UFrnKfojwmWC6y4vOU3Kc"
}