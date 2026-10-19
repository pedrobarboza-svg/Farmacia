// Delete OP record.
query "op/{op_id}" verb=DELETE {
  api_group = "APIs SaborLocal"

  input {
    int op_id? filters=min:1
  }

  stack {
    db.del OP {
      field_name = "id"
      field_value = $input.op_id
    }
  }

  response = null
  guid = "68NgUApqgq0I4RHu6uLDONzL1Xo"
}