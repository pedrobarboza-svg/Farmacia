// Add CARRINHO record
query carrinho verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "CARRINHO"
    }
  }

  stack {
    db.add CARRINHO {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $carrinho
  }

  response = $carrinho
  guid = "aMSa9bT_3CZLHlISmo-wDrNjSlc"
}