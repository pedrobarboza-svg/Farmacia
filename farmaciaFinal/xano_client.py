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


@dataclass(frozen=True)
class Category:
    id: int
    nome: str


@dataclass(frozen=True)
class Product:
    id: int
    categoria_id: int
    nome: str
    descricao: str
    preco: float
    estoque: int
    ativo: bool


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
    payload: dict[str, Any] | None = None,
    token: str | None = None,
    transport: httpx.AsyncBaseTransport | None = None,
) -> Any:
    headers = {"Accept": "application/json"}
    if token:
        headers.update({"Authorization": "Bearer " + token})

    try:
        async with httpx.AsyncClient(
            timeout=httpx.Timeout(10.0, connect=3.0),
            transport=transport,
        ) as client:
            request_options: dict[str, Any] = {"headers": headers}
            if payload is not None:
                request_options["json"] = payload
            response = await client.request(
                method,
                f"{_api_base_url()}/{path.lstrip('/')}",
                **request_options,
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

    return result


def _product_from(payload: Any) -> Product:
    if not isinstance(payload, dict):
        raise XanoProtocolError("Xano returned an invalid product.")
    product_id = payload.get("id")
    category_id = payload.get("categoria_id")
    nome = payload.get("nome")
    descricao = payload.get("descricao", "")
    preco = payload.get("preco")
    estoque = payload.get("estoque")
    ativo = payload.get("ativo", True)
    if (
        type(product_id) is not int
        or type(category_id) is not int
        or not isinstance(nome, str)
        or not isinstance(descricao, str)
        or not isinstance(preco, (int, float))
        or isinstance(preco, bool)
        or type(estoque) is not int
        or not isinstance(ativo, bool)
    ):
        raise XanoProtocolError("Xano returned an invalid product.")
    return Product(
        id=product_id,
        categoria_id=category_id,
        nome=nome,
        descricao=descricao,
        preco=float(preco),
        estoque=estoque,
        ativo=ativo,
    )


async def get_categories(
    *,
    token: str,
    transport: httpx.AsyncBaseTransport | None = None,
) -> list[Category]:
    response = await _request(
        "GET", "/farmacia-final/categorias", token=token, transport=transport
    )
    if not isinstance(response, list):
        raise XanoProtocolError("Xano returned an invalid category list.")
    categories: list[Category] = []
    for record in response:
        if (
            not isinstance(record, dict)
            or type(record.get("id")) is not int
            or not isinstance(record.get("nome"), str)
            or not record["nome"].strip()
        ):
            raise XanoProtocolError("Xano returned an invalid category list.")
        categories.append(Category(id=record["id"], nome=record["nome"].strip()))
    return categories


async def get_products(
    *,
    token: str,
    category_id: int | None = None,
    transport: httpx.AsyncBaseTransport | None = None,
) -> list[Product]:
    path = "/farmacia-final/produtos"
    if category_id is not None:
        path += f"?categoria_id={category_id}"
    response = await _request("GET", path, token=token, transport=transport)
    if not isinstance(response, list):
        raise XanoProtocolError("Xano returned an invalid product list.")
    return [_product_from(record) for record in response]


async def create_product(
    *,
    token: str,
    nome: str,
    descricao: str,
    preco: float,
    estoque: int,
    categoria_id: int,
    transport: httpx.AsyncBaseTransport | None = None,
) -> Product:
    response = await _request(
        "POST",
        "/farmacia-final/produtos",
        token=token,
        payload={
            "nome": nome.strip(),
            "descricao": descricao.strip(),
            "preco": preco,
            "estoque": estoque,
            "categoria_id": categoria_id,
        },
        transport=transport,
    )
    return _product_from(response)


async def update_product(
    *,
    token: str,
    product_id: int,
    nome: str,
    descricao: str,
    preco: float,
    estoque: int,
    categoria_id: int,
    ativo: bool = True,
    transport: httpx.AsyncBaseTransport | None = None,
) -> Product:
    response = await _request(
        "PATCH",
        f"/farmacia-final/produtos/{product_id}",
        token=token,
        payload={
            "nome": nome.strip(),
            "descricao": descricao.strip(),
            "preco": preco,
            "estoque": estoque,
            "categoria_id": categoria_id,
            "ativo": ativo,
        },
        transport=transport,
    )
    return _product_from(response)


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


async def get_cargos(
    *,
    transport: httpx.AsyncBaseTransport | None = None,
) -> list[str]:
    response = await _request(
        "GET",
        "/farmacia-final/cargos",
        transport=transport,
    )
    records = response.get("cargos")
    if not isinstance(records, list):
        raise XanoProtocolError("Xano returned an invalid cargo list.")

    cargos: list[str] = []
    seen: set[str] = set()
    for record in records:
        if not isinstance(record, dict):
            raise XanoProtocolError("Xano returned an invalid cargo list.")
        cargo_id = record.get("id")
        nome = record.get("nome")
        if type(cargo_id) is not int or not isinstance(nome, str) or not nome.strip():
            raise XanoProtocolError("Xano returned an invalid cargo list.")
        normalized_nome = nome.strip()
        if normalized_nome in seen:
            raise XanoProtocolError("Xano returned duplicate cargos.")
        seen.add(normalized_nome)
        cargos.append(normalized_nome)
    return cargos


async def register_employee(
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
        transport=transport,
    )
    return _employee_from(response, require_cargo=True)
