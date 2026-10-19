// Add OP record
query op verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "OP"
    }
  }

  stack {
    db.add OP {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $op
  }

  response = $op
  guid = "8AMGlNO88EcAZOWUXFlFDlXP7IA"
}