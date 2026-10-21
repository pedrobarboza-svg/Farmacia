import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class XanoEmployeeContractTests(unittest.TestCase):
    def test_cargo_is_optional_for_existing_employee_records(self):
        table_script = (ROOT / "xano/table/farmacia_final_funcionario.xs").read_text()

        self.assertIn("text cargo? filters=trim", table_script)

    def test_public_signup_requires_cargo_but_not_auth_or_client_active_flag(self):
        api_script = (
            ROOT / "xano/api/farmacia/farmacia_final/funcionarios_POST.xs"
        ).read_text()

        self.assertNotIn('auth = "farmacia_final_funcionario"', api_script)
        self.assertIn('auth = ""', api_script)
        self.assertIn("text cargo filters=trim", api_script)
        self.assertIn("precondition (($input.cargo|strlen) > 0)", api_script)
        self.assertIn("precondition (($input.senha|strlen) > 0)", api_script)
        self.assertNotIn("bool ativo", api_script)
        self.assertIn("ativo: true", api_script)
        self.assertIn("field_name = \"email\"", api_script)
        self.assertIn("$existente == null", api_script)
        self.assertIn("cargo: $input.cargo", api_script)

    def test_provisioning_response_excludes_password_and_hash(self):
        api_script = (
            ROOT / "xano/api/farmacia/farmacia_final/funcionarios_POST.xs"
        ).read_text()
        response = api_script.split("response = {", maxsplit=1)[1]

        self.assertIn("cargo: $funcionario.cargo", response)
        self.assertIn("ativo: $funcionario.ativo", response)
        self.assertNotIn("senha:", response)
        self.assertNotIn("senha_hash:", response)
        self.assertNotIn("authToken:", response)

    def test_duplicate_registration_is_prevented_by_validation_and_unique_index(self):
        api_script = (
            ROOT / "xano/api/farmacia/farmacia_final/funcionarios_POST.xs"
        ).read_text()
        table_script = (ROOT / "xano/table/farmacia_final_funcionario.xs").read_text()

        self.assertIn("EMAIL_DUPLICADO", api_script)
        self.assertIn('type: "btree|unique"', table_script)

    def test_login_does_not_depend_on_optional_cargo(self):
        login_script = (
            ROOT / "xano/api/farmacia/farmacia_final/auth/login_POST.xs"
        ).read_text()

        self.assertIn("$funcionario.ativo == true", login_script)
        self.assertIn("security.check_password", login_script)
        self.assertNotIn("$funcionario.cargo", login_script)


if __name__ == "__main__":
    unittest.main()
