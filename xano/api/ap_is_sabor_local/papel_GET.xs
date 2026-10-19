// Query all PAPEL records
query papel verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query PAPEL {
      return = {type: "list"}
    } as $papel
  }

  response = $papel
  guid = "ji5F6JfU5VwXdsai0K8G9qc1JZA"
}