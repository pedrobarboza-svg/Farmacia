query clientes verb=POST {
  api_group = "Farmácia"

  input {
    text nome
    text cpf
    text email?
    text telefone?
    bool ativo?
  }

  stack {
    db.add clientes {
      data = {
        nome    : $input.nome
        cpf     : $input.cpf
        email   : $input.email
        telefone: $input.telefone
        ativo   : $input.ativo ?? true
      }
    } as $cliente
  }

  response = $cliente
  guid = "nuN0p9-2t4tGYUSQ36zuRKscZYs"
}