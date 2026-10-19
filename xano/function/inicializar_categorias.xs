function "Farmacia/inicializar_categorias" {
  description = "Garante que as categorias padrão da farmácia existam."
  input {
  }

  stack {
    db.has categorias {
      field_name = "nome"
      field_value = "Remédios"
    } as $tem_remedios
  
    conditional {
      if ($tem_remedios == false) {
        db.add categorias {
          data = {nome: "Remédios"}
        } as $remedios
      }
    }
  
    db.has categorias {
      field_name = "nome"
      field_value = "Bebidas"
    } as $tem_bebidas
  
    conditional {
      if ($tem_bebidas == false) {
        db.add categorias {
          data = {nome: "Bebidas"}
        } as $bebidas
      }
    }
  
    db.has categorias {
      field_name = "nome"
      field_value = "Fraldas"
    } as $tem_fraldas
  
    conditional {
      if ($tem_fraldas == false) {
        db.add categorias {
          data = {nome: "Fraldas"}
        } as $fraldas
      }
    }
  
    db.has categorias {
      field_name = "nome"
      field_value = "Produtos de Higiene"
    } as $tem_higiene
  
    conditional {
      if ($tem_higiene == false) {
        db.add categorias {
          data = {nome: "Produtos de Higiene"}
        } as $higiene
      }
    }
  }

  response = {status: "ok"}
}
