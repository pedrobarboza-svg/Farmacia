// Delete TRANSAÇÃO record.
query "transa_o/{transa_o_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int transa_o_id? filters=min:1
  }

  stack {
    db.del TRANSACAO {
      field_name = "id"
      field_value = $input.transa_o_id
    }
  }

  response = null
  guid = "oD44KBYlfoVkV5P_fp2C6Cfvq0s"
}