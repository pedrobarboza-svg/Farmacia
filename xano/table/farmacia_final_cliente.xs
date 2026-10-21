table farmacia_final_cliente {
  auth = false

  schema {
    int id
    text nome filters=trim
    text cpf filters=trim
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "cpf", op: "asc"}]}
  ]
  guid = "5wfEF5ZTcR6najl2G4fOyQI44jg"
}
