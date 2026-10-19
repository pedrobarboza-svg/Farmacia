// Query all STATUS_TESTORNO records
query status_testorno verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query STATUS_TESTORNO {
      return = {type: "list"}
    } as $status_testorno
  }

  response = $status_testorno
  guid = "Q1G8mJsqLh1z78wFV-E7W6aVk00"
}