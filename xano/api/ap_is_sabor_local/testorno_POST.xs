// Add TESTORNO record
query testorno verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "TESTORNO"
    }
  }

  stack {
    db.add TESTORNO {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $testorno
  }

  response = $testorno
  guid = "q81tRz3QapVUAMxgXKybgvaK2ow"
}