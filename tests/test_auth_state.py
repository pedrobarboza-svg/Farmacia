import unittest

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
            "Não foi possível cadastrar. Confira os dados e se o e-mail já está em uso.",
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


if __name__ == "__main__":
    unittest.main()
