// Recupera os itens do pedido aberto
query recupera_carrinho_auth verb=GET {
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
    } as $PEDIDO_aberto
  
    db.query ITEM {
      where = $db.ITEM.pedido_id == $PEDIDO_aberto.id
      return = {type: "list"}
      addon = [
        {
          name : "PRODUTO"
          input: {PRODUTO_id: $output.produto_id}
          as   : "_produto"
        }
      ]
    } as $carrinho_atualizado
  }

  response = $carrinho_atualizado
  guid = "1qFyrqtGtGmT5AKY1GfXWIT4CZg"
}