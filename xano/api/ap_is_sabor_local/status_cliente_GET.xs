// Query all STATUS_CLIENTE records
query status_cliente verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query STATUS_CLIENTE {
      return = {type: "list"}
    } as $status_cliente
  }

  response = $status_cliente
  guid = "_EqaFxpMgTaTrXjRoG5aYRW9bFw"
}