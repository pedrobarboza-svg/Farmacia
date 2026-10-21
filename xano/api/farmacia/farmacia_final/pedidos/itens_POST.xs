query "farmacia-final/pedidos/{id}/itens" verb=POST {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    int id
    int produto_id {
      table = "farmacia_final_produtos"
    }
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

        db.get farmacia_final_produtos {
          field_name = "id"
          field_value = $input.produto_id
        } as $produto

        precondition (($produto != null) && ($produto.ativo == true)) {
          error_type = "inputerror"
          error = "PRODUTO_INVALIDO: o produto não existe ou está inativo."
        }

        db.add farmacia_final_item_pedido {
          data = {
            pedido_id: $pedido.id
            produto_id: $produto.id
            quantidade: $input.quantidade
            preco_unitario: $produto.preco
          }
        } as $item
      }
    }
  }

  response = $item
  guid = "xLhM6d4FVQe0W8nE-Z9_mLfWQKM"
}
