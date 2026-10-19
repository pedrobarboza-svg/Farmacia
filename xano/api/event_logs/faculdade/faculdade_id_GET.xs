// Get faculdade record
query "faculdade/{faculdade_id}" verb=GET {
  api_group = "Event Logs"

  input {
    int faculdade_id? filters=min:1
  }

  stack {
    db.get "" {
      field_name = "id"
      field_value = $input.faculdade_id
    } as $faculdade
  
    precondition ($faculdade != null) {
      error_type = "notfound"
      error = "Not Found."
    }
  }

  response = $faculdade
  guid = "1tH659Ah0cinJanxZ-UppExuTl8"
}