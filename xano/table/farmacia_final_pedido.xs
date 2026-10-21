table farmacia_final_pedido {
  auth = false

  schema {
    int id
    int funcionario_id {
      table = "farmacia_final_funcionario"
    }
    int cliente_id? {
      table = "farmacia_final_cliente"
    }
    enum status?="rascunho" {
      values = ["rascunho", "concluido", "cancelado"]
    }
    decimal subtotal?=0 filters=min:0
    decimal desconto?=0 filters=min:0
    decimal total?=0 filters=min:0
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "funcionario_id", op: "asc"}]}
    {type: "btree", field: [{name: "status", op: "asc"}]}
  ]
  guid = "zw3Tm7bVozVuxYqpHMPE2lUFxrc"
}
