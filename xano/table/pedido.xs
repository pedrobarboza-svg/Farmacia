// Pedidos realizados pelos Clientes
table PEDIDO {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    decimal total?
    text? nfc_e? filters=trim
    text? cod_entrega? filters=trim
    int cliente_id? {
      table = "CLIENTE"
    }
  
    int status_pedido_id?=1 {
      table = "STATUS_PEDIDO"
    }
  
    int transacao_id? {
      table = "TRANSACAO"
    }
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "nfc_e", op: "asc"}]}
  ]

  tags = ["pedido", "sabor"]
  guid = "3S-91ZtXfTDAXN6Obi4VrpYRQck"
}