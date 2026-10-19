query categorias verb=POST {
  api_group = "Farmácia"

  input {
    text nome
    text descricao?
  }

  stack {
    db.add categorias {
      data = {nome: $input.nome, descricao: $input.descricao}
    } as $categoria
  }

  response = $categoria
  guid = "f5-EK-KbkY1RGMyXpHGzK9jiFv0"
}