// Get ENDERECO record
query "endereco/{endereco_id}" verb=GET {
  api_group = "APIs SaborLocal"

  input {
    int endereco_id? filters=min:1
  }

  stack {
    db.get ENDERECO {
      field_name = "id"
      field_value = $input.endereco_id
    } as $endereco
  
    precondition ($endereco != null) {
      error_type = "notfound"
      error = "Not Found."
    }
  }

  response = $endereco
  guid = "4HPQGSPZDeIos2zK1W1XSTc4-10"
}