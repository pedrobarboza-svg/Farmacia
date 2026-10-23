import logging
import re
import time
from typing import Any

import reflex as rx

from farmaciaFinal import xano_client

logger = logging.getLogger(__name__)
TOKEN_TTL_SECONDS = 24 * 60 * 60
EMAIL_PATTERN = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")


def login_error_message(status_code: int) -> str:
    if status_code == 401:
        return "E-mail ou senha inválidos."
    if status_code == 400:
        return "Confira o e-mail e a senha informados."
    return "Não foi possível entrar. Tente novamente."


def registration_error_message(status_code: int) -> str:
    if status_code == 400:
        return (
            "Não foi possível cadastrar. Confira os dados, selecione um cargo "
            "disponível e verifique se o e-mail já está em uso."
        )
    return "Não foi possível cadastrar o funcionário. Tente novamente."


class AuthState(rx.State):
    login_email: str = ""
    registration_nome: str = ""
    registration_email: str = ""
    registration_cargo: str = ""
    registration_cargos: list[str] = []
    is_loading_cargos: bool = False
    cargo_load_message: str = ""
    message: str = ""
    message_is_error: bool = False
    is_submitting: bool = False
    employee_name: str = ""
    employee_email: str = ""
    employee_cargo: str = ""
    language: str = "pt"
    _auth_token: str = rx.Cookie(
        name="authToken",
        max_age=TOKEN_TTL_SECONDS,
        same_site="lax",
    )
    _token_expires_at: float = 0.0

    @rx.var
    def is_authenticated(self) -> bool:
        return self._session_is_valid()

    @rx.var
    def registration_cargo_select_disabled(self) -> bool:
        return self.is_loading_cargos or not self.registration_cargos

    @rx.var
    def registration_submit_disabled(self) -> bool:
        return (
            self.is_submitting
            or self.is_loading_cargos
            or not self.registration_cargos
        )

    def _session_is_valid(self) -> bool:
        return bool(self._auth_token) and (
            self._token_expires_at == 0 or time.time() < self._token_expires_at
        )

    def _clear_session(self) -> None:
        self._auth_token = ""
        self._token_expires_at = 0
        self.employee_name = ""
        self.employee_email = ""
        self.employee_cargo = ""

    @rx.event
    def set_login_email(self, value: str) -> None:
        self.login_email = value

    @rx.event
    def set_language(self, value: str) -> None:
        self.language = "en" if value == "en" else "pt"

    @rx.event
    def set_registration_nome(self, value: str) -> None:
        self.registration_nome = value

    @rx.event
    def set_registration_email(self, value: str) -> None:
        self.registration_email = value

    @rx.event
    def set_registration_cargo(self, value: str) -> None:
        self.registration_cargo = value if value in self.registration_cargos else ""

    @rx.event
    async def load_cargos(self):
        self.registration_cargos = []
        self.registration_cargo = ""
        self.is_loading_cargos = True
        self.cargo_load_message = ""
        try:
            cargos = await xano_client.get_cargos()
        except xano_client.XanoAPIError as error:
            logger.warning("Xano cargo list returned HTTP %s.", error.status_code)
            self.cargo_load_message = (
                "Unable to load roles. Please try again later."
                if self.language == "en"
                else "Não foi possível carregar os cargos. Tente novamente mais tarde."
            )
        except xano_client.XanoClientError as error:
            logger.warning("Xano cargo list failed: %s.", type(error).__name__)
            self.cargo_load_message = (
                "Unable to load roles. Please try again later."
                if self.language == "en"
                else "Não foi possível carregar os cargos. Tente novamente mais tarde."
            )
        else:
            self.registration_cargos = cargos
            if not cargos:
                self.cargo_load_message = (
                    "No roles are available at this time."
                    if self.language == "en"
                    else "Nenhum cargo está disponível no momento."
                )
        finally:
            self.is_loading_cargos = False

    @rx.event
    def require_auth(self):
        if not self._session_is_valid():
            if self._auth_token:
                self._clear_session()
                self.message = "Sua sessão expirou. Entre novamente."
            else:
                self.message = "Entre para acessar esta página."
            self.message_is_error = True
            return rx.redirect("/login")

    @rx.event
    def redirect_authenticated(self):
        if self._session_is_valid():
            return rx.redirect("/dashboard")
        if self._auth_token:
            self._clear_session()
            self.message = "Sua sessão expirou. Entre novamente."
            self.message_is_error = True

    @rx.event
    async def login(self, form_data: dict[str, Any]):
        if self.is_submitting:
            return
        email_value = form_data.get("email", "")
        senha_value = form_data.get("senha", "")
        email = email_value.strip() if isinstance(email_value, str) else ""
        senha = senha_value if isinstance(senha_value, str) else ""
        if not email or not senha:
            self.message = (
                "Enter your email and password."
                if self.language == "en"
                else "Informe e-mail e senha."
            )
            self.message_is_error = True
            return
        if not EMAIL_PATTERN.fullmatch(email):
            self.message = (
                "Enter a valid email address."
                if self.language == "en"
                else "Informe um e-mail válido."
            )
            self.message_is_error = True
            return

        self.is_submitting = True
        self.message = ""
        try:
            result = await xano_client.login(email, senha)
        except xano_client.XanoAPIError as error:
            logger.warning("Xano login returned HTTP %s.", error.status_code)
            self.message = (
                {
                    401: "Invalid email or password.",
                    400: "Check the email and password you entered.",
                }.get(error.status_code, "Unable to sign in. Please try again.")
                if self.language == "en"
                else login_error_message(error.status_code)
            )
            self.message_is_error = True
        except xano_client.XanoClientError as error:
            logger.warning("Xano login failed: %s.", type(error).__name__)
            self.message = (
                "Unable to connect to the service. Please try again."
                if self.language == "en"
                else "Não foi possível conectar ao serviço. Tente novamente."
            )
            self.message_is_error = True
        else:
            self._auth_token = result.token
            self._token_expires_at = time.time() + TOKEN_TTL_SECONDS
            self.employee_name = result.employee.nome
            self.employee_email = result.employee.email
            self.employee_cargo = result.employee.cargo or ""
            self.message = ""
            self.message_is_error = False
            return rx.redirect("/dashboard")
        finally:
            self.is_submitting = False

    @rx.event
    async def register_employee(self, form_data: dict[str, Any]):
        if self.is_submitting:
            return

        nome_value = form_data.get("nome", "")
        email_value = form_data.get("email", "")
        senha_value = form_data.get("senha", "")
        cargo_value = form_data.get("cargo", "")
        nome = nome_value.strip() if isinstance(nome_value, str) else ""
        email = email_value.strip() if isinstance(email_value, str) else ""
        senha = senha_value if isinstance(senha_value, str) else ""
        cargo = cargo_value.strip() if isinstance(cargo_value, str) else ""
        if not nome or not email or not senha or not cargo:
            self.message = "Preencha todos os campos."
            self.message_is_error = True
            return
        if cargo not in self.registration_cargos:
            self.message = "Selecione um cargo disponível."
            self.message_is_error = True
            return

        self.is_submitting = True
        self.message = ""
        try:
            employee = await xano_client.register_employee(
                nome=nome,
                email=email,
                senha=senha,
                cargo=cargo,
            )
        except xano_client.XanoAPIError as error:
            logger.warning("Xano employee registration returned HTTP %s.", error.status_code)
            if error.status_code == 401:
                self._clear_session()
                self.message = "Sua sessão expirou. Entre novamente."
                self.message_is_error = True
                return rx.redirect("/login")
            self.message = registration_error_message(error.status_code)
            self.message_is_error = True
        except xano_client.XanoClientError as error:
            logger.warning("Xano employee registration failed: %s.", type(error).__name__)
            self.message = "Não foi possível conectar ao serviço. Tente novamente."
            self.message_is_error = True
        else:
            self.registration_nome = ""
            self.registration_email = ""
            self.registration_cargo = ""
            self.message = f"Funcionário {employee.nome} cadastrado com sucesso."
            self.message_is_error = False
        finally:
            self.is_submitting = False

    @rx.event
    def logout(self):
        self._clear_session()
        self.message = ""
        self.message_is_error = False
        return rx.redirect("/login")
