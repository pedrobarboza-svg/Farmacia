// Add STATUS_TRANSACAO record
query status_transacao verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = ""
    }
  }

  stack {
    db.add "" {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $status_transacao
  }

  response = $status_transacao
  guid = "O_mh8sv21T4w3Wpbqn53nvqElrw"
}