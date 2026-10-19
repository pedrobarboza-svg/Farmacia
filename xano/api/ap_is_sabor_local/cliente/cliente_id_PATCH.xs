// Edit CLIENTE record
query "cliente/{cliente_id}" verb=PATCH {
  api_group = "APIs SaborLocal"

  input {
    int cliente_id? filters=min:1
  }

  stack {
    util.get_raw_input {
      encoding = "json"
      exclude_middleware = false
    } as $raw_input
  
    db.patch "" {
      field_name = "id"
      field_value = $input.cliente_id
      data = `$input|pick:($raw_input|keys)`|filter_null|filter_empty_text
    } as $cliente
  }

  response = $cliente
  guid = "7o1WVBZf4n2Pe1pCVY717OPbHLU"
}