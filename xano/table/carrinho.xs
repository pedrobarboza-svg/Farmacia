// Carrinho do aplicativo delivery
table CARRINHO {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    int produto_id? {
      table = "PRODUTO"
    }
  
    int quantidade?
    decimal valor_total_item?
    text observacao? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]

  tags = ["carrinho", "pedido", "produto"]
  guid = "erlyWmezzCbnJyntuK1Sj0NDGkk"
}