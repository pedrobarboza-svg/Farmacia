// Edit ENDERECO record
query "endereco/{endereco_id}" verb=PATCH {
  api_group = "APIs SaborLocal"

  input {
    int endereco_id? filters=min:1
    dblink {
      table = "ENDERECO"
    }
  }

  stack {
    util.get_raw_input {
      encoding = "json"
      exclude_middleware = false
    } as $raw_input
  
    db.patch ENDERECO {
      field_name = "id"
      field_value = $input.endereco_id
      data = `$input|pick:($raw_input|keys)`|filter_null|filter_empty_text
    } as $endereco
  }

  response = $endereco
  guid = "nmAgZ3_3QWMXm-diJY0SXVaEvuo"
}