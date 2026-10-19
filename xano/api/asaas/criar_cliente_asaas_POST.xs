query criar_cliente_asaas verb=POST {
  api_group = "Asaas"
  auth = "user"

  input {
  }

  stack {
    db.get CLIENTE {
      field_name = "user_id"
      field_value = $auth.id
    } as $cliente_atual
  
    db.get tokens {
      field_name = "Plataforma"
      field_value = "Asaas"
    } as $token_asaas
  
    api.request {
      url = "https://sandbox.asaas.com/api/v3/customers"
      method = "GET"
      params = {}|set:"cpfCnpj":$cliente_atual.cpf
      headers = []
        |push:"Content-Type: application/json"
        |push:$token_asaas.token
        |push:"User-Agent: XanoApp/1.0"
        |push:"Accept: application/json"
    } as $ja_cadastrado
  
    conditional {
      if ($ja_cadastrado.response.result.data == []) {
        db.get user {
          field_name = "id"
          field_value = $auth.id
        } as $usuario_atual
      
        api.request {
          url = "https://api-sandbox.asaas.com/v3/customers"
          method = "POST"
          params = {name: $usuario_atual.name, cpfCnpj: $cliente_atual.cpf}
          headers = []
            |push:"User-Agent: XanoApp/1.0)"
            |push:"Accept: application/json"
            |push:$token_asaas.token
            |push:"Content-Type: application/json"
        } as $cadastra_asaas
      
        conditional {
          if ($cadastra_asaas.response.status == 200) {
            var $customer_id {
              value = `$var.cadastra_asaas.response.result.id`
            }
          
            var $status {
              value = {status: true, mensagem: "Cliente cadastrado no Assas"}
            }
          }
        
          else {
            var $status {
              value = {
                status  : false
                mensagem: "Cliente não pôde ser cadastrado no Assas"
              }
            }
          }
        }
      }
    
      else {
        var $customer_id {
          value = `$ja_cadastrado.response.result.data.0.id`
        }
      
        var $status {
          value = {
            status  : true
            mensagem: "Cliente já cadastrado no Assas"
          }
        }
      }
    }
  
    precondition ($status.status) {
      error_type = "badrequest"
      error = $status.mensagem
    }
  
    db.get STATUS_TTOKENIZACAO {
      field_name = "status"
      field_value = "Criada"
    } as $STATUS_TTOKENIZACAO1
  
    db.edit CLIENTE {
      field_name = "id"
      field_value = $cliente_atual.id
      enforce_hidden_fields = false
      data = {customer_id: $customer_id}
    } as $cliente_atualizado
  
    db.get STATUS_TTOKENIZACAO {
      field_name = "status"
      field_value = "Criada"
    } as $STATUS_TTOKENIZACAO2
  
    db.add TTOKENIZACAO {
      enforce_hidden_fields = false
      data = {
        cliente_id            : $cliente_atual.id
        status_ttokenizacao_id: $STATUS_TTOKENIZACAO1
      }
    } as $TTOKENIZACAO1
  
    db.add CARTAOTOKNZD {
      enforce_hidden_fields = false
      data = {
        cliente_id        : $cliente_atual.id
        codigoclienteasaas: $customer_id
      }
    } as $CARTAOTOKNZD1
  }

  response = {status: $status}
  guid = "nn0Xw7RGBNp6lFtvJDJpekiOAmQ"
}