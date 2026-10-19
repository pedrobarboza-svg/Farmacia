// Descrição das perguntas e respostas mais comuns do site
table FAQ {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    text pertgunta? filters=trim
    text resposta? filters=trim
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]

  tags = ["faq"]
  guid = "s2SW6nSgZw4KBKtXoa9A8axXlA0"
}