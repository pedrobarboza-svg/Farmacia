import json
import os
import unittest
from unittest.mock import patch

import httpx

from farmaciaFinal import xano_client


class XanoClientTests(unittest.IsolatedAsyncioTestCase):
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

    async def test_registration_sends_token_and_cargo(self):
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
                "private-token",
                nome=" João ",
                email="JOAO@example.com",
                senha="new-password",
                cargo=" Atendente ",
                transport=httpx.MockTransport(respond),
            )

        request = observed["request"]
        self.assertEqual(request.method, "POST")
        self.assertEqual(
            request.headers["Authorization"],
            "Bearer private-token",
        )
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
        self.assertEqual(employee.cargo, "Atendente")

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
            return httpx.Response(401, json={"message": secret_body})

        with patch.dict(
            os.environ,
            {
                "XANO_API_BASE_URL":
                    "https://x8ki-letl-twmt.n7.xano.io/api:hVU-wK41"
            },
        ):
            with self.assertRaises(xano_client.XanoAPIError) as caught:
                await xano_client.register_employee(
                    "private-token",
                    nome="Ana",
                    email="ana@example.com",
                    senha="password",
                    cargo="Atendente",
                    transport=httpx.MockTransport(respond),
                )

        self.assertEqual(caught.exception.status_code, 401)
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
