query "farmacia-final/relatorios/vendas" verb=GET {
  api_group = "Farmácia"
  auth = "farmacia_final_funcionario"

  input {}

  stack {
    db.direct_query {
      sql = "SELECT COALESCE(SUM(CASE WHEN created_at >= CURRENT_DATE THEN total ELSE 0 END), 0) AS hoje, COALESCE(SUM(CASE WHEN created_at >= NOW() - INTERVAL '7 days' THEN total ELSE 0 END), 0) AS ultimos_sete_dias, COALESCE(SUM(CASE WHEN created_at >= date_trunc('month', CURRENT_DATE) THEN total ELSE 0 END), 0) AS mes_corrente FROM farmacia_final_pedido WHERE status = 'concluido'"
      arg = []
      response_type = "list"
    } as $relatorio
  }

  response = $relatorio.0
  guid = "mGUGIfEWdCoiMG1fp-UAUz8TvSA"
}
