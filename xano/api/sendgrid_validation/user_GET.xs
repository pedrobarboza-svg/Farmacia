// Query all user records
query user verb=GET {
  api_group = "Sendgrid Validation"

  input {
  }

  stack {
    db.query user {
      return = {type: "list"}
    } as $model
  }

  response = $model
  guid = "xyOxATEFb-MdlKoFdWZEUBffX50"
}