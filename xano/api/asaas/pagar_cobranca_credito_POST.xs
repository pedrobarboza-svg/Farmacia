query pagar_cobranca_credito verb=POST {
  api_group = "Asaas"
  auth = "user"

  input {
    text cartao_tokenizado? filters=trim
    text id_pedido? filters=trim
  }

  stack {
    // Pega o token do Asaas
    db.get tokens {
      field_name = "Plataforma"
      field_value = "Asaas"
    } as $token_asaas
  
    // Pega o cliente logado
    db.get CLIENTE {
      field_name = "user_id"
      field_value = $auth.id
    } as $cliente_logado
  
    // Pega as informações do pedido a ser cobrado
    db.get PEDIDO {
      field_name = "id"
      field_value = $input.id_pedido
    } as $pedido_atual
  
    // Pega da transação de cobrança
    db.get TRANSACAO {
      field_name = "id"
      field_value = $pedido_atual.transacao_id
    } as $transacao_cobranca
  
    // Pega status indicando início transação de pagamento
    db.get STATUS_TRANSACAO {
      field_name = "status"
      field_value = "Pagamento Iniciado"
    } as $STATUS_TRANSACAO_pagamento_iniciado
  
    // Log início de transação de pagamento
    db.add TRANSACAO {
      data = {
        created_at        : "now"
        clienteassas      : $transacao_cobranca.clienteassas
        idpayment         : $transacao_cobranca.idpayment
        tipo              : $transacao_cobranca.tipo
        valor             : $transacao_cobranca.valor
        datavenc          : $transacao_cobranca.datavenc
        descricao         : $transacao_cobranca.descricao
        statustransacao_id: $STATUS_TRANSACAO_pagamento_iniciado.id
      }
    } as $transacao_pagamento_iniciado
  
    // Deixa status de erro de transação de pagamento como padrão.
    db.get STATUS_TRANSACAO {
      field_name = "status"
      field_value = "Erro no Pagamento da Cobrança"
    } as $STATUS_TRANSACAO_final
  
    conditional {
      if (`$var.transacao_cobranca` == null) {
        var $resultado {
          value = {
            code       : "invalid_action"
            description: "Código de pagamento inexistente!"
          }
        }
      }
    
      elseif (`$var.transacao_cobranca.clienteassas` != `$var.cliente_logado.customer_id`) {
        var $resultado {
          value = {
            code       : "invalid_action"
            description: "Cliente logado não possui esse Código de Pagamento!"
          }
        }
      }
    
      else {
        api.request {
          url = "https://api-sandbox.asaas.com/v3/payments/"~$var.transacao_cobranca.idpayment~"/payWithCreditCard"
          method = "POST"
          params = {}
            |set:"creditCardToken":$input.cartao_tokenizado
          headers = []
            |push:"User-Agent: XanoApp/1.0"
            |push:"accept: application/json"
            |push:`$var.token_asaas.token`
            |push:"content-type: application/json"
          verify_host = false
          verify_peer = false
        } as $pagamento
      
        conditional {
          if (`$var.pagamento.response.status` != 200) {
            var $resultado {
              value = {
                code       : "invalid_action"
                description: $pagamento.response.result.errors
              }
            }
          }
        
          else {
            // Pega status indicando sucesso na transação de pagamento
            db.get STATUS_TRANSACAO {
              field_name = "status"
              field_value = "Sucesso no Pagamento da Cobrança"
            } as $STATUS_TRANSACAO_final
          
            var $resultado {
              value = {
                code       : "ok_action"
                description: "Pagamento realizado com sucesso."
              }
            }
          
            // Pega status indicando pagamento bem sucedido
            db.get STATUS_PEDIDO {
              field_name = "status"
              field_value = "Pago"
            } as $STATUS_PEDIDO_pago
          
            // Atualiza o status do pedido para pago
            db.edit PEDIDO {
              field_name = "id"
              field_value = $input.id_pedido
              data = {status_pedido_id: $STATUS_PEDIDO_pago.id}
            } as $pedido_atualizado
          }
        }
      }
    }
  
    // Log  transação de pagamento
    db.add TRANSACAO {
      data = {
        created_at         : "now"
        clienteassas       : $transacao_cobranca.clienteassas
        idpayment          : $transacao_cobranca.idpayment
        tipo               : $transacao_cobranca.tipo
        valor              : $transacao_cobranca.valor
        datavenc           : $transacao_cobranca.datavenc
        descricao          : $transacao_cobranca.descricao
        status_transacao_id: $STATUS_TRANSACAO_final.id
      }
    } as $transacao_final
  
    precondition ($resultado.code == "ok_action") {
      error = "Pagamento não realizado"
      payload = $resultado.description
    }
  }

  response = {resultado: $resultado}
  guid = "HqsNL_JN88NPxugb8zMFxrH5wMg"
}