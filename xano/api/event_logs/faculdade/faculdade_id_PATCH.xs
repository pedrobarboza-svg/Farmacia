// Edit faculdade record
query "faculdade/{faculdade_id}" verb=PATCH {
  api_group = "Event Logs"

  input {
    int faculdade_id? filters=min:1
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
      field_value = $input.faculdade_id
      data = `$input|pick:($raw_input|keys)`|filter_null|filter_empty_text
    } as $faculdade
  }

  response = $faculdade
  guid = "vqZZk-NcohSU7NI4Cx-fszU1eok"
}