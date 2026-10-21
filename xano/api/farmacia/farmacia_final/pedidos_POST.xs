query "farmacia-final/pedidos" verb=POST {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {
    int cliente_id? {
      table = "farmacia_final_cliente"
    }
  }

  stack {
    conditional {
      if ($input.cliente_id != null) {
        db.get farmacia_final_cliente {
          field_name = "id"
          field_value = $input.cliente_id
        } as $cliente

        precondition ($cliente != null) {
          error_type = "inputerror"
          error = "CLIENTE_INVALIDO: o cliente informado não existe."
        }
      }
    }

    db.add farmacia_final_pedido {
      data = {
        funcionario_id: $auth.id
        cliente_id: $input.cliente_id
        status: "rascunho"
        subtotal: 0
        desconto: 0
        total: 0
      }
    } as $pedido
  }

  response = $pedido
  guid = "fQnrLGznRl3jHDfDD1jvNkwB8xk"
}
