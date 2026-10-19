// Transações de Tokenização dos Cartões de Créditos e Cartões de Débitos
table TTOKENIZACAO {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    int cliente_id? {
      table = "CLIENTE"
    }
  
    text? det_cartao_encript? filters=trim
    text token? filters=trim
    int status_ttokenizacao_id?=1 {
      table = "STATUS_TTOKENIZACAO"
    }
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]

  tags = ["sabor"]
  guid = "rGB42L7HSPubCa__OZmwueu9rJ0"
}