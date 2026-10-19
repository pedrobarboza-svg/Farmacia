// Mantêm as API KEYs de serviços externos, tais como SendGrid e Assas.
table tokens {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    text Plataforma? filters=trim
    text token? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]

  tags = ["tokens", "sabor"]
  guid = "yT65-vmvwdFdbZpaWTr6ORyMk-M"
}