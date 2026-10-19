// Delete ENDERECO record.
query "endereco/{endereco_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int endereco_id? filters=min:1
  }

  stack {
    db.del ENDERECO {
      field_name = "id"
      field_value = $input.endereco_id
    }
  }

  response = null
  guid = "EHeyXjbMSdJTam0G1RsPIx7Qu5c"
}