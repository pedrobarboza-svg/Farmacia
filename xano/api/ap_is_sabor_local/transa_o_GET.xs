// Query all TRANSAÇÃO records
query transa_o verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query TRANSACAO {
      return = {type: "list"}
    } as $transa_o
  }

  response = $transa_o
  guid = "Fy-0H4-9l8CyeajSqVtDJ6fO5eI"
}