// Add account record
query account verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = ""
    }
  }

  stack {
    db.add "" {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $account
  }

  response = $account
  guid = "6derXFIy83Mp9DMGgwUoPCp7sCc"
}