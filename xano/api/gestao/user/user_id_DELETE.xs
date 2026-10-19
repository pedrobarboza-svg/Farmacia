// Delete user record
query "user/{user_id}" verb=DELETE {
  api_group = "Gestão"

  input {
    int user_id? filters=min:1
  }

  stack {
    db.del user {
      field_name = "id"
      field_value = $input.user_id
    }
  }

  response = null
  guid = "58KLXY6tS8a3C6tmbyl-IHlolBk"
}