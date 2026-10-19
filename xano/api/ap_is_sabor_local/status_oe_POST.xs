// Add STATUS_OE record
query status_oe verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "STATUS_OE"
    }
  }

  stack {
    db.add STATUS_OE {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $status_oe
  }

  response = $status_oe
  guid = "1sRO762Rr1h1iA0CAUZzq7B7c2o"
}