query pega_cartoes_cadastrados verb=GET {
  api_group = "Asaas"
  auth = "user"

  input {
  }

  stack {
    db.get CLIENTE {
      field_name = "user_id"
      field_value = `$auth.id`
    } as $cliente_logado
  
    db.get STATUS_TTOKENIZACAO {
      field_name = "status"
      field_value = "Finalizada"
    } as $STATUS_TTOKENIZACAO_finalizada
  
    db.query TTOKENIZACAO {
      where = $db.TTOKENIZACAO.cliente_id == $cliente_logado.id && $db.TTOKENIZACAO.status_ttokenizacao_id == $STATUS_TTOKENIZACAO_finalizada.id
      return = {type: "list"}
    } as $cartoes_adicionados
  
    conditional {
      if ($cartoes_adicionados == []) {
        var $resultado {
          value = null
        }
      }
    
      else {
        var $resultado {
          value = $cartoes_adicionados
        }
      }
    }
  }

  response = $resultado
  guid = "GCTCpA02HW5rq40IKSXfqfdI-h0"
}