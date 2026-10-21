query "farmacia-final/clientes" verb=POST {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    text nome filters=trim
    text cpf filters=trim
  }

  stack {
    precondition ("/^[0-9]{11}$/"|regex_matches:$input.cpf) {
      error_type = "inputerror"
      error = "CPF_INVALIDO: o CPF deve conter exatamente 11 dígitos numéricos."
    }

    db.get farmacia_final_cliente {
      field_name = "cpf"
      field_value = $input.cpf
    } as $existente

    precondition ($existente == null) {
      error_type = "inputerror"
      error = "CPF_DUPLICADO: já existe cliente cadastrado com este CPF."
    }

    db.add farmacia_final_cliente {
      data = {
        nome: $input.nome
        cpf: $input.cpf
      }
    } as $cliente
  }

  response = {
    id: $cliente.id
    nome: $cliente.nome
    cpf: $cliente.cpf
    created_at: $cliente.created_at
  }
  guid = "odWaiGYWNG95oEoHeBxDfJ5-rRc"
}
