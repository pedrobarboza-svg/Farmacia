// Add CARRINHO record
query carrinho verb=POST {
  api_group = "AuthSaborLocal"

  input {
    dblink {
      table = ""
    }
  }

  stack {
    db.add "" {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $carrinho
  }

  response = $carrinho
  guid = "Crdq6HTATkEm6o8yGMTv7u9J43g"
}