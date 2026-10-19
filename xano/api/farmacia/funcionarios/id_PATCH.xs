query "funcionarios/{id}" verb=PATCH {
  api_group = "Farmácia"

  input {
    int id
    text nome?
    text email?
    text cargo?
    bool ativo?
  }

  stack {
    db.edit funcionarios {
      field_name = "id"
      field_value = $input.id
      data = {
        nome : $input.nome
        email: $input.email
        cargo: $input.cargo
        ativo: $input.ativo
      }
    } as $funcionario
  }

  response = $funcionario
  guid = "o7OPlWodSzoo-96Ukk_L_JBSJF0"
}