table categorias {
  auth = false

  schema {
    int id
    text nome filters=trim
    text? descricao filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "nome", op: "asc"}]}
  ]

  guid = "hm-oOaS9LFRsCyzCZcYlAmk0YBk"
}