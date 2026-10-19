table clientes {
  auth = false

  schema {
    int id
    text nome
    text cpf
    text? email
    text? telefone
    timestamp? data_cadastro
    bool ativo?=true
  }

  index = [{type: "primary", field: [{name: "id"}]}]
  guid = "W5gZa0XZlq0jiA8XmjwUQ0Y3Yy8"
}