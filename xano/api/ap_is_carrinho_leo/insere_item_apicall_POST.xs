// Insere um item no carrinho e retorna o carrinho atualizado.
query insere_item_apicall verb=POST {
  api_group = "APIs Carrinho Leo"

  input {
    // ID do pedido aberto (carrinho)
    int pedido_aberto_id
  
    // Quantidade de itens a serem adicionados ao pedido. Se qdt == null, qtd = 1
    int qtd?=1
  
    // ID do produto na tabela PRODUTO
    int produto_id
  }

  stack {
    db.get PRODUTO {
      field_name = "id"
      field_value = $input.produto_id
    } as $produto_atual
  
    precondition ("produto_atual.qtd_disp" >= $input.qtd) {
      error_type = "badrequest"
      error = "Quantidade indisponível"
      payload = "Quantidade indisponível"
    }
  
    db.query ITEM {
      where = $db.ITEM.pedido_id == $input.pedido_aberto_id && $db.ITEM.produto_id == $input.produto_id
      return = {type: "list"}
    } as $item_no_carrinho
  
    conditional {
      if ($item_no_carrinho == []) {
        var $subtotal {
          value = $input.qtd * $produto_atual.preco
        }
      
        var $subtotal_anterior {
          value = 0
        }
      
        conditional {
          if (`$produto_atual.precisa_produzir`) {
            var $status_item_id {
              value = 3
            }
          }
        
          else {
            var $status_item_id {
              value = 4
            }
          }
        }
      
        db.add ITEM {
          enforce_hidden_fields = false
          data = {
            created_at    : "now"
            pedido_id     : $input.pedido_aberto_id
            qtd           : $input.qtd
            valor_unit    : `$produto_atual.preco`
            subtotal      : $subtotal
            produto_id    : $input.produto_id
            status_item_id: $status_item_id
          }
        } as $ITEM1
      }
    
      else {
        var $nova_qtd {
          value = $item_no_carrinho.0.qtd + $input.qtd
        }
      
        precondition ($produto_atual.qtd_disp >= $nova_qtd) {
          error_type = "badrequest"
          error = "Quantidade indisponível"
          payload = "Quantidade indisponível"
        }
      
        var $subtotal {
          value = $nova_qtd * $item_no_carrinho.0.valor_unit
        }
      
        var $subtotal_anterior {
          value = $item_no_carrinho[0].subtotal
        }
      
        db.edit ITEM {
          field_name = "id"
          field_value = $item_no_carrinho[0].id
          enforce_hidden_fields = false
          data = {qtd: $nova_qtd, subtotal: $subtotal}
        } as $ITEM2
      }
    }
  
    db.get PEDIDO {
      field_name = "id"
      field_value = $input.pedido_aberto_id
    } as $PEDIDO1
  
    var $novo_total {
      value = $var.PEDIDO1.total - $var.subtotal_anterior + $var.subtotal
    }
  
    db.patch PEDIDO {
      field_name = "id"
      field_value = `$input.pedido_aberto_id`
      data = {total: $novo_total}
    } as $PEDIDO2
  
    db.query ITEM {
      where = $db.ITEM.pedido_id == $input.pedido_aberto_id
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
  guid = "eGzdRV960EOfGiT4zADW4V5Jjl8"
}