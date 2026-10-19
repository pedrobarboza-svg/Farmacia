// Add CARTAOTOKNZD record
query cartaotoknzd verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "CARTAOTOKNZD"
    }
  }

  stack {
    db.add CARTAOTOKNZD {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $cartaotoknzd
  }

  response = $cartaotoknzd
  guid = "mz7OJR9-gUL4Di5y_s0XAgIk_YI"
}