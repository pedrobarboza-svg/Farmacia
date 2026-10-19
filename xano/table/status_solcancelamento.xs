// Status possíveis das Solicitações de Cancelamento
table STATUS_SOLCANCELAMENTO {
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
  guid = "CNF6FGVTVsvyVlm78Hh8ZLSAEno"
}