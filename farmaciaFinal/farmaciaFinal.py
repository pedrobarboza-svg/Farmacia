import reflex as rx

from farmaciaFinal.auth_state import AuthState


def _feedback() -> rx.Component:
    return rx.cond(
        AuthState.message != "",
        rx.text(
            AuthState.message,
            color=rx.cond(AuthState.message_is_error, "red", "green"),
            role="status",
        ),
        rx.fragment(),
    )


def _language_selector() -> rx.Component:
    return rx.select.root(
        rx.select.trigger(),
        rx.select.content(
            rx.select.group(
                rx.select.item("Português", value="pt"),
                rx.select.item("English", value="en"),
            ),
        ),
        value=AuthState.language,
        on_change=AuthState.set_language,
        name="language",
    )


def _brand_header() -> rx.Component:
    return rx.vstack(
        rx.center(
            rx.text(
                "+%",
                color="white",
                font_size="24px",
                font_weight="800",
                line_height="1",
            ),
            width="64px",
            height="64px",
            background="#2563EB",
            border_radius="18px",
            box_shadow="0 12px 32px rgba(37, 99, 235, 0.35)",
        ),
        rx.heading(
            "DROGA-NONIMO",
            size="8",
            color="#F8FAFC",
            text_align="center",
        ),
        rx.text(
            "Mais saúde para o seu dia a dia",
            color="#A9B8CC",
            size="4",
            text_align="center",
        ),
        spacing="3",
        align="center",
        width="100%",
    )


def index() -> rx.Component:
    return rx.cond(
        AuthState.is_authenticated,
        rx.container(
            rx.vstack(
                rx.heading("FarmáciaFinal", size="8"),
                rx.text("Bem-vindo, ", AuthState.employee_name),
                rx.cond(
                    AuthState.employee_cargo != "",
                    rx.text("Cargo: ", AuthState.employee_cargo),
                    rx.fragment(),
                ),
                rx.hstack(
                    rx.link(rx.button("Cadastrar funcionário"), href="/cadastro"),
                    rx.button("Sair", on_click=AuthState.logout),
                ),
                spacing="5",
                align="center",
                justify="center",
                min_height="85vh",
            ),
        ),
        rx.center(rx.spinner(), min_height="85vh"),
    )


def login_page() -> rx.Component:
    return rx.cond(
        AuthState.is_authenticated,
        rx.center(rx.spinner(), min_height="100vh"),
        rx.box(
            rx.hstack(
                rx.spacer(),
                _language_selector(),
                width="100%",
                justify="end",
            ),
            rx.vstack(
                _brand_header(),
                rx.card(
                    rx.form(
                        rx.vstack(
                            rx.heading(
                                rx.cond(
                                    AuthState.language == "en",
                                    "Sign in to your account",
                                    "Acesse sua conta",
                                ),
                                size="6",
                                color="#F8FAFC",
                                text_align="center",
                                width="100%",
                            ),
                            rx.text(
                                rx.cond(
                                    AuthState.language == "en",
                                    "Welcome back! Enter your email to continue",
                                    "Bem-vindo de volta! Entre com seu e-mail para continuar",
                                ),
                                color="#A9B8CC",
                                size="2",
                                text_align="center",
                                width="100%",
                            ),
                            rx.box(
                                rx.icon(
                                    tag="user_round",
                                    size=18,
                                    color="#8294AC",
                                    position="absolute",
                                    left="14px",
                                    top="50%",
                                    transform="translateY(-50%)",
                                ),
                                rx.input(
                                    name="email",
                                    type="email",
                                    placeholder=rx.cond(
                                        AuthState.language == "en",
                                        "Email address",
                                        "E-mail",
                                    ),
                                    value=AuthState.login_email,
                                    on_change=AuthState.set_login_email,
                                    required=True,
                                    width="100%",
                                    height="52px",
                                    padding_left="44px",
                                    background="#0A1728",
                                    border="1px solid #263A53",
                                    color="#F8FAFC",
                                    _placeholder={"color": "#8294AC"},
                                    _focus={"border_color": "#60A5FA"},
                                ),
                                position="relative",
                                width="100%",
                            ),
                            rx.box(
                                rx.icon(
                                    tag="lock_keyhole",
                                    size=18,
                                    color="#8294AC",
                                    position="absolute",
                                    left="14px",
                                    top="50%",
                                    transform="translateY(-50%)",
                                ),
                                rx.input(
                                    name="senha",
                                    type="password",
                                    placeholder=rx.cond(
                                        AuthState.language == "en",
                                        "Password",
                                        "Senha",
                                    ),
                                    required=True,
                                    width="100%",
                                    height="52px",
                                    padding_left="44px",
                                    background="#0A1728",
                                    border="1px solid #263A53",
                                    color="#F8FAFC",
                                    _placeholder={"color": "#8294AC"},
                                    _focus={"border_color": "#60A5FA"},
                                ),
                                position="relative",
                                width="100%",
                            ),
                            _feedback(),
                            rx.button(
                                rx.cond(
                                    AuthState.is_submitting,
                                    rx.cond(
                                        AuthState.language == "en",
                                        "Signing in...",
                                        "Entrando...",
                                    ),
                                    rx.cond(AuthState.language == "en", "Sign in", "Entrar"),
                                ),
                                type="submit",
                                disabled=AuthState.is_submitting,
                                width="100%",
                                height="52px",
                                background="#DBEAFE",
                                color="#102A4C",
                                font_weight="700",
                                _hover={"background": "#BFDBFE"},
                            ),
                            rx.link(
                                rx.cond(
                                    AuthState.language == "en",
                                    "Don't have an account? Sign up",
                                    "Não tem uma conta? Cadastre-se",
                                ),
                                href="/cadastro",
                                color="#93C5FD",
                                text_align="center",
                                _hover={
                                    "color": "#BFDBFE",
                                    "text_decoration": "underline",
                                },
                                padding_top="4px",
                            ),
                            spacing="5",
                            width="100%",
                        ),
                        on_submit=AuthState.login,
                        reset_on_submit=True,
                    ),
                    width="100%",
                    max_width="460px",
                    padding="32px",
                    background="#101F33",
                    border="1px solid #263A53",
                    border_radius="20px",
                    box_shadow="0 24px 70px rgba(0, 0, 0, 0.3)",
                ),
                spacing="8",
                align="center",
                width="100%",
            ),
            min_height="100vh",
            width="100%",
            padding="24px",
            background="linear-gradient(135deg, #071426 0%, #0B1B33 52%, #102846 100%)",
            display="flex",
            flex_direction="column",
            align_items="center",
            gap="12px",
        ),
    )


def register_page() -> rx.Component:
    return rx.cond(
        AuthState.is_authenticated,
        rx.box(
            rx.vstack(
                _brand_header(),
                rx.card(
                    rx.form(
                        rx.vstack(
                            rx.heading("Cadastro de funcionário", size="7"),
                            rx.input(
                                name="nome",
                                placeholder="Nome completo",
                                value=AuthState.registration_nome,
                                on_change=AuthState.set_registration_nome,
                                required=True,
                            ),
                            rx.input(
                                name="email",
                                type="email",
                                placeholder="E-mail",
                                value=AuthState.registration_email,
                                on_change=AuthState.set_registration_email,
                                required=True,
                            ),
                            rx.input(
                                name="senha",
                                type="password",
                                placeholder="Senha",
                                required=True,
                            ),
                            rx.input(
                                name="cargo",
                                placeholder="Cargo",
                                value=AuthState.registration_cargo,
                                on_change=AuthState.set_registration_cargo,
                                required=True,
                            ),
                            _feedback(),
                            rx.button(
                                rx.cond(AuthState.is_submitting, "Cadastrando...", "Cadastrar"),
                                type="submit",
                                disabled=AuthState.is_submitting,
                                width="100%",
                            ),
                            rx.link("Voltar ao início", href="/"),
                            spacing="4",
                            width="100%",
                        ),
                        on_submit=AuthState.register_employee,
                        reset_on_submit=True,
                    ),
                    max_width="480px",
                    width="100%",
                ),
                spacing="8",
                align="center",
                width="100%",
            ),
            min_height="100vh",
            width="100%",
            padding="24px",
            background="linear-gradient(135deg, #071426 0%, #0B1B33 52%, #102846 100%)",
            display="flex",
            flex_direction="column",
            align_items="center",
            justify_content="center",
        ),
        rx.center(rx.spinner(), min_height="85vh"),
    )


app = rx.App()
app.add_page(index, on_load=AuthState.require_auth)
app.add_page(login_page, route="/login", on_load=AuthState.redirect_authenticated)
app.add_page(register_page, route="/cadastro", on_load=AuthState.require_auth)
