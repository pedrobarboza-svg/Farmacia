// Edit user record
query "user/{user_id}" verb=PATCH {
  api_group = "Gestão"

  input {
    int user_id? filters=min:1
    dblink {
      table = "user"
    }
  }

  stack {
    util.get_raw_input {
      encoding = "json"
      exclude_middleware = false
    } as $raw_input
  
    db.patch user {
      field_name = "id"
      field_value = $input.user_id
      data = `$input|pick:($raw_input|keys)`|filter_null|filter_empty_text
      addon = [
        {
          name : "PAPEL"
          input: {PAPEL_id: $output.papel_id}
          as   : "_papel"
        }
      ]
    } as $model
  }

  response = $model
  guid = "2Oe4KZXcGEHNNNCmtA71I8zBDrk"
}