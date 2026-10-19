// Query all faculdade records
query faculdade verb=GET {
  api_group = "Event Logs"

  input {
  }

  stack {
    db.query "" {
      return = {type: "list"}
    } as $faculdade
  }

  response = $faculdade
  guid = "t_3p5dRv2ni4kHBAfmzU3q_yOLo"
}