// Get CARRINHO record
query "carrinho/{carrinho_id}" verb=GET {
  api_group = "APIs SaborLocal"

  input {
    int carrinho_id? filters=min:1
  }

  stack {
    db.get CARRINHO {
      field_name = "id"
      field_value = $input.carrinho_id
    } as $carrinho
  
    precondition ($carrinho != null) {
      error_type = "notfound"
      error = "Not Found."
    }
  }

  response = $carrinho
  guid = "uRCK1xMWp1gZlCbqelFXYtLgiD4"
}