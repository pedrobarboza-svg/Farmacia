// Edit Categoria_Produto record
query "categoria_produto/{categoria_produto_id}" verb=PATCH {
  api_group = "APIs SaborLocal"

  input {
    int categoria_produto_id? filters=min:1
    dblink {
      table = "Categoria_Produto"
    }
  }

  stack {
    util.get_raw_input {
      encoding = "json"
      exclude_middleware = false
    } as $raw_input
  
    db.patch Categoria_Produto {
      field_name = "id"
      field_value = $input.categoria_produto_id
      data = `$input|pick:($raw_input|keys)`|filter_null|filter_empty_text
    } as $categoria_produto
  }

  response = $categoria_produto
  guid = "YeVlnEoHJlNR5ekdIjQ5zoYFktY"
}