// Query all CARTAOTOKNZD records
query cartaotoknzd verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query CARTAOTOKNZD {
      return = {type: "list"}
    } as $cartaotoknzd
  }

  response = $cartaotoknzd
  guid = "k59OGNAhz7MJtYHMv76tHonDjPk"
}