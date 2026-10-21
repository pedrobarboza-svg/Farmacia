table farmacia_final_cargo {
  auth = false

  schema {
    int id
    text nome filters=trim
    bool ativo?=true
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "nome", op: "asc"}]}
  ]

  items = [
    {id: 1, nome: "Atendente", ativo: true}
    {id: 2, nome: "Farmacêutico", ativo: true}
    {id: 3, nome: "Gerente", ativo: true}
    {id: 4, nome: "Repositor", ativo: true}
    {id: 5, nome: "Caixa", ativo: true}
    {id: 6, nome: "Estagiário", ativo: true}
  ]
  guid = "x7Ya6yrkmpDU3tbSdUx7QpYiOu0"
}
