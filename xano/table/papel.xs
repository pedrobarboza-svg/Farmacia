// Papéis possíveis para os Usuários cadastrados no sistema.
table PAPEL {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    text papel? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "papel", op: "asc"}]}
  ]

  tags = ["papel", "sabor"]
  guid = "ON4-aVEBM1dMcAw934CFNw6eI-k"
}