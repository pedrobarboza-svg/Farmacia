table funcionarios {
  auth = false

  schema {
    int id
    text nome
    text email
    text cargo
    bool ativo?=true
  }

  index = [{type: "primary", field: [{name: "id"}]}]
  guid = "50IcCvJvr7pBCIXQekLIInEeOa4"
}