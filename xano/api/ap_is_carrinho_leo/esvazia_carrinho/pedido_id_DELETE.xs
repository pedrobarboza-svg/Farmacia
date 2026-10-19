// Exclui todos os itens associados ao pedido_id
query "esvazia_carrinho/{pedido_id}" verb=DELETE {
  api_group = "APIs Carrinho Leo"

  input {
    // ID do pedido (carrinho) a ser esvaziado
    int pedido_id
  }

  stack {
    db.bulk.delete ITEM {
      where = $db.ITEM.pedido_id == $input.pedido_id
    } as $ITEM1
  
    db.patch PEDIDO {
      field_name = "id"
      field_value = $input.pedido_id
      data = {total: 0}
    } as $PEDIDO2
  
    db.query ITEM {
      where = $db.ITEM.pedido_id == $input.pedido_id
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
  guid = "oay6cXjP_xKnrhh66X7xryjkmXo"
}