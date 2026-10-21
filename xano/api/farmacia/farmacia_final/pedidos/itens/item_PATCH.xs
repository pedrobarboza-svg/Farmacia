query "farmacia-final/pedidos/{id}/itens/{item_id}" verb=PATCH {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    int id
    int item_id
    int quantidade filters=min:1
  }

  stack {
    db.get farmacia_final_pedido {
      field_name = "id"
      field_value = $input.id
    } as $pedido

    precondition (($pedido != null) && ($pedido.funcionario_id == $auth.id)) {
      error_type = "notfound"
      error = "PEDIDO_NAO_ENCONTRADO: o pedido não existe ou não pertence ao funcionário."
    }

    precondition ($pedido.status == "rascunho") {
      error_type = "inputerror"
      error = "PEDIDO_FECHADO: só é possível alterar itens de pedidos em rascunho."
    }

    db.transaction {
      stack {
        db.direct_query {
          sql = "UPDATE farmacia_final_pedido SET status = status WHERE id = ? AND status = 'rascunho' RETURNING id"
          arg = [$pedido.id]
          response_type = "list"
        } as $pedido_bloqueado

        precondition (($pedido_bloqueado|count) == 1) {
          error_type = "inputerror"
          error = "PEDIDO_FECHADO: o pedido deixou de estar em rascunho."
        }

        db.get farmacia_final_item_pedido {
          field_name = "id"
          field_value = $input.item_id
        } as $item

        precondition (($item != null) && ($item.pedido_id == $pedido.id)) {
          error_type = "notfound"
          error = "ITEM_NAO_ENCONTRADO: o item não pertence ao pedido informado."
        }

        db.patch farmacia_final_item_pedido {
          field_name = "id"
          field_value = $item.id
          data = {quantidade: $input.quantidade}
        } as $item_atualizado
      }
    }
  }

  response = $item_atualizado
  guid = "05mXFQAftU2sNV0kPzomxyfdEa4"
}
