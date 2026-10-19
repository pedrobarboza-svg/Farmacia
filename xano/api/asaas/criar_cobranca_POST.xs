query criar_cobranca verb=POST {
  api_group = "Asaas"
  auth = "user"

  input {
    text tipo?=CREDIT_CARD filters=trim
    date datavenc
    text descricao?=Pedido filters=trim
  }

  stack {
    db.get tokens {
      field_name = "Plataforma"
      field_value = "Asaas"
    } as $token_asaas
  
    db.get CLIENTE {
      field_name = "user_id"
      field_value = `$auth.id`
    } as $cliente_logado
  
    db.get STATUS_PEDIDO {
      field_name = "status"
      field_value = "Criado"
    } as $STATUS_PEDIDO_Criado
  
    db.query PEDIDO {
      where = $db.PEDIDO.cliente_id == $cliente_logado.id && $db.PEDIDO.status_pedido_id == $STATUS_PEDIDO_Criado.id
      return = {type: "single"}
    } as $pedido_atual
  
    precondition ($pedido_atual != null) {
      error = "Não existe pedido aberto para este cliente."
    }
  
    db.query ITEM {
      where = $db.ITEM.pedido_id == $pedido_atual.id
      return = {type: "list"}
    } as $itens_pedido
  
    foreach ($itens_pedido) {
      each as $item {
        db.get PRODUTO {
          field_name = "id"
          field_value = $item.produto_id
        } as $produto
      
        precondition ($item.qtd <= $produto.qtd_disp) {
          error = "O produto " ~$var.produto.nome~ " acabou."
        }
      }
    }
  
    api.request {
      url = "https://api-sandbox.asaas.com/v3/payments"
      method = "POST"
      params = {}
        |set:"billingType":$input.tipo
        |set:"customer":$cliente_logado.customer_id
        |set:"value":$pedido_atual.total
        |set:"dueDate":$input.datavenc
        |set:"description":$input.descricao
      headers = []
        |push:"User-Agent: XanoApp/1.0"
        |push:"Accept: application/json"
        |push:$token_asaas.token
        |push:"Content-Type: application/json"
      verify_host = false
      verify_peer = false
    } as $geracao_cobranca
  
    conditional {
      // Se deu certo a chamada da API do Assas
      if (`$var.geracao_cobranca.response.status` == 200) {
        db.get STATUS_PEDIDO {
          field_name = "status"
          field_value = "Transação via Cartão Iniciada"
        } as $STATUS_PEDIDO_Transacao_Cartao_Iniciada
      
        db.edit PEDIDO {
          field_name = "id"
          field_value = $pedido_atual.id
          data = {status_pedido_id: $STATUS_PEDIDO_Transacao_Cartao_Iniciada}
        } as $pedido_atualizado
      
        foreach ($itens_pedido) {
          each as $item {
            db.get PRODUTO {
              field_name = "id"
              field_value = $item.produto_id
            } as $produto
          
            var $nova_qdt {
              value = $var.produto.qtd_disp - $var.item.qtd
            }
          
            db.edit PRODUTO {
              field_name = "id"
              field_value = $item.produto_id
              data = {qtd_disp: $nova_qdt}
            } as $produto_atualizado
          }
        }
      
        db.get STATUS_TRANSACAO {
          field_name = "status"
          field_value = "Cobrança Criada"
        } as $status_transacao_final
      }
    
      // Não deu certo
      else {
        db.get STATUS_TRANSACAO {
          field_name = "status"
          field_value = "Erro na Criação da Cobrança"
        } as $status_transacao_final
      }
    }
  
    db.add TRANSACAO {
      data = {
        created_at         : "now"
        clienteassas       : $cliente_logado.customer_id
        idpayment          : `$var.geracao_cobranca.response.result.id`
        tipo               : $input.tipo
        valor              : $pedido_atual.total
        datavenc           : $input.datavenc
        descricao          : $input.descricao
        status_transacao_id: $status_transacao_final.id
      }
    } as $transacao_gerada
  
    precondition ($status_transacao_final.status == "Cobrança Criada") {
      error_type = "badrequest"
      error = "Erro na criação da cobrança"
      payload = $geracao_cobranca
    }
  
    db.edit PEDIDO {
      field_name = "id"
      field_value = $pedido_atual.id
      data = {transacao_id: $transacao_gerada.id}
    } as $PEDIDO1
  }

  response = $transacao_gerada
  guid = "NQhNNq0-XxJetHurIhQWkobLAus"
}