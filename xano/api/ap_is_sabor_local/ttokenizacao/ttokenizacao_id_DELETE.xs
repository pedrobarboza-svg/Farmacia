// Delete TTOKENIZACAO record.
query "ttokenizacao/{ttokenizacao_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int ttokenizacao_id? filters=min:1
  }

  stack {
    db.del TTOKENIZACAO {
      field_name = "id"
      field_value = $input.ttokenizacao_id
    }
  }

  response = null
  guid = "KBg87J7tQhBBCP1VJOyRWkxcxs8"
}