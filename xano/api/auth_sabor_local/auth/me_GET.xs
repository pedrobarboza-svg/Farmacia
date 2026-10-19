// Dado um Token de acesso
// Devolve os dados do usuário
query "auth/me" verb=GET {
  api_group = "AuthSaborLocal"
  auth = "user"

  input {
  }

  stack {
    db.get user {
      field_name = "id"
      field_value = $auth.id
    } as $user
  }

  response = $user
  guid = "7qcnO-40jAea-AMnOvWjErkX9hY"
}