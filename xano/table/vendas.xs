table vendas {
  auth = false

  schema {
    int id
    int funcionario_id
    int? cliente_id
    timestamp? data_venda
    decimal subtotal
    decimal percentual_desconto
    decimal valor_desconto
    decimal valor_total
    text forma_pagamento
  }

  index = [{type: "primary", field: [{name: "id"}]}]
  guid = "r7MrGewy60c7EFfen0eck8IgFjs"
}