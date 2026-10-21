import inspect
import unittest

from farmaciaFinal import xano_client
from farmaciaFinal.auth_state import (
    AuthState,
    login_error_message,
    registration_error_message,
)


class AuthStateTests(unittest.TestCase):
    def test_login_language_defaults_to_brazilian_portuguese(self):
        self.assertEqual(AuthState.__fields__["language"].default, "pt")

    def test_api_errors_have_safe_user_messages(self):
        self.assertEqual(login_error_message(401), "E-mail ou senha inválidos.")
        self.assertEqual(
            registration_error_message(400),
            (
                "Não foi possível cadastrar. Confira os dados, selecione um cargo "
                "dispon\u00edvel e verifique se o e-mail já está em uso."
            ),
        )
        self.assertNotIn("token", login_error_message(500).lower())
        self.assertNotIn("token", registration_error_message(500).lower())

    def test_unexpected_login_errors_are_generic(self):
        self.assertEqual(
            login_error_message(500),
            "Não foi possível entrar. Tente novamente.",
        )

    def test_authentication_token_is_a_private_backend_only_var(self):
        self.assertIn("_auth_token", AuthState.__fields__)
        self.assertNotIn("auth_token", AuthState.__fields__)

    def test_public_registration_does_not_require_a_session_token(self):
        self.assertNotIn("token", inspect.signature(xano_client.register_employee).parameters)
        handler_source = inspect.getsource(AuthState.register_employee.fn)
        self.assertNotIn("_session_is_valid", handler_source)
        self.assertNotIn("_auth_token", handler_source)


if __name__ == "__main__":
    unittest.main()
