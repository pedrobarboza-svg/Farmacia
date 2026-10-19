// Add CLIENTE record
query cliente verb=POST {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.add "" {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $cliente
  }

  response = $cliente
  guid = "FCP9qW4uqm84LpkFm0uMIYt9MIM"
}