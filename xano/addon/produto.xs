addon PRODUTO {
  input {
    int PRODUTO_id? {
      table = "PRODUTO"
    }
  }

  stack {
    db.query PRODUTO {
      where = $db.PRODUTO.id == $input.PRODUTO_id
      return = {type: "single"}
    }
  }

  guid = "7Ik4YjUDTa6IkFyT7lUqTnVMsFM"
}