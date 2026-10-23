import json
import os
import unittest
from unittest.mock import patch

import httpx

from farmaciaFinal import xano_client


class XanoClientTests(unittest.IsolatedAsyncioTestCase):
    async def test_get_cargos_uses_public_endpoint_and_parses_options(self):
        observed = {}

        def respond(request: httpx.Request) -> httpx.Response:
            observed["request"] = request
            return httpx.Response(
                200,
                json={
                    "cargos": [
                        {"id": 1, "nome": "Atendente"},
                        {"id": 2, "nome": "Farmac\u00eautico"},
                    ]
                },
            )

        with patch.dict(
            os.environ,
            {
                "XANO_API_BASE_URL":
                    "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41"
            },
        ):
            cargos = await xano_client.get_cargos(
                transport=httpx.MockTransport(respond),
            )

        request = observed["request"]
        self.assertEqual(request.method, "GET")
        self.assertNotIn("Authorization", request.headers)
        self.assertEqual(request.content, b"")
        self.assertEqual(
            str(request.url),
            "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41/"
            "farmacia-final/cargos",
        )
        self.assertEqual(cargos, ["Atendente", "Farmac\u00eautico"])

    async def test_get_cargos_accepts_empty_list_for_ui_empty_state(self):
        with patch.dict(
            os.environ,
            {
                "XANO_API_BASE_URL":
                    "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41"
            },
        ):
            cargos = await xano_client.get_cargos(
                transport=httpx.MockTransport(
                    lambda request: httpx.Response(200, json={"cargos": []})
                ),
            )

        self.assertEqual(cargos, [])

    async def test_get_cargos_rejects_invalid_records_and_duplicate_names(self):
        invalid_responses = [
            {"cargos": [{"id": "1", "nome": "Atendente"}]},
            {"cargos": [{"id": 1, "nome": " "}]},
            {
                "cargos": [
                    {"id": 1, "nome": "Atendente"},
                    {"id": 2, "nome": "Atendente"},
                ]
            },
        ]
        for body in invalid_responses:
            with self.subTest(body=body), patch.dict(
                os.environ,
                {
                    "XANO_API_BASE_URL":
                        "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41"
                },
            ):
                with self.assertRaises(xano_client.XanoProtocolError):
                    await xano_client.get_cargos(
                        transport=httpx.MockTransport(
                            lambda request, payload=body: httpx.Response(
                                200,
                                json=payload,
                            )
                        ),
                    )

    async def test_get_cargos_surfaces_http_and_network_errors(self):
        with patch.dict(
            os.environ,
            {
                "XANO_API_BASE_URL":
                    "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41"
            },
        ):
            with self.assertRaises(xano_client.XanoAPIError) as http_error:
                await xano_client.get_cargos(
                    transport=httpx.MockTransport(
                        lambda request: httpx.Response(503, json={"secret": "hidden"})
                    ),
                )
            self.assertEqual(http_error.exception.status_code, 503)
            self.assertNotIn("hidden", str(http_error.exception))

            with self.assertRaises(xano_client.XanoUnavailableError):
                await xano_client.get_cargos(
                    transport=httpx.MockTransport(
                        lambda request: (_ for _ in ()).throw(
                            httpx.ConnectError("network failure")
                        )
                    ),
                )

    async def test_login_sends_normalized_credentials_and_parses_legacy_employee(self):
        observed = {}

        def respond(request: httpx.Request) -> httpx.Response:
            observed["request"] = request
            return httpx.Response(
                200,
                json={
                    "authToken": "private-token",
                    "funcionario": {
                        "id": 4,
                        "nome": "Ana",
                        "email": "ana@example.com",
                    },
                },
            )

        with patch.dict(
            os.environ,
            {
                "XANO_API_BASE_URL":
                    "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41"
            },
        ):
            result = await xano_client.login(
                " Ana@Example.com ",
                "password",
                transport=httpx.MockTransport(respond),
            )

        request = observed["request"]
        self.assertEqual(request.method, "POST")
        self.assertEqual(
            str(request.url),
            "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41/"
            "farmacia-final/auth/login",
        )
        self.assertEqual(
            request.read(),
            b'{"email":"ana@example.com","senha":"password"}',
        )
        self.assertEqual(result.token, "private-token")
        self.assertIsNone(result.employee.cargo)

    async def test_public_registration_sends_no_authentication_or_active_flag(self):
        observed = {}

        def respond(request: httpx.Request) -> httpx.Response:
            observed["request"] = request
            return httpx.Response(
                200,
                json={
                    "id": 10,
                    "nome": "João",
                    "email": "joao@example.com",
                    "cargo": "Atendente",
                    "ativo": True,
                },
            )

        with patch.dict(
            os.environ,
            {
                "XANO_API_BASE_URL":
                    "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41"
            },
        ):
            employee = await xano_client.register_employee(
                nome=" João ",
                email="JOAO@example.com",
                senha="new-password",
                cargo=" Atendente ",
                transport=httpx.MockTransport(respond),
            )

        request = observed["request"]
        self.assertEqual(request.method, "POST")
        self.assertNotIn("Authorization", request.headers)
        self.assertEqual(
            str(request.url),
            "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41/"
            "farmacia-final/funcionarios",
        )
        self.assertEqual(
            json.loads(request.read()),
            {
                "nome": "João",
                "email": "joao@example.com",
                "senha": "new-password",
                "cargo": "Atendente",
            },
        )
        self.assertTrue(observed["request"].headers["Accept"].startswith("application/json"))
        self.assertEqual(employee.cargo, "Atendente")

    async def test_products_use_bearer_auth_and_parse_list_response(self):
        observed = {}

        def respond(request: httpx.Request) -> httpx.Response:
            observed["request"] = request
            return httpx.Response(
                200,
                json=[
                    {
                        "id": 4,
                        "categoria_id": 2,
                        "nome": "Paracetamol",
                        "descricao": "",
                        "preco": 12.9,
                        "estoque": 10,
                        "ativo": True,
                    }
                ],
            )

        products = await xano_client.get_products(
            token="private-token",
            transport=httpx.MockTransport(respond),
        )

        self.assertEqual(products[0].nome, "Paracetamol")
        self.assertEqual(observed["request"].headers["Authorization"], "Bearer private-token")
        self.assertEqual(observed["request"].method, "GET")

    async def test_create_product_sends_expected_payload(self):
        observed = {}

        def respond(request: httpx.Request) -> httpx.Response:
            observed["request"] = request
            return httpx.Response(
                200,
                json={
                    "id": 8,
                    "categoria_id": 3,
                    "nome": "Vitamina C",
                    "descricao": "500mg",
                    "preco": 19.9,
                    "estoque": 25,
                    "ativo": True,
                },
            )

        product = await xano_client.create_product(
            token="private-token",
            nome=" Vitamina C ",
            descricao=" 500mg ",
            preco=19.9,
            estoque=25,
            categoria_id=3,
            transport=httpx.MockTransport(respond),
        )

        self.assertEqual(product.id, 8)
        self.assertEqual(json.loads(observed["request"].read()), {
            "nome": "Vitamina C",
            "descricao": "500mg",
            "preco": 19.9,
            "estoque": 25,
            "categoria_id": 3,
        })
        self.assertEqual(observed["request"].method, "POST")

    async def test_default_base_url_uses_farmacia_api_group(self):
        with patch.dict(os.environ, {}, clear=True):
            with self.assertRaises(xano_client.XanoProtocolError):
                await xano_client.login(
                    "ana@example.com",
                    "password",
                    transport=httpx.MockTransport(
                        self._verify_default_url
                    ),
                )

    @staticmethod
    def _verify_default_url(request: httpx.Request) -> httpx.Response:
        if str(request.url) != (
            "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41/"
            "farmacia-final/auth/login"
        ):
            raise AssertionError(f"Unexpected Xano API URL: {request.url}")
        return httpx.Response(200, json={})

    async def test_instance_root_gets_farmacia_api_group_path(self):
        observed = {}

        def respond(request: httpx.Request) -> httpx.Response:
            observed["url"] = str(request.url)
            return httpx.Response(
                200,
                json={
                    "authToken": "private-token",
                    "funcionario": {
                        "id": 4,
                        "nome": "Ana",
                        "email": "ana@example.com",
                    },
                },
            )

        with patch.dict(
            os.environ,
            {"XANO_API_BASE_URL": "https://x8ki-letl-twmt.n7.xano.io"},
        ):
            await xano_client.login(
                "ana@example.com",
                "password",
                transport=httpx.MockTransport(respond),
            )

        self.assertEqual(
            observed["url"],
            "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41/"
            "farmacia-final/auth/login",
        )

    async def test_base_url_without_the_farmacia_api_group_is_rejected(self):
        with patch.dict(
            os.environ,
            {"XANO_API_BASE_URL": "https://xano.example.com/api:other-group"},
        ):
            with self.assertRaises(xano_client.XanoConfigurationError):
                await xano_client.login(
                    "ana@example.com",
                    "password",
                    transport=httpx.MockTransport(
                        lambda request: httpx.Response(200, json={})
                    ),
                )

    async def test_http_error_does_not_expose_response_body_or_credentials(self):
        secret_body = "password private-token internal stack trace"

        def respond(request: httpx.Request) -> httpx.Response:
            return httpx.Response(400, json={"message": secret_body})

        with patch.dict(
            os.environ,
            {
                "XANO_API_BASE_URL":
                    "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41"
            },
        ):
            with self.assertRaises(xano_client.XanoAPIError) as caught:
                await xano_client.register_employee(
                    nome="Ana",
                    email="ana@example.com",
                    senha="password",
                    cargo="Atendente",
                    transport=httpx.MockTransport(respond),
                )

        self.assertEqual(caught.exception.status_code, 400)
        self.assertNotIn(secret_body, str(caught.exception))

    async def test_timeout_is_reported_without_raw_request_details(self):
        def respond(request: httpx.Request) -> httpx.Response:
            raise httpx.ReadTimeout("private-token in raw error")

        with patch.dict(
            os.environ,
            {
                "XANO_API_BASE_URL":
                    "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41"
            },
        ):
            with self.assertRaises(xano_client.XanoUnavailableError) as caught:
                await xano_client.login(
                    "ana@example.com",
                    "password",
                    transport=httpx.MockTransport(respond),
                )

        self.assertNotIn("private-token", str(caught.exception))

    async def test_invalid_success_response_is_not_treated_as_success(self):
        with patch.dict(
            os.environ,
            {
                "XANO_API_BASE_URL":
                    "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41"
            },
        ):
            with self.assertRaises(xano_client.XanoProtocolError):
                await xano_client.login(
                    "ana@example.com",
                    "password",
                    transport=httpx.MockTransport(
                        lambda request: httpx.Response(200, text="not-json")
                    ),
                )


if __name__ == "__main__":
    unittest.main()
