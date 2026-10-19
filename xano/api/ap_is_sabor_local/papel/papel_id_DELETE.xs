// Delete PAPEL record.
query "papel/{papel_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int papel_id? filters=min:1
  }

  stack {
    db.del PAPEL {
      field_name = "id"
      field_value = $input.papel_id
    }
  }

  response = null
  guid = "Indh5f-rqhFsr-syUO-oH20z358"
}