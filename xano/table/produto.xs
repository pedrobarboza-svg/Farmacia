// Produtos cadastrados que podem ser incluídos como Itens de Pedidos dos Cliente
table PRODUTO {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    text nome? filters=trim
    text descricao? filters=trim
    int[] qtd_integer?
    text url_imagem? filters=trim
    decimal preco?
    bool precisa_produzir?
    int qtd_disp?
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "nome", op: "asc"}]}
  ]

  tags = ["produto", "sabor"]
  guid = "ySp2Sy3eCiGbqeaeopl2P7TCxog"
}