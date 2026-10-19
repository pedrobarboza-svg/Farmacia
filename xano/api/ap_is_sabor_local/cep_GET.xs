// Query all CEP records
query cep verb=GET {
  api_group = "APIs SaborLocal"

  input {
  }

  stack {
    db.query CEP {
      return = {type: "list"}
    } as $cep
  }

  response = $cep
  guid = "xWI5e9P_evxgoC6QB27rXtz2_Qo"
}