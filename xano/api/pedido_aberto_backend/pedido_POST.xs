// Add PEDIDO record
query pedido verb=POST {
  api_group = "pedido_aberto_backend"

  input {
    dblink {
      table = "PEDIDO"
      override = {
        nfc_e      : {hidden: true}
        total      : {hidden: true}
        cod_entrega: {hidden: true}
      }
    }
  }

  stack {
    db.get CLIENTE {
      field_name = $input.cliente_id
      field_value = ""
    } as $cliente_logado
  
    db.get STATUS_PEDIDO {
      field_name = $input.status_pedido_id
      field_value = ""
    } as $STATUS_PEDIDO_CRIADO
  
    db.query PEDIDO {
      where = $input.cliente_id == $cliente_logado.id && $input.status_pedido_id == $STATUS_PEDIDO_CRIADO.id
      return = {type: "list"}
    } as $pedido_aberto
  
    conditional {
      if ($pedido_aberto == null) {
        db.add PEDIDO {
          enforce_hidden_fields = false
          data = {}
        } as $pedido_aberto
      }
    }
  }

  response = $pedido_aberto
  guid = "nhZYyWxxMo4JwHeOMNFzDsB-jnU"
}