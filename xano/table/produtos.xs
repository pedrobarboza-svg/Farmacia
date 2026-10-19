table produtos {
  auth = false

  schema {
    int id
    int categoria_id
    text nome
    text? descricao
    decimal preco_unitario
    int? quantidade_estoque
    bool ativo?=true
  }

  index = [{type: "primary", field: [{name: "id"}]}]
  guid = "UJOSuXgZzQoRjprALHAzddM2dRY"
}