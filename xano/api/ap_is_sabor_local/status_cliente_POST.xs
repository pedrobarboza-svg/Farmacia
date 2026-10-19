// Add STATUS_CLIENTE record
query status_cliente verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "STATUS_CLIENTE"
    }
  }

  stack {
    db.add STATUS_CLIENTE {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $status_cliente
  }

  response = $status_cliente
  guid = "B4Wp2yL3viKqMkYPHB7lN3JXYps"
}