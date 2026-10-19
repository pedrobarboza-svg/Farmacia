// Add STATUS_TTOKENIZACAO record
query status_ttokenizacao verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "STATUS_TTOKENIZACAO"
    }
  }

  stack {
    db.add STATUS_TTOKENIZACAO {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $status_ttokenizacao
  }

  response = $status_ttokenizacao
  guid = "JFgs2Ci7UG2C_fhQRFS9RuuMoAI"
}