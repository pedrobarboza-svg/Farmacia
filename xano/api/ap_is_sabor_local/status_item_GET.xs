// Query all STATUS_ITEM records
query status_item verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query STATUS_ITEM {
      return = {type: "list"}
    } as $status_item
  }

  response = $status_item
  guid = "m1dQXO97BgXhvPXUk5bu_-T4AMk"
}