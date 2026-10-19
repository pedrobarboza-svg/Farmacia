table itens_venda {
  auth = false

  schema {
    int id
    int venda_id
    int produto_id
    int quantidade
    decimal preco_unitario
    decimal subtotal_item
  }

  index = [{type: "primary", field: [{name: "id"}]}]
  guid = "LJWHpnlvCNDB4Z13umLRbJRZF7c"
}