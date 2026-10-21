query "farmacia-final/auth/login" verb=POST {
  api_group = "Farmácia"

  input {
    email email filters=trim|lower
    text senha
  }

  stack {
    db.get farmacia_final_funcionario {
      field_name = "email"
      field_value = $input.email
    } as $funcionario

    precondition (($funcionario != null) && ($funcionario.ativo == true)) {
      error_type = "accessdenied"
      error = "Credenciais inválidas."
    }

    security.check_password {
      text_password = $input.senha
      hash_password = $funcionario.senha_hash
    } as $senha_valida

    precondition ($senha_valida) {
      error_type = "accessdenied"
      error = "Credenciais inválidas."
    }

    security.create_auth_token {
      table = "farmacia_final_funcionario"
      extras = {}
      expiration = 86400
      id = $funcionario.id
    } as $authToken
  }

  response = {
    authToken: $authToken
    funcionario: {
      id: $funcionario.id
      nome: $funcionario.nome
      email: $funcionario.email
    }
  }
  guid = "BhnVZnSHHjtUISvyeRKtFFmwnoo"
}
