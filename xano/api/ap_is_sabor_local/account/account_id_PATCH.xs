// Edit account record
query "account/{account_id}" verb=PATCH {
  api_group = "APIs SaborLocal"

  input {
    int account_id? filters=min:1
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
      field_value = $input.account_id
      data = `$input|pick:($raw_input|keys)`|filter_null|filter_empty_text
    } as $account
  }

  response = $account
  guid = "oH3LSx63z0OFfcYVdGhKeNI8n2Q"
}