query "farmacia-final/categorias/inicializar" verb=POST {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {}

  stack {
    db.transaction {
      stack {
        db.get farmacia_final_categorias {
          field_name = "nome"
          field_value = "Remédios"
        } as $remedios

        conditional {
          if ($remedios == null) {
            db.add farmacia_final_categorias {
              data = {nome: "Remédios", descricao: "Medicamentos", ativo: true}
            } as $remedio_criado
          }
        }

        db.get farmacia_final_categorias {
          field_name = "nome"
          field_value = "Bebidas"
        } as $bebidas

        conditional {
          if ($bebidas == null) {
            db.add farmacia_final_categorias {
              data = {nome: "Bebidas", descricao: "Bebidas", ativo: true}
            } as $bebida_criada
          }
        }

        db.get farmacia_final_categorias {
          field_name = "nome"
          field_value = "Fraldas"
        } as $fraldas

        conditional {
          if ($fraldas == null) {
            db.add farmacia_final_categorias {
              data = {nome: "Fraldas", descricao: "Fraldas", ativo: true}
            } as $fralda_criada
          }
        }

        db.get farmacia_final_categorias {
          field_name = "nome"
          field_value = "Produtos de Higiene"
        } as $higiene

        conditional {
          if ($higiene == null) {
            db.add farmacia_final_categorias {
              data = {nome: "Produtos de Higiene", descricao: "Produtos de higiene", ativo: true}
            } as $higiene_criada
          }
        }
      }
    }

    db.query farmacia_final_categorias {
      where = $db.farmacia_final_categorias.ativo == true
      sort = {nome: "asc"}
      return = {type: "list"}
    } as $categorias
  }

  response = $categorias
  guid = "W2ozNrVfrgox1AS0SZjOZnxhYCU"
}
