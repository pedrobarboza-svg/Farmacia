query "farmacia-final/funcionarios" verb=POST {
  api_group = "Farmácia"
  auth = ""

  input {
    text nome filters=trim
    email email filters=trim|lower
    text senha
    text cargo filters=trim
  }

  stack {
    precondition (($input.nome|strlen) > 0) {
      error_type = "inputerror"
      error = "NOME_INVALIDO: informe o nome do funcionário."
    }

    precondition (($input.senha|strlen) > 0) {
      error_type = "inputerror"
      error = "SENHA_INVALIDA: informe uma senha."
    }

    precondition (($input.cargo|strlen) > 0) {
      error_type = "inputerror"
      error = "CARGO_INVALIDO: informe o cargo do funcionário."
    }

    db.get farmacia_final_cargo {
      field_name = "nome"
      field_value = $input.cargo
    } as $cargo

    precondition (($cargo != null) && ($cargo.ativo == true)) {
      error_type = "inputerror"
      error = "CARGO_INVALIDO: selecione um cargo disponível."
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
        cargo: $input.cargo
        ativo: true
      }
    } as $funcionario
  }

  response = {
    id: $funcionario.id
    nome: $funcionario.nome
    email: $funcionario.email
    cargo: $funcionario.cargo
    ativo: $funcionario.ativo
    created_at: $funcionario.created_at
  }
  guid = "jF4W75iFFDRl1KbKXOv3Iaw0xNA"
}
