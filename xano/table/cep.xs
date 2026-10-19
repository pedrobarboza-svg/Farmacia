// CEP dos Clientes cadastrados
table CEP {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    text cep? filters=trim
    text cidade? filters=trim
    text uf? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "cep", op: "asc"}]}
  ]

  tags = ["cep", "sabor"]
  guid = "77BreJ9tEiQQm1oYa-y_KxYr8LM"
}