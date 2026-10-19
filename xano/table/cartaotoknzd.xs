// Cartões Tokenizados após validações
table CARTAOTOKNZD {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    int cliente_id? {
      table = "CLIENTE"
    }
  
    text token? filters=trim
    text codigoclienteasaas? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "token", op: "asc"}]}
  ]

  tags = ["cartatoknzd", "sabor"]
  guid = "NblqOuhH4PHZj3X05FxSAbEHhac"
}