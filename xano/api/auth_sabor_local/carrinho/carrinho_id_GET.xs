// Get CARRINHO record
query "carrinho/{carrinho_id}" verb=GET {
  api_group = "AuthSaborLocal"

  input {
    int carrinho_id? filters=min:1
  }

  stack {
    db.get "" {
      field_name = "id"
      field_value = $input.carrinho_id
    } as $carrinho
  
    precondition ($carrinho != null) {
      error_type = "notfound"
      error = "Not Found."
    }
  }

  response = $carrinho
  guid = "BoQBTR0onWKYu8N7gyHxzZ-Vu7s"
}