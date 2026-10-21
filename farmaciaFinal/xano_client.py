import os
from dataclasses import dataclass
from typing import Any
from urllib.parse import urlsplit

import httpx

XANO_API_GROUP_PATH = "/api:hVU-wK41"
DEFAULT_XANO_API_BASE_URL = f"https://x8ki-letl-twmt.n7.xano.io{XANO_API_GROUP_PATH}"


class XanoClientError(Exception):
    pass


class XanoConfigurationError(XanoClientError):
    pass


class XanoUnavailableError(XanoClientError):
    pass


class XanoAPIError(XanoClientError):
    def __init__(self, status_code: int):
        self.status_code = status_code
        super().__init__(f"Xano returned HTTP {status_code}.")


class XanoProtocolError(XanoClientError):
    pass


@dataclass(frozen=True)
class Employee:
    id: int
    nome: str
    email: str
    cargo: str | None = None


@dataclass(frozen=True)
class LoginResult:
    token: str
    employee: Employee


def _api_base_url() -> str:
    value = os.environ.get("XANO_API_BASE_URL", DEFAULT_XANO_API_BASE_URL).strip().rstrip("/")

    parsed = urlsplit(value)
    if parsed.scheme not in {"https", "http"} or not parsed.netloc or parsed.query or parsed.fragment:
        raise XanoConfigurationError("XANO_API_BASE_URL must be an absolute HTTP URL without query or fragment.")
    if parsed.scheme != "https" and parsed.hostname not in {"localhost", "127.0.0.1", "::1"}:
        raise XanoConfigurationError("XANO_API_BASE_URL must use HTTPS.")

    if parsed.path.rstrip("/") in {"", "/"}:
        return f"{parsed.scheme}://{parsed.netloc}{XANO_API_GROUP_PATH}"
    if parsed.path.rstrip("/").endswith(XANO_API_GROUP_PATH):
        return value
    raise XanoConfigurationError(
        f"XANO_API_BASE_URL must include the Xano API group path {XANO_API_GROUP_PATH}."
    )


def _employee_from(payload: Any, *, require_cargo: bool) -> Employee:
    if not isinstance(payload, dict):
        raise XanoProtocolError("Xano returned an invalid employee.")

    employee_id = payload.get("id")
    nome = payload.get("nome")
    email = payload.get("email")
    cargo = payload.get("cargo")

    if type(employee_id) is not int or not isinstance(nome, str) or not isinstance(email, str):
        raise XanoProtocolError("Xano returned an invalid employee.")
    if require_cargo and (not isinstance(cargo, str) or not cargo.strip()):
        raise XanoProtocolError("Xano returned an invalid employee.")

    return Employee(
        id=employee_id,
        nome=nome,
        email=email,
        cargo=cargo if isinstance(cargo, str) else None,
    )


async def _request(
    method: str,
    path: str,
    *,
    payload: dict[str, Any],
    token: str | None = None,
    transport: httpx.AsyncBaseTransport | None = None,
) -> dict[str, Any]:
    headers = {"Accept": "application/json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"

    try:
        async with httpx.AsyncClient(
            timeout=httpx.Timeout(10.0, connect=3.0),
            transport=transport,
        ) as client:
            response = await client.request(
                method,
                f"{_api_base_url()}/{path.lstrip('/')}",
                json=payload,
                headers=headers,
            )
    except httpx.TimeoutException as exc:
        raise XanoUnavailableError("Xano request timed out.") from exc
    except httpx.RequestError as exc:
        raise XanoUnavailableError("Xano is unavailable.") from exc

    if not response.is_success:
        raise XanoAPIError(response.status_code)

    try:
        result = response.json()
    except ValueError as exc:
        raise XanoProtocolError("Xano returned an invalid response.") from exc

    if not isinstance(result, dict):
        raise XanoProtocolError("Xano returned an invalid response.")
    return result


async def login(
    email: str,
    senha: str,
    *,
    transport: httpx.AsyncBaseTransport | None = None,
) -> LoginResult:
    response = await _request(
        "POST",
        "/farmacia-final/auth/login",
        payload={"email": email.strip().lower(), "senha": senha},
        transport=transport,
    )
    token = response.get("authToken")
    if not isinstance(token, str) or not token:
        raise XanoProtocolError("Xano returned an invalid login response.")
    employee = _employee_from(response.get("funcionario"), require_cargo=False)
    return LoginResult(token=token, employee=employee)


async def register_employee(
    token: str,
    *,
    nome: str,
    email: str,
    senha: str,
    cargo: str,
    transport: httpx.AsyncBaseTransport | None = None,
) -> Employee:
    response = await _request(
        "POST",
        "/farmacia-final/funcionarios",
        payload={
            "nome": nome.strip(),
            "email": email.strip().lower(),
            "senha": senha,
            "cargo": cargo.strip(),
        },
        token=token,
        transport=transport,
    )
    return _employee_from(response, require_cargo=True)
