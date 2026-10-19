// Query all account records
query account verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query "" {
      return = {type: "list"}
    } as $account
  }

  response = $account
  guid = "iUs8UncCwWCm_Z8Zrxf-yPZaRsI"
}