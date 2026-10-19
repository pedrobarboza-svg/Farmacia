// Edit CARRINHO record
query "carrinho/{carrinho_id}" verb=PATCH {
  api_group = "AuthSaborLocal"

  input {
    int carrinho_id? filters=min:1
    dblink {
      table = ""
    }
  }

  stack {
    util.get_raw_input {
      encoding = "json"
      exclude_middleware = false
    } as $raw_input
  
    db.patch "" {
      field_name = "id"
      field_value = $input.carrinho_id
      data = `$input|pick:($raw_input|keys)`|filter_null|filter_empty_text
    } as $carrinho
  }

  response = $carrinho
  guid = "Prg4M3OpKtH7yNUXUXYKdSlF820"
}