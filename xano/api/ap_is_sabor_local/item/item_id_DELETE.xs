// Delete ITEM record.
query "item/{item_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int item_id? filters=min:1
  }

  stack {
    db.del ITEM {
      field_name = "id"
      field_value = $input.item_id
    }
  }

  response = null
  guid = "1t1WNJfkGE2ZMNCCl1d8FYnATSk"
}