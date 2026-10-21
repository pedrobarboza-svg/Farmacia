table farmacia_final_categorias {
  auth = false

  schema {
    int id
    text nome filters=trim
    text? descricao filters=trim
    bool ativo?=true
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "nome", op: "asc"}]}
  ]
  guid = "SwaikYeHPxx-M_xvx7vkp_CG27M"
}
