// Add faculdade record
query faculdade verb=POST {
  api_group = "Event Logs"

  input {
    dblink {
      table = ""
    }
  }

  stack {
    db.add "" {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $faculdade
  }

  response = $faculdade
  guid = "5hvE56Ue-VQQgokaGtaLLZbfJJQ"
}