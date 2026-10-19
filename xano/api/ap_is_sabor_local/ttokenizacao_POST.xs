// Add TTOKENIZACAO record
query ttokenizacao verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "TTOKENIZACAO"
    }
  }

  stack {
    db.add TTOKENIZACAO {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $ttokenizacao
  }

  response = $ttokenizacao
  guid = "c0I1RSgrYXhSQmJfJS4zOFDpMlo"
}