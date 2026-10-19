// Faça login e recupere um token de autenticação.
query "auth/login_Admin" verb=POST {
  api_group = "AuthSaborLocal"

  input {
    email email? filters=trim|lower
    text password?
  }

  stack {
    db.get user {
      field_name = "email"
      field_value = $input.email
      output = ["id", "created_at", "name", "email", "password", "papel_id"]
    } as $user
  
    precondition ($user != null) {
      error = "Invalid Credentials."
    }
  
    security.check_password {
      text_password = $input.password
      hash_password = $user.password
    } as $pass_result
  
    precondition ($pass_result) {
      error = "Invalid Credentials."
    }
  
    precondition ($user.papel_id == 1) {
      error = "Acesso negado. Este sistema é exclusivo para administradores."
    }
  
    security.create_auth_token {
      table = "user"
      extras = {}
      expiration = 86400
      id = $user.id
    } as $authToken
  }

  response = {authToken: $authToken}
  guid = "yHPWHmsCj3GadAuOZJE3Ta2UFko"
}