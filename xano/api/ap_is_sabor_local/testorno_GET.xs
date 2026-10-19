// Query all TESTORNO records
query testorno verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query TESTORNO {
      return = {type: "list"}
    } as $testorno
  }

  response = $testorno
  guid = "d4zZyHX1l1M3JnIGNlWksn_NGGg"
}