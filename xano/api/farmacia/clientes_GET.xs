query clientes verb=GET {
  api_group = "Farmácia"

  input {
    bool ativo?
  }

  stack {
    db.query clientes {
      where = $input.ativo == null || $db.clientes.ativo == $input.ativo
      return = {type: "list"}
    } as $clientes
  }

  response = $clientes
  guid = "8M4CrMtWEnHlP22Ho7riFnkmv-A"
}