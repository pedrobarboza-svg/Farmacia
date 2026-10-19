// Delete ITEM record.
query "delete_item/{item_id}" verb=DELETE {
  api_group = "APIs Carrinho Leo"

  input {
    int item_id? filters=min:1
  }

  stack {
    db.get ITEM {
      field_name = "id"
      field_value = $input.item_id
    } as $item_atual
  
    var $subtotal_do_item {
      value = `$var.item_atual.subtotal`
    }
  
    db.del ITEM {
      field_name = "id"
      field_value = $input.item_id
    }
  
    db.get PEDIDO {
      field_name = "id"
      field_value = `$var.item_atual.pedido_id`
    } as $PEDIDO1
  
    db.patch PEDIDO {
      field_name = "id"
      field_value = $PEDIDO1.id
      data = {total: $var.PEDIDO1.total - $var.subtotal_do_item}
    } as $PEDIDO2
  
    db.query ITEM {
      where = $db.ITEM.pedido_id == $item_atual.pedido_id
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
  guid = "7cbjbYeD68hXSVCpCG5Bev6ClIY"
}