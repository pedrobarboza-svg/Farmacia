// Query all STATUS_OE records
query status_oe verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query STATUS_OE {
      return = {type: "list"}
    } as $status_oe
  }

  response = $status_oe
  guid = "ip6Scp4xH7I15oT5GbcN8-gyuPY"
}