// Add ENDERECO record
query endereco verb=POST {
  api_group = "AuthSaborLocal"

  input {
    dblink {
      table = "ENDERECO"
    }
  }

  stack {
    db.add ENDERECO {
      enforce_hidden_fields = false
      data = {
        created_at : "now"
        cliente_id : $auth.id
        logradouro : $input.logradouro
        numero     : $input.numero
        complemento: $input.complemento
        bairro     : $input.bairro
        referencia : $input.referencia
        padrao     : $input.padrao
        cep_id     : $input.cep_id
      }
    } as $model
  }

  response = $model
  tags = ["endereco criar"]
  guid = "4CrQIAklmALPrkRRJvSY81kXH2c"
}