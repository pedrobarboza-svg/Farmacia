query funcionarios verb=POST {
  api_group = "Farmácia"

  input {
    text nome
    text email
    text cargo
    bool ativo?
  }

  stack {
    db.add funcionarios {
      data = {
        nome : $input.nome
        email: $input.email
        cargo: $input.cargo
        ativo: $input.ativo ?? true
      }
    } as $funcionario
  }

  response = $funcionario
  guid = "isHCJ_gZcbxUV1uAeH_ke60zUZs"
}