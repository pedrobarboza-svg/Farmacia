query "farmacia-final/pedidos/{id}" verb=GET {
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

    precondition ($pedido != null) {
      error_type = "notfound"
      error = "PEDIDO_NAO_ENCONTRADO: o pedido não existe."
    }

    precondition ($pedido.funcionario_id == $auth.id) {
      error_type = "accessdenied"
      error = "PEDIDO_NAO_AUTORIZADO: este pedido pertence a outro funcionário."
    }

    db.query farmacia_final_item_pedido {
      join = {
        produto: {
          table: "farmacia_final_produtos"
          type: "inner"
          where: $db.farmacia_final_item_pedido.produto_id == $db.farmacia_final_produtos.id
        }
      }
      eval = {
        produto_nome: $db.farmacia_final_produtos.nome
      }
      where = $db.farmacia_final_item_pedido.pedido_id == $input.id
      return = {type: "list"}
    } as $itens
  }

  response = {
    pedido: $pedido
    itens: $itens
  }
  guid = "63lEHD9Zo98kZVaRJ3rKlIoOy08"
}
