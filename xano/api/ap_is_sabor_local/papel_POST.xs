// Add PAPEL record
query papel verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "PAPEL"
    }
  }

  stack {
    db.add PAPEL {
      enforce_hidden_fields = false
      data = {created_at: "now"}
    } as $papel
  }

  response = $papel
  guid = "xNAVx99xiD3LZdwCfZ7tk7gnVUk"
}