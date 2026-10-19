query funcionarios verb=GET {
  api_group = "Farmácia"

  input {
    bool ativo?
  }

  stack {
    db.query funcionarios {
      where = $input.ativo == null || $db.funcionarios.ativo == $input.ativo
      return = {type: "list"}
    } as $funcionarios
  }

  response = $funcionarios
  guid = "bMvvb1ZK8YMTkNPZkzojPOB_1zc"
}