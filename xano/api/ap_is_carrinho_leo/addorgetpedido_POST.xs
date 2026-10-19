// Add New OR Get Exist PEDIDO record
query addorgetpedido verb=POST {
  api_group = "APIs Carrinho Leo"
  auth = "user"

  input {
  }

  stack {
    db.get CLIENTE {
      field_name = "user_id"
      field_value = $auth.id
    } as $cliente_logado
  
    db.get STATUS_PEDIDO {
      field_name = "status"
      field_value = "Criado"
    } as $STATUS_PEDIDO_Criado
  
    db.query PEDIDO {
      where = $db.PEDIDO.cliente_id == $cliente_logado.id && $db.PEDIDO.status_pedido_id == $STATUS_PEDIDO_Criado.id
      return = {type: "single"}
    } as $pedido_aberto
  
    conditional {
      if ($pedido_aberto == null) {
        db.add PEDIDO {
          enforce_hidden_fields = false
          data = {
            created_at      : "now"
            total           : 0
            nfc_e           : null
            cod_entrega     : null
            cliente_id      : $cliente_logado.id
            status_pedido_id: $STATUS_PEDIDO_Criado.id
          }
        } as $pedido_aberto
      }
    }
  }

  response = $pedido_aberto
  tags = ["pedido"]
  guid = "SbFQrMgb3ykzsmfn82JMj6B4KF8"
}