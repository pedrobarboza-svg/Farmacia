query toknzcartao verb=POST {
  api_group = "Asaas"
  auth = "user"

  input {
    text creditCardHolderName filters=trim
    text creditCardNumber filters=trim
    text creditCardExpiryMonth filters=trim
    text creditCardExpiryYear filters=trim
    text creditCardCcv filters=trim
  }

  stack {
    db.get tokens {
      field_name = "Plataforma"
      field_value = "Asaas"
    } as $tokens_asaas
  
    db.get CLIENTE {
      field_name = "user_id"
      field_value = `$auth.id`
    } as $cliente_logado
  
    db.get STATUS_TTOKENIZACAO {
      field_name = "status"
      field_value = "Finalizada"
    } as $STATUS_TTOKENIZACAO_finalizada
  
    db.query TTOKENIZACAO {
      where = $db.TTOKENIZACAO.det_cartao_encript == $input.creditCardNumber && $db.TTOKENIZACAO.cliente_id == $cliente_logado.id && $db.TTOKENIZACAO.status_ttokenizacao_id == $STATUS_TTOKENIZACAO_finalizada.id
      return = {type: "single"}
    } as $cartao_adicionado
  
    precondition ($cartao_adicionado == null) {
      error_type = "accessdenied"
      error = "Cartão já adicionado para este usuário"
    }
  
    db.get STATUS_TTOKENIZACAO {
      field_name = "status"
      field_value = "Criada"
    } as $STATUS_TTOKENIZACAO_criada
  
    // Cria o registro de que a transação de tokenização foi criada
    db.add TTOKENIZACAO {
      data = {
        created_at            : "now"
        cliente_id            : $cliente_logado.id
        det_cartao_encript    : $input.creditCardNumber
        status_ttokenizacao_id: `$STATUS_TTOKENIZACAO_criada.id`
      }
    } as $transacao_tokenizacao
  
    // Chama API do Assas
    api.request {
      url = "https://api-sandbox.asaas.com/v3/creditCard/tokenizeCreditCard"
      method = "POST"
      params = {
        creditCard: {
          "holderName": $input.creditCardHolderName,
          "number": $input.creditCardNumber,
          "expiryMonth": $input.creditCardExpiryMonth,
          "expiryYear": $input.creditCardExpiryYear,
          "ccv": $input.creditCardCcv
        }
        customer  : $cliente_logado.customer_id
      }
    
      headers = []
        |push:"User-Agent: XanoApp/1.0"
        |push:"Accept: application/json"
        |push:$tokens_asaas.token
        |push:"Content-Type: application/json"
      verify_host = false
      verify_peer = false
    } as $tokenizacao
  
    conditional {
      if (`$var.tokenizacao.response.status` == 200) {
        db.get STATUS_TTOKENIZACAO {
          field_name = "status"
          field_value = "Finalizada"
        } as $STATUS_TTOKENIZACAO_final
      
        db.patch TTOKENIZACAO {
          field_name = "id"
          field_value = $transacao_tokenizacao.id
          data = {}
            |set:"status_ttokenizacao_id":$STATUS_TTOKENIZACAO_final.id
            |set:"token":$tokenizacao.response.result.creditCardToken
        } as $TTOKENIZACAO
      }
    
      else {
        db.get STATUS_TTOKENIZACAO {
          field_name = "status"
          field_value = "Cancelada"
        } as $STATUS_TTOKENIZACAO_final
      
        db.patch TTOKENIZACAO {
          field_name = "id"
          field_value = $transacao_tokenizacao.id
          data = {}
            |set:"status_ttokenizacao_id":$STATUS_TTOKENIZACAO_final.id
        } as $TTOKENIZACAO
      }
    }
  
    db.get TTOKENIZACAO {
      field_name = "id"
      field_value = $transacao_tokenizacao.id
    } as $resultado_tokenizacao
  
    precondition (`$var.tokenizacao.response.status` == 200) {
      error = "Cartão não adicionado. Tente novamente!"
      payload = $resultado_tokenizacao
    }
  }

  response = $resultado_tokenizacao
  guid = "vTXa0PCIftQYhxSY7FF9ruzQ0ho"
}