// Add ENDERECO record
query endereco verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "ENDERECO"
    }
  }

  stack {
    db.add ENDERECO {
      enforce_hidden_fields = false
      data = {
        created_at: "now"
        cliente_id: null
        logradouro: $input.logradouro
        numero    : $input.numero
        bairro    : $input.bairro
        cep       : $input.cep
      }
    } as $endereco
  }

  response = $endereco
  guid = "WazbjEjNyccrjSzavkLj6kFpSjA"
}