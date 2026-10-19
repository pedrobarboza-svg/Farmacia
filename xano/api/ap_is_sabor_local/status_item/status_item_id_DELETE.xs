// Delete STATUS_ITEM record.
query "status_item/{status_item_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int status_item_id? filters=min:1
  }

  stack {
    db.del STATUS_ITEM {
      field_name = "id"
      field_value = $input.status_item_id
    }
  }

  response = null
  guid = "XXEdkf7-oAH8-ANzP7Y0Nth4SGA"
}