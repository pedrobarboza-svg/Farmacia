// Get ITEM record
query "item/{item_id}" verb=GET {
  api_group = "APIs SaborLocal"

  input {
    int item_id? filters=min:1
  }

  stack {
    db.get ITEM {
      field_name = "id"
      field_value = $input.item_id
    } as $item
  
    precondition ($item != null) {
      error_type = "notfound"
      error = "Not Found."
    }
  }

  response = $item
  guid = "J6KLbk0PQGRgiEDKu4d_gGELlTk"
}