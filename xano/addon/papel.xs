addon PAPEL {
  input {
    int PAPEL_id? {
      table = "PAPEL"
    }
  }

  stack {
    db.query PAPEL {
      where = $db.PAPEL.id == $input.PAPEL_id
      return = {type: "single"}
    }
  }

  guid = "3mBOlUIte0KWVcLEcaQqk1KQpYY"
}