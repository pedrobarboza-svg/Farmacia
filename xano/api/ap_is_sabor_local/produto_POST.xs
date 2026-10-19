// Add PRODUTO record
query produto verb=POST {
  api_group = "APIs SaborLocal"

  input {
    dblink {
      table = "PRODUTO"
    }
  }

  stack {
    db.add PRODUTO {
      enforce_hidden_fields = false
      data = {
        created_at : "now"
        nome       : $input.nome
        descricao  : $input.descricao
        qtd_integer: $input.qtd_integer
        url_imagem : $input.url_imagem
        preco      : $input.preco
      }
    } as $produto
  }

  response = $produto
  guid = "mf01XB15da_-puMv6pBqExD_FfY"
}