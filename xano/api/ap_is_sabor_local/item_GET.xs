// Query all ITEM records
query item verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query ITEM {
      return = {type: "list"}
    } as $item
  }

  response = $item
  guid = "-QL4nrICzh0QLmguLN_oEgeQccY"
}