// Delete faculdade record.
query "faculdade/{faculdade_id}" verb=DELETE {
  api_group = "Event Logs"

  input {
    int faculdade_id? filters=min:1
  }

  stack {
    db.del "" {
      field_name = "id"
      field_value = $input.faculdade_id
    }
  }

  response = null
  guid = "Q3uhTtCna5hBaMYtfBBcz5TcHF4"
}