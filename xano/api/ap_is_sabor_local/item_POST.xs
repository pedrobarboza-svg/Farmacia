// Add ITEM record
query item verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "ITEM"
    }
  }

  stack {
    db.add ITEM {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $item
  }

  response = $item
  guid = "jsI3ECc7G4C4E2AemyrgglgdOjY"
}