// Validação do código
query validar_codigo verb=POST {
  api_group = "AuthSaborLocal"

  input {
    text email? filters=trim
    text codigo_digitado? filters=trim
  }

  stack {
    db.get user {
      field_name = "email"
      field_value = $input.email
    } as $user1
  
    precondition ($user1.codigo_otp == ($input.codigo_digitado|to_int)) {
      error = "Código Inválido!"
    }
  }

  response = $user1
  guid = "dicGkSZOHAB_wEJbSJsI8jcFKFg"
}