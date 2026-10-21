query "farmacia-final/clientes/cpf/{cpf}" verb=GET {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
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
    } as $cliente

    precondition ($cliente != null) {
      error_type = "notfound"
      error = "CLIENTE_NAO_ENCONTRADO: não há cliente cadastrado com este CPF."
    }
  }

  response = $cliente
  guid = "MjhWKLLLFqVgsp8hI1rOKyDGaWQ"
}
