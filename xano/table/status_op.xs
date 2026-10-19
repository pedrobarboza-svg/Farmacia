// Status possíveis das Ordens de Produção
table STATUS_OP {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    text status? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "status", op: "asc"}]}
  ]

  tags = ["status", "sabor"]
  guid = "whEs1GoXkB3ljS-lRYrPR_8YYmo"
}