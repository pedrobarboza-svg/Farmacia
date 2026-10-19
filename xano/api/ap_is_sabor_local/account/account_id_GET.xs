// Get account record
query "account/{account_id}" verb=GET {
  api_group = "APIs SaborLocal"

  input {
    int account_id? filters=min:1
  }

  stack {
    db.get "" {
      field_name = "id"
      field_value = $input.account_id
    } as $account
  
    precondition ($account != null) {
      error_type = "notfound"
      error = "Not Found."
    }
  }

  response = $account
  guid = "vmkben1NHXCF6M0SlF8L3o4nOf0"
}