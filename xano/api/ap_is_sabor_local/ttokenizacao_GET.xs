// Query all TTOKENIZACAO records
query ttokenizacao verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query TTOKENIZACAO {
      return = {type: "list"}
    } as $ttokenizacao
  }

  response = $ttokenizacao
  guid = "nLSaAt3ylemCt4p9rqYgO1MwDmM"
}