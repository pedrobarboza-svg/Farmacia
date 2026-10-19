// Tabela dos usuarios cadastrados
table user {
  auth = true

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
  
    text name filters=trim
    email? email filters=trim|lower
    password? password filters=min:8|minAlpha:1|minDigit:1 {
      visibility = "internal"
    }
  
    int papel_id?=6 {
      table = "PAPEL"
    }
  
    text celular? filters=trim
    text cpf? filters=trim
    int codigo_otp?
    timestamp? expiracao_otp?
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {
      type : "btree|unique"
      field: [{name: "email", op: "asc"}, {name: "cpf", op: "asc"}]
    }
  ]

  tags = ["xano:quick-start", "sabor"]
  guid = "g8tpjso2orFaPgdxKGzuuR66M1k"
}