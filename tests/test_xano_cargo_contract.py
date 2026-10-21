import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class XanoCargoContractTests(unittest.TestCase):
    def test_seed_contains_unique_active_initial_cargos(self):
        table_script = (
            ROOT / "xano/table/farmacia_final_cargo.xs"
        ).read_text(encoding="utf-8")
        seed_block = table_script.split("items = [", maxsplit=1)[1].split(
            "\n  ]", maxsplit=1
        )[0]
        cargos = re.findall(r'\{id: \d+, nome: "([^"]+)", ativo: true\}', seed_block)

        self.assertEqual(
            set(cargos),
            {
                "Atendente",
                "Farmac\u00eautico",
                "Gerente",
                "Repositor",
                "Caixa",
                "Estagi\u00e1rio",
            },
        )
        self.assertEqual(len(cargos), 6)

    def test_cargo_table_has_unique_name_and_active_default(self):
        table_script = (ROOT / "xano/table/farmacia_final_cargo.xs").read_text()

        self.assertIn("text nome filters=trim", table_script)
        self.assertIn("bool ativo?=true", table_script)
        self.assertIn('type: "btree|unique", field: [{name: "nome"', table_script)

    def test_public_cargo_endpoint_returns_only_active_id_and_name(self):
        api_script = (
            ROOT / "xano/api/farmacia/farmacia_final/cargos_GET.xs"
        ).read_text()

        self.assertNotIn("auth =", api_script)
        self.assertIn("where = $db.farmacia_final_cargo.ativo == true", api_script)
        self.assertIn('sort = {nome: "asc"}', api_script)
        self.assertIn("cargos: $cargos|map:{id: $$.id, nome: $$.nome}", api_script)
        self.assertNotIn("ativo: $$.ativo", api_script)

    def test_signup_rejects_missing_unknown_or_inactive_cargo_before_insert(self):
        api_script = (
            ROOT / "xano/api/farmacia/farmacia_final/funcionarios_POST.xs"
        ).read_text()

        required_cargo = api_script.index(
            "precondition (($input.cargo|strlen) > 0)"
        )
        cargo_lookup = api_script.index("db.get farmacia_final_cargo")
        cargo_validation = api_script.index(
            "precondition (($cargo != null) && ($cargo.ativo == true))"
        )
        employee_insert = api_script.index("db.add farmacia_final_funcionario")

        self.assertLess(required_cargo, cargo_lookup)
        self.assertLess(cargo_lookup, cargo_validation)
        self.assertLess(cargo_validation, employee_insert)
        self.assertIn("CARGO_INVALIDO: selecione um cargo", api_script)
        self.assertIn("ativo: true", api_script)


if __name__ == "__main__":
    unittest.main()
