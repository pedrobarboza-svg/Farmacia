table produtos {
  auth = false

  schema {
    int id
    int categoria_id {
      table = "categorias"
    }
    text nome
    text? descricao
    decimal preco
    int estoque
    bool ativo?=true
  }

  index = [{type: "primary", field: [{name: "id"}]}]
  guid = "UJOSuXgZzQoRjprALHAzddM2dRY"
}