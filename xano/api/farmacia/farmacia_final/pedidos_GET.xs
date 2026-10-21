query "farmacia-final/pedidos" verb=GET {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {}

  stack {
    db.query farmacia_final_pedido {
      where = $db.farmacia_final_pedido.funcionario_id == $auth.id
      sort = {created_at: "desc"}
      return = {type: "list"}
    } as $pedidos
  }

  response = $pedidos
  guid = "MtgnaNDgEmMQB4-qtJ0hSXmoWl0"
}
