// Query all OP records
query op verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query OP {
      return = {type: "list"}
    } as $op
  }

  response = $op
  guid = "21n7MUdskoxW1TMMU3vlMri1g7g"
}