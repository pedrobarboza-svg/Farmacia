// Realizar o cadastro de um novo login
// Devolve um Token de acesso
query "auth/signup" verb=POST {
  api_group = "AuthSaborLocal"

  input {
    text name?
    email email? filters=lower|trim
    password password?
    text celular? filters=trim
    text cpf? filters=trim
  }

  stack {
    db.get user {
      field_name = "cpf"
      field_value = $input.cpf
    } as $user
  
    precondition ($user == null) {
      error_type = "accessdenied"
      error = "This account is already in use."
    }
  
    security.random_number {
      min = 100000
      max = 999999
    } as $codigo_otp
  
    var $expiracao {
      value = now|add_secs_to_timestamp:300
    }
  
    db.add user {
      enforce_hidden_fields = false
      data = {
        created_at   : "now"
        name         : $input.name
        email        : $input.email
        password     : $input.password
        celular      : $input.celular
        cpf          : $input.cpf
        codigo_otp   : $codigo_otp
        expiracao_otp: $expiracao
      }
    } as $user
  
    security.create_auth_token {
      table = "user"
      extras = {}
      expiration = 86400
      id = $user.id
    } as $authToken
  
    db.add CLIENTE {
      enforce_hidden_fields = false
      data = {
        cpf              : $input.cpf
        celular          : $input.celular
        status_cliente_id: 1
        user_id          : $user.id
      }
    } as $CLIENTE1
  
    function.run sendgrid_basic_send {
      input = {
        to_email: $user.email
        subject : "Codigo Sabor Local"
        body    : $codigo_otp
      }
    } as $func1
  }

  response = {authToken: $authToken}
  guid = "xiJnuAIWvFETkX1ySGMtUdGmFlU"
}