query "clientes/{id}" verb=PATCH {
  api_group = "Farmácia"

  input {
    int id
    text nome?
    text email?
    text telefone?
    bool ativo?
  }

  stack {
    db.edit clientes {
      field_name = "id"
      field_value = $input.id
      data = {
        nome    : $input.nome
        email   : $input.email
        telefone: $input.telefone
        ativo   : $input.ativo
      }
    } as $cliente
  }

  response = $cliente
  guid = "YhiOheqAhXppX4cpqUKwMJEYTf8"
}