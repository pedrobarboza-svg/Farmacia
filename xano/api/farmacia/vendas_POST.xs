query vendas verb=POST {
  api_group = "Farmácia"

  input {
    int cliente_id
    int funcionario_id
    int produto_id
    int quantidade
    bool aplicar_desconto?
  }

  stack {
    db.get produtos {
      field_name = "id"
      field_value = $input.produto_id
    } as $produto
  
    var $valor {
      value = $produto.preco * $input.quantidade
    }
  
    conditional {
      if ($input.aplicar_desconto) {
        var $valor {
          value = $valor * 0.9
        }
      }
    }
  
    db.add vendas {
      data = {
        cliente_id    : $input.cliente_id
        funcionario_id: $input.funcionario_id
        produto_id    : $input.produto_id
        quantidade    : $input.quantidade
        valor_total   : $valor
      }
    } as $venda
  
    db.edit produtos {
      field_name = "id"
      field_value = $input.produto_id
      data = {estoque: $produto.estoque - $input.quantidade}
    }
  }

  response = $venda
  guid = "aDvFG6uBHnSADVLyyUUXRaNd8QE"
}