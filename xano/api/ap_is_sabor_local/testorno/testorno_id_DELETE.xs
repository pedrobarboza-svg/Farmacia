// Delete TESTORNO record.
query "testorno/{testorno_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int testorno_id? filters=min:1
  }

  stack {
    db.del TESTORNO {
      field_name = "id"
      field_value = $input.testorno_id
    }
  }

  response = null
  guid = "_GvALAzJho1n6ZYWf2eX031xqcE"
}