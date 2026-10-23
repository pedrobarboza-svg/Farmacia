import unittest
from pathlib import Path

from farmaciaFinal.auth_state import AuthState


ROOT = Path(__file__).resolve().parents[1]


class DashboardTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.source = (ROOT / "farmaciaFinal/farmaciaFinal.py").read_text(
            encoding="utf-8"
        )

    def test_dashboard_contains_protected_navigation_and_logout(self):
        for label, route in (
            ("Visão Geral", "/dashboard"),
            ("Gestão de Estoque", "/estoque"),
            ("Vendas", "/vendas"),
            ("Categorias", "/categorias"),
            ("Funcionários", "/funcionarios"),
            ("Configurações", "/configuracoes"),
        ):
            self.assertIn(label, self.source)
            self.assertIn(f'"{route}"', self.source)
        self.assertIn("on_click=AuthState.logout", self.source)
        self.assertIn("on_load=AuthState.require_auth", self.source)

    def test_dashboard_contains_requested_metrics_and_actions(self):
        for text in (
            "Vendas Hoje",
            "Esta Semana",
            "Este Mês",
            "Itens Estoque",
            "Vendas por Categorias",
            "Modificações Rápidas",
            "Promoções",
            "Alterar Horário",
            "Avisos",
            "Pausar Loja",
            "Nova Venda",
        ):
            self.assertIn(text, self.source)

    def test_dashboard_uses_logged_in_employee_identity(self):
        self.assertIn("AuthState.employee_name", self.source)
        self.assertIn("AuthState.employee_cargo", self.source)

    def test_sidebar_uses_official_logo_asset(self):
        self.assertIn('src="/logofarmacia.png"', self.source)
        self.assertIn('alt="DROGA-NONIMO"', self.source)

    def test_dashboard_uses_figma_corner_rounding(self):
        self.assertIn('border_radius="9999px"', self.source)
        self.assertIn('border_radius="32px"', self.source)
        self.assertIn('border_radius="32px 0 0 32px"', self.source)


if __name__ == "__main__":
    unittest.main()
