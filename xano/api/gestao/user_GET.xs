// Query all user records
query user verb=GET {
  api_group = "Gestão"

  input {
  }

  stack {
    db.query user {
      return = {type: "list"}
      addon = [
        {
          name : "PAPEL"
          input: {PAPEL_id: $output.papel_id}
          as   : "_produto"
        }
      ]
    } as $model
  }

  response = $model
  guid = "8t6iFL46H5zt4rTpoe4b40Avqak"
}