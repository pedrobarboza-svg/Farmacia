// Add user record
query user verb=POST {
  api_group = "Sendgrid Validation"

  input {
    text email? filters=trim
  }

  stack {
    db.get user {
      field_name = "email"
      field_value = $input.email
    } as $user1
  
    security.random_number {
      min = 100000
      max = 999999
    } as $codigo_otp
  
    var $expiracao {
      value = now|add_secs_to_timestamp:300
    }
  
    db.edit user {
      field_name = "id"
      field_value = $user1.id
      enforce_hidden_fields = false
      data = {
        id           : $user1.id
        codigo_otp   : $codigo_otp
        expiracao_otp: $expiracao
      }
    } as $user2
  
    function.run sendgrid_basic_send {
      input = {
        to_email: $user1.email
        subject : "Codigo Sabor Local"
        body    : $codigo_otp
      }
    } as $func1
  }

  response = $user2
  guid = "30Jokcd-9IZqESLXL3juyk5eJUs"
}