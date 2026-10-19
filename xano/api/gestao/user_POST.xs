// Add user record
query user verb=POST {
  api_group = "Gestão"

  input {
    dblink {
      table = "user"
      override = {password: {hidden: false, required: true}}
    }
  }

  stack {
    db.add user {
      enforce_hidden_fields = false
      data = {
        created_at   : "now"
        name         : $input.name
        email        : $input.email
        password     : $input.password
        papel_id     : $input.papel_id
        celular      : $input.celular
        cpf          : $input.cpf
        codigo_otp   : $input.codigo_otp
        expiracao_otp: $input.expiracao_otp
      }
    } as $model
  }

  response = $model
  guid = "CFvVbdpG8M_YNZwXmfIW-EzpOJI"
}