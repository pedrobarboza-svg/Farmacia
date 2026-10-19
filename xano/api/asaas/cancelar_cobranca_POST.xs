query cancelar_cobranca verb=POST {
  api_group = "Asaas"
  auth = "user"

  input {
    int id_pedido?
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
  
    db.get PEDIDO {
      field_name = "id"
      field_value = $input.id_pedido
    } as $PEDIDO_atual
  
    db.get TRANSACAO {
      field_name = "id"
      field_value = $PEDIDO_atual.transacao_id
    } as $transacao_cobranca
  
    api.request {
      url = "https://api-sandbox.asaas.com/v3/payments/"~$var.transacao_cobranca.idpayment
      method = "DELETE"
      headers = []
        |push:"accept: application/json"
        |push:$token_asaas.token
        |push:"User-Agent: XanoApp/1.0"
    } as $cobranca_cancelada
  
    precondition ($cobranca_cancelada.response.status == 200) {
      error = "Erro ao cancelar a cobrança, tente novamente!"
    }
  
    db.query ITEM {
      where = $db.ITEM.pedido_id == $input.id_pedido
      return = {type: "list"}
    } as $itens_pedido
  
    foreach ($itens_pedido) {
      each as $item {
        db.get PRODUTO {
          field_name = "id"
          field_value = $item.produto_id
        } as $produto
      
        var $nova_qdt {
          value = $var.produto.qtd_disp + $var.item.qtd
        }
      
        db.edit PRODUTO {
          field_name = "id"
          field_value = $item.produto_id
          data = {qtd_disp: $nova_qdt}
        } as $produto_atualizado
      }
    }
  
    db.get STATUS_PEDIDO {
      field_name = "status"
      field_value = "Cancelado por falta de pagamento"
    } as $STATUS_PEDIDO_Cancelado_Falta_Pagamento
  
    db.edit PEDIDO {
      field_name = "id"
      field_value = $input.id_pedido
      data = {
        status_pedido_id: $STATUS_PEDIDO_Cancelado_Falta_Pagamento.id
      }
    } as $pedido_atualizado
  
    db.get STATUS_TRANSACAO {
      field_name = "status"
      field_value = "Erro no Pagamento da Cobrança"
    } as $STATUS_TRANSACAO_Erro_Pagamento
  
    db.add TRANSACAO {
      data = {
        created_at         : "now"
        clienteassas       : $cliente_logado.customer_id
        idpayment          : $transacao_cobranca.idpayment
        tipo               : $transacao_cobranca.tipo
        valor              : $transacao_cobranca.valor
        datavenc           : $transacao_cobranca.datavenc
        descricao          : $transacao_cobranca.descricao
        status_transacao_id: $STATUS_TRANSACAO_Erro_Pagamento.id
      }
    } as $transacao_gerada
  }

  response = $transacao_gerada
  guid = "5A6hZhSb9rz-eVqXlkt7HG8hCWg"
}