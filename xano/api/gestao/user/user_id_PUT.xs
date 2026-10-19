// Update user record
query "user/{user_id}" verb=PUT {
  api_group = "Gestão"

  input {
    int user_id? filters=min:1
    dblink {
      table = "user"
    }
  }

  stack {
    db.edit user {
      field_name = "id"
      field_value = $input.user_id
      enforce_hidden_fields = false
      data = {
        name         : $input.name
        email        : $input.email
        papel_id     : $input.papel_id
        celular      : $input.celular
        cpf          : $input.cpf
        codigo_otp   : $input.codigo_otp
        expiracao_otp: $input.expiracao_otp
      }
    } as $model
  }

  response = $model
  guid = "vdQ512EPbACgbDwLBOwUVeehOxc"
}