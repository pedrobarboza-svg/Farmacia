import inspect
import unittest
from pathlib import Path

from farmaciaFinal.auth_state import AuthState


ROOT = Path(__file__).resolve().parents[1]


class RegistrationCargoTests(unittest.TestCase):
    def test_registration_page_loads_backend_options_into_required_select(self):
        page_source = (ROOT / "farmaciaFinal/farmaciaFinal.py").read_text(
            encoding="utf-8"
        )

        self.assertIn(
            'app.add_page(register_page, route="/cadastro", on_load=AuthState.load_cargos)',
            page_source,
        )
        self.assertIn("rx.hstack(\n                            rx.center(", page_source)
        self.assertIn("rx.select(\n                                AuthState.registration_cargos,", page_source)
        self.assertIn('name="cargo"', page_source)
        self.assertIn("required=True", page_source)
        self.assertIn(
            "disabled=AuthState.registration_cargo_select_disabled",
            page_source,
        )
        self.assertIn(
            "disabled=AuthState.registration_submit_disabled",
            page_source,
        )
        self.assertIn('height="52px"', page_source)
        self.assertIn('width="44px"', page_source)
        self.assertIn('padding_left="12px"', page_source)
        self.assertIn('padding_right="14px"', page_source)
        self.assertIn('border="none"', page_source)
        self.assertIn('text_align="left"', page_source)
        self.assertIn('align_items="center"', page_source)
        self.assertIn('_placeholder={"color": "#8294AC"}', page_source)
        self.assertNotIn('rx.input(\n                                name="cargo"', page_source)

    def test_cargo_loader_handles_empty_and_failed_responses_without_fallback(self):
        loader_source = inspect.getsource(AuthState.load_cargos.fn)

        self.assertIn("await xano_client.get_cargos()", loader_source)
        self.assertIn("self.registration_cargos = []", loader_source)
        self.assertIn("self.is_loading_cargos = True", loader_source)
        self.assertIn("if not cargos:", loader_source)
        self.assertIn("XanoAPIError", loader_source)
        self.assertIn("XanoClientError", loader_source)
        self.assertNotIn("Atendente", loader_source)

    def test_registration_checks_selected_cargo_and_preserves_fields_on_failure(self):
        registration_source = inspect.getsource(AuthState.register_employee.fn)

        validation_position = registration_source.index(
            "if cargo not in self.registration_cargos:"
        )
        request_position = registration_source.index(
            "await xano_client.register_employee("
        )
        clear_position = registration_source.index('self.registration_nome = ""')

        self.assertLess(validation_position, request_position)
        self.assertLess(request_position, clear_position)
        self.assertIn("self.message = \"Selecione um cargo", registration_source)
        self.assertIn("self.registration_email = \"\"", registration_source)
        self.assertIn("self.registration_cargo = \"\"", registration_source)


if __name__ == "__main__":
    unittest.main()
