// Delete OE record.
query "oe/{oe_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int oe_id? filters=min:1
  }

  stack {
    db.del OE {
      field_name = "id"
      field_value = $input.oe_id
    }
  }

  response = null
  guid = "CqFpMpZT1tv3jK2WogSrvTDHyfg"
}