query criar_cliente_assas verb=POST {
  api_group = "pedido_aberto_backend"
  auth = "user"

  input {
  }

  stack {
    db.get CLIENTE {
      field_name = "id"
      field_value = $auth.id
    } as $cliente_atual
  
    db.get tokens {
      field_name = "id"
      field_value = $cliente_atual
    } as $token_asaas
  
    api.request {
      url = ""
      method = "GET"
    } as $api1
  }

  response = $cliente_atual
  guid = "6G7NSnFwKwvMDQdKInQ6csvVBh4"
}