import reflex as rx


class DashboardState(rx.State):
    vendas_hoje: str = "R$ 238,10"
    vendas_hoje_contexto: str = "3 Vendas Realizadas"
    vendas_semana: str = "R$ 857,12"
    vendas_semana_contexto: str = "Acumulado dos 7 dias"
    vendas_mes: str = "R$ 2.894,00"
    vendas_mes_contexto: str = "Meta mensal atingida em 68%"
    itens_estoque: str = "647"
    itens_estoque_contexto: str = "9 produtos cadastrados"

    @rx.event
    def load_dashboard(self) -> None:
        return None
