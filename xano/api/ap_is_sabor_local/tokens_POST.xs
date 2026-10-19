// Add tokens record
query tokens verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "tokens"
    }
  }

  stack {
    db.add tokens {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $tokens
  }

  response = $tokens
  guid = "K3IweeRiPYCnHq0tCYTjGLgKhk4"
}