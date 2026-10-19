// Query all FAQ records
query faq verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query FAQ {
      return = {type: "list"}
    } as $faq
  }

  response = $faq
  guid = "1oUhBD8dKkvij1RicBRRF8HhzqQ"
}