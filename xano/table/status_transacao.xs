// Status possíveis para transações envolvendo pagamentos com cartões de crédito
table STATUS_TRANSACAO {
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
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]

  tags = ["status", "transação", "sabor"]
  guid = "X-8_hWiJMf9wmpDsk_60PP3TWJk"
}