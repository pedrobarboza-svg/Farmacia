query "farmacia-final/pedidos/{id}/fechar" verb=POST {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    int id
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
      error = "PEDIDO_JA_FECHADO: o pedido não está em rascunho."
    }

    conditional {
      if ($pedido.cliente_id != null) {
        db.get farmacia_final_cliente {
          field_name = "id"
          field_value = $pedido.cliente_id
        } as $cliente

        precondition ($cliente != null) {
          error_type = "inputerror"
          error = "CLIENTE_INVALIDO: o cliente associado ao pedido não existe."
        }
      }
    }

    db.transaction {
      stack {
        db.direct_query {
          sql = "UPDATE farmacia_final_pedido SET status = 'concluido' WHERE id = ? AND status = 'rascunho' RETURNING id"
          arg = [$pedido.id]
          response_type = "list"
        } as $pedido_reivindicado

        precondition (($pedido_reivindicado|count) == 1) {
          error_type = "inputerror"
          error = "PEDIDO_JA_FECHADO: o pedido foi fechado por outra requisição."
        }

        db.query farmacia_final_item_pedido {
          where = $db.farmacia_final_item_pedido.pedido_id == $pedido.id
          return = {type: "list"}
        } as $itens

        precondition (($itens|count) > 0) {
          error_type = "inputerror"
          error = "PEDIDO_SEM_ITENS: adicione ao menos um item antes de fechar."
        }

        var $subtotal {
          value = 0
        }

        foreach ($itens) {
          each as $item {
            db.direct_query {
              sql = "UPDATE farmacia_final_produtos SET estoque = estoque - ? WHERE id = ? AND ativo = TRUE AND estoque >= ? RETURNING id"
              arg = [$item.quantidade, $item.produto_id, $item.quantidade]
              response_type = "list"
            } as $estoque_atualizado

            precondition (($estoque_atualizado|count) == 1) {
              error_type = "inputerror"
              error = "ESTOQUE_INSUFICIENTE: estoque insuficiente ou produto inativo."
            }

            var.update $subtotal {
              value = $subtotal + ($item.quantidade * $item.preco_unitario)
            }
          }
        }

        var $desconto {
          value = 0
        }

        conditional {
          if (($pedido.cliente_id != null) && ($subtotal > 100)) {
            var.update $desconto {
              value = ($subtotal * 0.15)|round:2
            }
          }
        }

        var $total {
          value = ($subtotal - $desconto)|round:2
        }

        db.edit farmacia_final_pedido {
          field_name = "id"
          field_value = $pedido.id
          data = {
            subtotal: $subtotal|round:2
            desconto: $desconto
            total: $total
            status: "concluido"
            created_at: now
          }
        } as $pedido_fechado
      }
    }
  }

  response = {
    pedido: $pedido_fechado
    itens: $itens
  }
  guid = "uEr6fM2MuMXgsELJFVwzURXW4dk"
}
