query criarclienteasaas verb=POST {
  api_group = "Asaas"

  input {
    text authtoken? filters=trim
  }

  stack {
    api.request {
      url = "https://x8ki-letl-twmt.n7.xano.io/api:g0jHHRoP/auth/me"
      method = "GET"
      params = $input.authtoken
      headers = [
        "Authorization: Bearer " ~ $input.authtoken
        "Content-Type: application/json"
      ]
    
    } as $api1
  
    conditional {
      if (`$var.api1.response.result.erro` == false) {
        db.get user {
          field_name = "id"
          field_value = `$var.api1.response.result.cliente.user_id`
        } as $user1
      
        db.get tokens {
          field_name = "Plataforma"
          field_value = "Asaas"
        } as $tokens1
      
        api.request {
          url = `https://api-sandbox.asaas.com/v3/customers`
          method = "POST"
          params = `$var.api1.response.result.cliente.cpf`
          headers = [
            $tokens1.token
            "Content-Type: application/json"
            "Accept: application/json"
            "User-Agent: curl/8.0.1"
          ]
        
        } as $api2
      
        var $codigoclienteasaas {
          value = `$var.api2.response.result.id`
        }
      
        db.get STATUS_TTOKENIZACAO {
          field_name = "status"
          field_value = "Criada"
        } as $STATUS_TTOKENIZACAO1
      
        db.add TTOKENIZACAO {
          enforce_hidden_fields = false
          data = {
            cliente_orig_id       : `$var.api1.response.result.cliente.id`
            status_ttokenizacao_id: `$var.STATUS_TTOKENIZACAO1.id`
          }
        } as $STATUS_TTOKENIZACAO1
      
        db.add CARTAOTOKNZD {
          enforce_hidden_fields = false
          data = {
            cliente_id        : `$var.api1.response.result.cliente.id`
            codigoclienteasaas: `$var.codigoclienteasaas`
          }
        } as $CARTAOTOKNZD1
      
        var $status {
          value = {status: true, mensagem: "Cliente cadastrado no Asaas."}
        }
      }
    
      else {
        var $status {
          value = {
            status  : false
            mensagem: "Cliente não pode ser cadastrado no Asaas."
          }
        }
      }
    }
  }

  response = {status: $status}
  guid = "NocFkHl6v2HygXnDlpR78gEd-bY"
}