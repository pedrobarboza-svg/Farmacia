query cliente verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.get CLIENTE {
      field_name = "user_id"
      field_value = $auth.id
    } as $CLIENTE1
  }

  response = $CLIENTE1
  guid = "gnYAl7tGgGqo15Ss55UFaiDB5sc"
}