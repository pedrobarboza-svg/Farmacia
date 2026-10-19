// Add TRANSAÇÃO record
query transa_o verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "TRANSACAO"
    }
  }

  stack {
    db.add TRANSACAO {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $transa_o
  }

  response = $transa_o
  guid = "MpXfo4A1zYpq0RFvWqgqVvBFpxk"
}