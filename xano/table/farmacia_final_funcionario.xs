table farmacia_final_funcionario {
  auth = true

  schema {
    int id
    text nome filters=trim
    email email filters=trim|lower { sensitive = true }
    password senha_hash { sensitive = true }
    bool ativo?=true
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "email", op: "asc"}]}
  ]
  guid = "lvDxkwPL48dDL1k54LaVtYgNtL4"
}
