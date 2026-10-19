// Add OE record
query oe verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "OE"
    }
  }

  stack {
    db.add OE {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $oe
  }

  response = $oe
  guid = "UYOz4GfkkPhVqLV37VfgpLq4e8s"
}