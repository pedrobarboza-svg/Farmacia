// consulta cliente
query cliente verb=GET {
  api_group = "AuthSaborLocal"
  auth = "user"

  input {
  }

  stack {
    db.get CLIENTE {
      field_name = "user_id"
      field_value = $auth.id
    } as $CLIENTE
  }

  response = $CLIENTE
  tags = ["consultacliente"]
  guid = "D6uKqI5AU9eDZa2kbn8tmeYDIzo"
}