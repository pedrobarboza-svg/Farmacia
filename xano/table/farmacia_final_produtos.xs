table farmacia_final_produtos {
  auth = false

  schema {
    int id
    text nome filters=trim
    text? descricao filters=trim
    decimal preco filters=min:0
    int estoque filters=min:0
    bool ativo?=true
    int categoria_id {
      table = "farmacia_final_categorias"
    }
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "categoria_id", op: "asc"}]}
  ]
  guid = "5vgvcpQyVHXc-ihvMxY5opsyiHo"
}
