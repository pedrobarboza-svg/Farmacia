// Validação do código
query solicitar_codigo verb=POST {
  api_group = "AuthSaborLocal"

  input {
    text email? filters=trim
  }

  stack {
    db.add user {
      enforce_hidden_fields = false
      data = {}
    } as $user1
  }

  response = $user1
  guid = "KkGC1mvb2Y8eLgvrcIL3XRDEFfs"
}