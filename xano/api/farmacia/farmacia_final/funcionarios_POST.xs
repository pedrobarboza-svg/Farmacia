query "farmacia-final/funcionarios" verb=POST {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    text nome filters=trim
    email email filters=trim|lower
    text senha
    bool ativo?=true
  }

  stack {
    precondition (($input.nome|strlen) > 0) {
      error_type = "inputerror"
      error = "NOME_INVALIDO: informe o nome do funcionário."
    }

    db.get farmacia_final_funcionario {
      field_name = "email"
      field_value = $input.email
    } as $existente

    precondition ($existente == null) {
      error_type = "inputerror"
      error = "EMAIL_DUPLICADO: o e-mail informado já está cadastrado."
    }

    db.add farmacia_final_funcionario {
      data = {
        nome: $input.nome
        email: $input.email
        senha_hash: $input.senha
        ativo: $input.ativo
      }
    } as $funcionario
  }

  response = {
    id: $funcionario.id
    nome: $funcionario.nome
    email: $funcionario.email
    ativo: $funcionario.ativo
    created_at: $funcionario.created_at
  }
  guid = "jF4W75iFFDRl1KbKXOv3Iaw0xNA"
}
