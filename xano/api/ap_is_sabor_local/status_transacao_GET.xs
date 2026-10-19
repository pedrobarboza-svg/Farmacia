// Query all STATUS_TRANSACAO records
query status_transacao verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query "" {
      return = {type: "list"}
    } as $status_transacao
  }

  response = $status_transacao
  guid = "Ma9V8YaUG84_i08gKl66RhekuMI"
}