query vendas verb=POST {
  api_group = "Farmácia"

  input {
    int cliente_id
    int funcionario_id
    int produto_id {
      table = "produtos"
    }
    int quantidade filters=min:1
    bool aplicar_desconto?
  }

  stack {
    db.get produtos {
      field_name = "id"
      field_value = $input.produto_id
    } as $produto

    precondition ($produto != null) {
      error_type = "notfound"
      error = "Produto não encontrado."
    }

    precondition ($produto.ativo == true) {
      error_type = "badrequest"
      error = "Produto indisponível para venda."
    }

    db.transaction {
      stack {
        db.direct_query {
          sql = "UPDATE produtos SET estoque = estoque - ? WHERE id = ? AND ativo = TRUE AND estoque >= ? RETURNING id, estoque, preco"
          arg = [$input.quantidade, $input.produto_id, $input.quantidade]
          response_type = "list"
        } as $estoque_atualizado

        precondition (($estoque_atualizado|count) > 0) {
          error_type = "badrequest"
          error = "Estoque insuficiente para o produto " ~ $produto.nome
        }

        var $preco_venda {
          value = $estoque_atualizado.0.preco
        }

        var $subtotal {
          value = $preco_venda * $input.quantidade
        }

        var $dados_valores {
          value = {
            percentual_desconto: 0
            valor_desconto     : 0
            valor_total        : $subtotal
          }
        }

        conditional {
          if ($input.aplicar_desconto) {
            var.update $dados_valores {
              value = $dados_valores
                |set:"percentual_desconto":10
                |set:"valor_desconto":($subtotal * 0.1)
                |set:"valor_total":($subtotal * 0.9)
            }
          }
        }

        db.add vendas {
          data = {
            cliente_id        : $input.cliente_id
            funcionario_id    : $input.funcionario_id
            data_venda        : now
            subtotal          : $subtotal
            percentual_desconto: $dados_valores.percentual_desconto
            valor_desconto    : $dados_valores.valor_desconto
            valor_total       : $dados_valores.valor_total
            forma_pagamento   : "simulado"
          }
        } as $venda

        db.add itens_venda {
          data = {
            venda_id      : $venda.id
            produto_id    : $input.produto_id
            quantidade    : $input.quantidade
            preco_unitario: $preco_venda
            subtotal_item : $subtotal
          }
        } as $item_venda
      }
    }
  }

  response = $venda
  guid = "aDvFG6uBHnSADVLyyUUXRaNd8QE"
}