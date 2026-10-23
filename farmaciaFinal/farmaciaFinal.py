import reflex as rx

from farmaciaFinal.auth_state import AuthState
from farmaciaFinal.dashboard_state import DashboardState
from farmaciaFinal.stock_state import StockState


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
        rx.image(
            src="/logofarmacia.png",
            alt="DROGA-NONIMO",
            width="190px",
            height="auto",
            max_height="82px",
            object_fit="contain",
        ),
        rx.text(
            "Mais saúde para o seu dia a dia",
            color="#A9B8CC",
            size="4",
            text_align="center",
        ),
        spacing="4",
        align="center",
        width="100%",
    )


def _sidebar_link(label: str, icon: str, href: str, active: bool = False) -> rx.Component:
    return rx.link(
        rx.hstack(
            rx.icon(tag=icon, size=18),
            rx.text(label, font_size="14px", font_weight="600"),
            spacing="3",
            align="center",
        ),
        href=href,
        width="100%",
        padding="12px 14px",
        border_radius="9999px",
        color="#D7E1E8" if not active else "#123B2A",
        background="#FFFFFF" if not active else "#8BD5A7",
        _hover={"background": "#D8F3E3", "color": "#123B2A"},
    )


def _dashboard_sidebar(active_route: str = "/dashboard") -> rx.Component:
    return rx.vstack(
        rx.vstack(
            rx.image(
                src="/logofarmacia.png",
                alt="DROGA-NONIMO",
                width="156px",
                height="auto",
                max_height="68px",
                object_fit="contain",
            ),
            spacing="2",
            align="center",
            width="100%",
            padding_bottom="24px",
        ),
        rx.vstack(
            _sidebar_link("Visão Geral", "layout_dashboard", "/dashboard", active=active_route == "/dashboard"),
            _sidebar_link("Gestão de Estoque", "package", "/estoque", active=active_route == "/estoque"),
            _sidebar_link("Vendas", "shopping_cart", "/vendas", active=active_route == "/vendas"),
            _sidebar_link("Categorias", "tags", "/categorias", active=active_route == "/categorias"),
            _sidebar_link("Funcionários", "users", "/funcionarios", active=active_route == "/funcionarios"),
            _sidebar_link("Configurações", "settings", "/configuracoes", active=active_route == "/configuracoes"),
            spacing="2",
            width="100%",
        ),
        rx.spacer(),
        rx.button(
            rx.hstack(
                rx.icon(tag="log_out", size=18),
                rx.text("Sair", font_size="14px", font_weight="600"),
                spacing="3",
            ),
            on_click=AuthState.logout,
            variant="ghost",
            color="#D7E1E8",
            width="100%",
            justify_content="flex-start",
            padding="12px 14px",
            border_radius="9999px",
            _hover={"background": "#183B4A", "color": "#FFFFFF"},
        ),
        width="248px",
        min_width="248px",
        height="100vh",
        padding="32px 20px 24px",
        background="#0B2633",
        spacing="5",
        align="stretch",
        position="sticky",
        top="0",
    )


def _metric_card(title: str, value: rx.Var, context: rx.Var, icon: str, color: str) -> rx.Component:
    return rx.box(
        rx.hstack(
            rx.center(
                rx.icon(tag=icon, size=20, color=color),
                width="42px",
                height="42px",
                background=f"{color}1A",
                border_radius="16px",
            ),
            rx.text(title, color="#64748B", font_size="14px", font_weight="600"),
            spacing="3",
            align="center",
        ),
        rx.heading(value, size="7", color="#102A43", margin_top="20px"),
        rx.text(context, color="#7B8794", font_size="13px", margin_top="4px"),
        background="#FFFFFF",
        border="1px solid #E8EEF2",
        border_radius="32px",
        padding="22px",
        box_shadow="0 8px 24px rgba(16, 42, 67, 0.06)",
        min_height="160px",
    )


def _category_bars() -> rx.Component:
    categories = [
        ("Medicamentos", "68%", "R$ 1.240,00", "#55B77A"),
        ("Antibióticos", "48%", "R$ 876,40", "#4D9DE0"),
        ("Proteínas e Suplementos", "34%", "R$ 620,80", "#F2B84B"),
        ("Primeiros Socorros", "22%", "R$ 401,30", "#E97878"),
    ]
    return rx.box(
        rx.heading("Vendas por Categorias", size="5", color="#102A43"),
        rx.vstack(
            *[
                rx.vstack(
                    rx.hstack(
                        rx.text(name, color="#52606D", font_size="14px"),
                        rx.spacer(),
                        rx.text(value, color="#102A43", font_size="14px", font_weight="700"),
                        width="100%",
                    ),
                    rx.box(
                        rx.box(
                            width=percentage,
                            height="8px",
                            background=color,
                            border_radius="99px",
                        ),
                        width="100%",
                        height="8px",
                        background="#EDF2F4",
                        border_radius="99px",
                    ),
                    spacing="2",
                    width="100%",
                )
                for name, percentage, value, color in categories
            ],
            spacing="5",
            margin_top="26px",
            width="100%",
        ),
        background="#FFFFFF",
        border="1px solid #E8EEF2",
        border_radius="24px",
        padding="26px",
        box_shadow="0 8px 24px rgba(16, 42, 67, 0.06)",
    )


def _quick_actions() -> rx.Component:
    actions = [
        ("Promoções", "Criar ou editar ofertas", "badge_percent", "#E8F7EE"),
        ("Alterar Horário", "Atualizar funcionamento", "clock_3", "#EAF3FB"),
        ("Avisos", "Publicar aviso no sistema", "megaphone", "#FFF5DF"),
        ("Pausar Loja", "Suspender vendas temporariamente", "circle_pause", "#FCEBEC"),
    ]
    return rx.box(
        rx.heading("Modificações Rápidas", size="5", color="#102A43"),
        rx.vstack(
            *[
                rx.hstack(
                    rx.center(
                        rx.icon(tag=icon, size=18, color="#356B55"),
                        width="38px",
                        height="38px",
                        background=color,
                        border_radius="10px",
                    ),
                    rx.vstack(
                        rx.text(name, color="#102A43", font_size="14px", font_weight="700"),
                        rx.text(description, color="#7B8794", font_size="12px"),
                        align="start",
                        spacing="1",
                    ),
                    rx.icon(tag="chevron_right", size=17, color="#9AA5B1"),
                    justify="between",
                    align="center",
                    width="100%",
                    padding="12px",
                    border_radius="24px",
                    _hover={"background": "#F5F8FA"},
                )
                for name, description, icon, color in actions
            ],
            spacing="2",
            margin_top="18px",
        ),
        background="#FFFFFF",
        border="1px solid #E8EEF2",
        border_radius="24px",
        padding="26px",
        box_shadow="0 8px 24px rgba(16, 42, 67, 0.06)",
    )


def _dashboard_content() -> rx.Component:
    return rx.vstack(
        rx.hstack(
            rx.vstack(
                rx.heading("Visão Geral", size="8", color="#102A43"),
                rx.text(
                    "Acompanhe o desempenho da sua farmácia.",
                    color="#7B8794",
                    font_size="14px",
                ),
                spacing="1",
                align="start",
            ),
            rx.spacer(),
            rx.vstack(
                rx.text(
                    AuthState.employee_name,
                    color="#102A43",
                    font_size="14px",
                    font_weight="700",
                ),
                rx.cond(
                    AuthState.employee_cargo != "",
                    rx.text(
                        AuthState.employee_cargo,
                        color="#7B8794",
                        font_size="12px",
                    ),
                    rx.fragment(),
                ),
                spacing="1",
                align="end",
            ),
            rx.button(
                rx.hstack(rx.text("+"), rx.text("Nova Venda"), spacing="2"),
                background="#55B77A",
                color="#FFFFFF",
                border_radius="9999px",
                padding="12px 18px",
                font_weight="700",
                _hover={"background": "#3E9D63"},
            ),
            width="100%",
            align="center",
        ),
        rx.grid(
            _metric_card(
                "Vendas Hoje",
                DashboardState.vendas_hoje,
                DashboardState.vendas_hoje_contexto,
                "trending_up",
                "#55B77A",
            ),
            _metric_card(
                "Esta Semana",
                DashboardState.vendas_semana,
                DashboardState.vendas_semana_contexto,
                "calendar_days",
                "#4D9DE0",
            ),
            _metric_card(
                "Este Mês",
                DashboardState.vendas_mes,
                DashboardState.vendas_mes_contexto,
                "chart_no_axes_combined",
                "#F2B84B",
            ),
            _metric_card(
                "Itens Estoque",
                DashboardState.itens_estoque,
                DashboardState.itens_estoque_contexto,
                "package_check",
                "#E97878",
            ),
            columns={"initial": "1", "md": "2", "xl": "4"},
            spacing="5",
            width="100%",
        ),
        rx.grid(
            _category_bars(),
            _quick_actions(),
            columns={"initial": "1", "lg": "1.2fr 0.8fr"},
            spacing="5",
            width="100%",
        ),
        spacing="7",
        width="100%",
        max_width="1440px",
        padding="42px 48px",
        align="stretch",
    )


def index() -> rx.Component:
    return rx.cond(
        AuthState.is_authenticated,
        rx.hstack(
            _dashboard_sidebar(),
            rx.box(
                _dashboard_content(),
                flex="1",
                min_height="100vh",
                background="#EEF2F6",
                border_radius="32px 0 0 32px",
            ),
            align="start",
            spacing="0",
            width="100%",
            min_height="100vh",
        ),
        rx.center(rx.spinner(), min_height="85vh"),
    )


def module_placeholder(title: str) -> rx.Component:
    return rx.cond(
        AuthState.is_authenticated,
        rx.center(
            rx.vstack(
                rx.heading(title, size="8", color="#102A43"),
                rx.text(
                    "Este módulo estará disponível em breve.",
                    color="#7B8794",
                ),
                rx.link(rx.button("Voltar para Visão Geral"), href="/dashboard"),
                spacing="4",
                align="center",
            ),
            min_height="100vh",
            background="#EEF2F6",
            width="100%",
        ),
        rx.center(rx.spinner(), min_height="85vh"),
    )


def _stock_summary_card(title: str, value: rx.Var, context: str, icon: str, color: str) -> rx.Component:
    return rx.box(
        rx.hstack(
            rx.center(
                rx.icon(tag=icon, size=20, color=color),
                width="42px",
                height="42px",
                background=f"{color}1A",
                border_radius="16px",
            ),
            rx.text(title, color="#64748B", font_size="14px", font_weight="600"),
            spacing="3",
            align="center",
        ),
        rx.heading(value, size="7", color="#102A43", margin_top="20px"),
        rx.text(context, color="#7B8794", font_size="13px", margin_top="4px"),
        background="#FFFFFF",
        border="1px solid #E8EEF2",
        border_radius="32px",
        padding="22px",
        box_shadow="0 8px 24px rgba(16, 42, 67, 0.06)",
        min_height="160px",
    )


def _stock_row(medicine: rx.Var) -> rx.Component:
    status = medicine["status"]
    return rx.grid(
        rx.text(medicine["nome"], color="#102A43", font_weight="700"),
        rx.text(medicine["categoria"], color="#64748B"),
        rx.text(medicine["quantidade"], color="#102A43"),
        rx.text(medicine["preco"], color="#102A43", font_weight="600"),
        rx.badge(
            status,
            color_scheme=rx.cond(status == "Normal", "green", "orange"),
            variant="soft",
            border_radius="9999px",
        ),
        rx.hstack(
            rx.button(
                rx.icon(tag="pencil", size=16),
                variant="ghost",
                color="#356B55",
                on_click=StockState.open_edit(medicine["id"]),
            ),
            rx.button(
                rx.icon(tag="trash_2", size=16),
                variant="ghost",
                color="#C24141",
                on_click=StockState.request_delete(medicine["id"]),
            ),
            spacing="1",
        ),
        columns="1.8fr 1.4fr 0.7fr 0.9fr 1fr 0.7fr",
        gap="4",
        align="center",
        padding="17px 22px",
        border_top="1px solid #EDF2F4",
        width="100%",
    )


def stock_page() -> rx.Component:
    return rx.cond(
        AuthState.is_authenticated,
        rx.hstack(
            _dashboard_sidebar(active_route="/estoque"),
            rx.box(
                rx.vstack(
                    rx.hstack(
                        rx.vstack(
                            rx.heading("Gestão de Estoque", size="8", color="#102A43"),
                            rx.text(
                                "Acompanhe seus medicamentos e mantenha o estoque em dia.",
                                color="#7B8794",
                                font_size="14px",
                            ),
                            spacing="1",
                            align="start",
                        ),
                        rx.spacer(),
                        rx.button(
                            rx.hstack(rx.text("+"), rx.text("Novo Medicamento"), spacing="2"),
                            background="#55B77A",
                            color="#FFFFFF",
                            border_radius="9999px",
                            padding="12px 18px",
                            font_weight="700",
                            on_click=StockState.open_create,
                            _hover={"background": "#3E9D63"},
                        ),
                        width="100%",
                        align="center",
                    ),
                    rx.grid(
                        _stock_summary_card(
                            "Total de Itens",
                            StockState.total_items,
                            "Quantidade disponível no estoque",
                            "package_check",
                            "#55B77A",
                        ),
                        _stock_summary_card(
                            "Produtos em Alerta",
                            StockState.low_stock_count,
                            "Produtos com baixo estoque",
                            "triangle_alert",
                            "#F2B84B",
                        ),
                        _stock_summary_card(
                            "Valor Total do Estoque",
                            StockState.total_stock_value,
                            "Valor calculado pelos itens cadastrados",
                            "wallet",
                            "#4D9DE0",
                        ),
                        columns={"initial": "1", "md": "3"},
                        spacing="5",
                        width="100%",
                    ),
                    rx.hstack(
                        rx.input(
                            placeholder="Buscar medicamento...",
                            value=StockState.search_term,
                            on_change=StockState.set_search_term,
                            width="100%",
                            height="48px",
                            padding_left="16px",
                            background="#FFFFFF",
                            border="1px solid #DCE5EA",
                            border_radius="9999px",
                        ),
                        rx.select(
                            StockState.category_options,
                            value=StockState.category_filter,
                            on_change=StockState.set_category_filter,
                            width="220px",
                            height="48px",
                            border="1px solid #DCE5EA",
                            border_radius="9999px",
                            background="#FFFFFF",
                        ),
                        rx.select(
                            StockState.status_options,
                            value=StockState.status_filter,
                            on_change=StockState.set_status_filter,
                            width="180px",
                            height="48px",
                            border="1px solid #DCE5EA",
                            border_radius="9999px",
                            background="#FFFFFF",
                        ),
                        width="100%",
                        spacing="3",
                    ),
                    rx.box(
                        rx.hstack(
                            *[
                                rx.text(label, color="#7B8794", font_size="12px", font_weight="700")
                                for label in (
                                    "Nome",
                                    "Categoria",
                                    "Quantidade",
                                    "Preço",
                                    "Status do Estoque",
                                    "Ações",
                                )
                            ],
                            display="grid",
                            grid_template_columns="1.8fr 1.4fr 0.7fr 0.9fr 1fr 0.7fr",
                            gap="4",
                            padding="16px 22px",
                            width="100%",
                        ),
                        rx.foreach(StockState.filtered_medicines, _stock_row),
                        background="#FFFFFF",
                        border="1px solid #E8EEF2",
                        border_radius="32px",
                        overflow="hidden",
                        box_shadow="0 8px 24px rgba(16, 42, 67, 0.06)",
                        width="100%",
                    ),
                    rx.cond(
                        StockState.error_message != "",
                        rx.callout(
                            StockState.error_message,
                            icon="triangle_alert",
                            color_scheme="red",
                            width="100%",
                        ),
                        rx.fragment(),
                    ),
                    spacing="7",
                    width="100%",
                    max_width="1440px",
                    padding="42px 48px",
                    align="stretch",
                ),
                flex="1",
                min_height="100vh",
                background="#EEF2F6",
                border_radius="32px 0 0 32px",
            ),
            rx.dialog.root(
                rx.dialog.content(
                    rx.dialog.title(
                        rx.cond(
                            StockState.selected_id == 0,
                            "Novo Medicamento",
                            "Editar Medicamento",
                        )
                    ),
                    rx.vstack(
                        rx.input(
                            placeholder="Nome do medicamento",
                            value=StockState.form_nome,
                            on_change=StockState.set_form_nome,
                        ),
                        rx.input(
                            placeholder="Descrição",
                            value=StockState.form_descricao,
                            on_change=StockState.set_form_descricao,
                        ),
                        rx.hstack(
                            rx.input(
                                placeholder="Preço (ex.: 12,90)",
                                value=StockState.form_preco,
                                on_change=StockState.set_form_preco,
                            ),
                            rx.input(
                                placeholder="Estoque",
                                value=StockState.form_estoque,
                                on_change=StockState.set_form_estoque,
                            ),
                            width="100%",
                        ),
                        rx.select(
                            StockState.category_select_options,
                            placeholder="Selecione uma categoria",
                            value=StockState.form_categoria,
                            on_change=StockState.set_form_categoria,
                            width="100%",
                        ),
                        rx.cond(
                            StockState.form_message != "",
                            rx.text(StockState.form_message, color="#C24141", font_size="13px"),
                            rx.fragment(),
                        ),
                        spacing="3",
                        width="100%",
                    ),
                    rx.hstack(
                        rx.dialog.close(
                            rx.button("Cancelar", variant="soft", on_click=StockState.close_form)
                        ),
                        rx.button(
                            rx.cond(StockState.is_saving, "Salvando...", "Salvar"),
                            on_click=StockState.save_product,
                            background="#55B77A",
                            color="#FFFFFF",
                        ),
                        justify="end",
                        width="100%",
                    ),
                ),
                open=StockState.is_form_open,
                on_open_change=StockState.set_is_form_open,
            ),
            rx.alert_dialog.root(
                rx.alert_dialog.content(
                    rx.alert_dialog.title("Excluir medicamento?"),
                    rx.alert_dialog.description(
                        "O medicamento será removido da listagem e marcado como inativo."
                    ),
                    rx.hstack(
                        rx.alert_dialog.cancel(
                            rx.button("Cancelar", variant="soft", on_click=StockState.close_delete)
                        ),
                        rx.alert_dialog.action(
                            rx.button(
                                "Excluir",
                                color_scheme="red",
                                on_click=StockState.delete_product,
                            )
                        ),
                        justify="end",
                        width="100%",
                    ),
                ),
                open=StockState.is_delete_open,
                on_open_change=StockState.set_is_delete_open,
            ),
            align="start",
            spacing="0",
            width="100%",
            min_height="100vh",
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
                                border_radius="24px",
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
                    border_radius="24px",
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
    return rx.box(
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
                                "Create employee account",
                                "Criar conta de funcionário",
                            ),
                            size="6",
                            color="#F8FAFC",
                            text_align="center",
                            width="100%",
                        ),
                        rx.text(
                            rx.cond(
                                AuthState.language == "en",
                                "Fill in the details below to register a new employee",
                                "Preencha os dados abaixo para cadastrar um novo funcionário",
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
                                name="nome",
                                placeholder=rx.cond(
                                    AuthState.language == "en",
                                    "Full name",
                                    "Nome completo",
                                ),
                                value=AuthState.registration_nome,
                                on_change=AuthState.set_registration_nome,
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
                                tag="mail",
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
                                    "Email",
                                    "E-mail",
                                ),
                                value=AuthState.registration_email,
                                on_change=AuthState.set_registration_email,
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
                        rx.hstack(
                            rx.center(
                                rx.icon(
                                    tag="briefcase",
                                    size=18,
                                    color="#8294AC",
                                ),
                                width="44px",
                                height="52px",
                                flex_shrink="0",
                            ),
                            rx.select(
                                AuthState.registration_cargos,
                                name="cargo",
                                placeholder=rx.cond(
                                    AuthState.language == "en",
                                    "Select a role",
                                    "Selecione um cargo",
                                ),
                                value=AuthState.registration_cargo,
                                on_change=AuthState.set_registration_cargo,
                                required=True,
                                disabled=AuthState.registration_cargo_select_disabled,
                                flex="1",
                                height="52px",
                                padding_left="12px",
                                padding_right="14px",
                                background="transparent",
                                border="none",
                                color="#F8FAFC",
                                font_size="16px",
                                line_height="1.25",
                                text_align="left",
                                display="flex",
                                align_items="center",
                                _placeholder={"color": "#8294AC"},
                                _focus={"border_color": "#60A5FA"},
                                _disabled={
                                    "color": "#8294AC",
                                    "cursor": "not-allowed",
                                    "opacity": "1",
                                },
                            ),
                            align="center",
                            spacing="0",
                            width="100%",
                            height="52px",
                            background="#0A1728",
                            border="1px solid #263A53",
                            border_radius="6px",
                            overflow="hidden",
                        ),
                        rx.cond(
                            AuthState.is_loading_cargos,
                            rx.text(
                                rx.cond(
                                    AuthState.language == "en",
                                    "Loading roles...",
                                    "Carregando cargos...",
                                ),
                                color="#A9B8CC",
                                size="1",
                            ),
                            rx.cond(
                                AuthState.cargo_load_message != "",
                                rx.text(
                                    AuthState.cargo_load_message,
                                    color="#FCA5A5",
                                    size="1",
                                ),
                                rx.fragment(),
                            ),
                        ),
                        _feedback(),
                        rx.button(
                            rx.cond(
                                AuthState.is_submitting,
                                "Cadastrando...",
                                "Cadastrar",
                            ),
                            type="submit",
                            disabled=AuthState.registration_submit_disabled,
                            width="100%",
                            height="52px",
                            border_radius="24px",
                            background="#DBEAFE",
                            color="#102A4C",
                            font_weight="700",
                            _hover={"background": "#BFDBFE"},
                        ),
                        rx.link(
                            rx.cond(
                                AuthState.language == "en",
                                "Already have an account? Sign in",
                                "Já tem uma conta? Faça login",
                            ),
                            href="/login",
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
                    on_submit=AuthState.register_employee,
                    reset_on_submit=True,
                ),
                width="100%",
                max_width="460px",
                padding="32px",
                background="#101F33",
                border="1px solid #263A53",
                border_radius="24px",
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
        justify_content="center",
    )


app = rx.App()
app.add_page(index, on_load=AuthState.require_auth)
app.add_page(login_page, route="/login", on_load=AuthState.redirect_authenticated)
app.add_page(register_page, route="/cadastro", on_load=AuthState.load_cargos)
app.add_page(index, route="/dashboard", on_load=AuthState.require_auth)
app.add_page(
    stock_page,
    route="/estoque",
    on_load=[AuthState.require_auth, StockState.load_inventory],
)
app.add_page(
    lambda: module_placeholder("Vendas"),
    route="/vendas",
    on_load=AuthState.require_auth,
)
app.add_page(
    lambda: module_placeholder("Categorias"),
    route="/categorias",
    on_load=AuthState.require_auth,
)
app.add_page(
    lambda: module_placeholder("Funcionários"),
    route="/funcionarios",
    on_load=AuthState.require_auth,
)
app.add_page(
    lambda: module_placeholder("Configurações"),
    route="/configuracoes",
    on_load=AuthState.require_auth,
)
