import logging
from typing import Any

import reflex as rx

from farmaciaFinal import xano_client

logger = logging.getLogger(__name__)


class StockState(rx.State):
    auth_token: str = rx.Cookie(name="authToken")
    search_term: str = ""
    status_filter: str = "Todos"
    category_filter: str = "Todas"
    status_options: list[str] = ["Todos", "Normal", "Baixo estoque"]
    category_options: list[str] = ["Todas"]
    category_ids: dict[str, int] = {}
    medicines: list[dict[str, Any]] = []
    is_loading: bool = False
    is_saving: bool = False
    error_message: str = ""
    form_message: str = ""
    is_form_open: bool = False
    is_delete_open: bool = False
    selected_id: int = 0
    form_nome: str = ""
    form_descricao: str = ""
    form_preco: str = ""
    form_estoque: str = ""
    form_categoria: str = ""

    @rx.var
    def filtered_medicines(self) -> list[dict[str, Any]]:
        term = self.search_term.strip().lower()
        return [
            medicine
            for medicine in self.medicines
            if (not term or term in medicine["nome"].lower())
            and (
                self.status_filter == "Todos"
                or medicine["status"] == self.status_filter
            )
            and (
                self.category_filter == "Todas"
                or medicine["categoria"] == self.category_filter
            )
        ]

    @rx.var
    def category_select_options(self) -> list[str]:
        return self.category_options[1:]

    @rx.var
    def total_items(self) -> str:
        return str(sum(item["quantidade"] for item in self.medicines))

    @rx.var
    def low_stock_count(self) -> str:
        return str(sum(item["status"] == "Baixo estoque" for item in self.medicines))

    @rx.var
    def total_stock_value(self) -> str:
        total = sum(item["quantidade"] * item["preco"] for item in self.medicines)
        return f"R$ {total:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")

    @rx.event
    async def load_inventory(self) -> None:
        if not self.auth_token:
            return
        self.is_loading = True
        self.error_message = ""
        try:
            categories = await xano_client.get_categories(token=self.auth_token)
            self.category_options = ["Todas"] + [category.nome for category in categories]
            self.category_ids = {category.nome: category.id for category in categories}
            products = await xano_client.get_products(token=self.auth_token)
            self.medicines = [
                self._medicine_view(product, self.category_ids)
                for product in products
            ]
        except xano_client.XanoAPIError as error:
            logger.warning("Inventory request returned HTTP %s.", error.status_code)
            self.error_message = "Não foi possível carregar o estoque."
        except xano_client.XanoClientError as error:
            logger.warning("Inventory request failed: %s.", type(error).__name__)
            self.error_message = "Não foi possível conectar ao estoque."
        finally:
            self.is_loading = False

    @staticmethod
    def _medicine_view(
        product: xano_client.Product, category_ids: dict[str, int]
    ) -> dict[str, Any]:
        category_name = next(
            (name for name, identifier in category_ids.items() if identifier == product.categoria_id),
            "Sem categoria",
        )
        return {
            "id": product.id,
            "nome": product.nome,
            "descricao": product.descricao,
            "categoria": category_name,
            "categoria_id": product.categoria_id,
            "quantidade": product.estoque,
            "preco": product.preco,
            "status": "Baixo estoque" if product.estoque <= 20 else "Normal",
        }

    @rx.event
    def open_create(self) -> None:
        self.selected_id = 0
        self.form_nome = ""
        self.form_descricao = ""
        self.form_preco = ""
        self.form_estoque = ""
        self.form_categoria = ""
        self.form_message = ""
        self.is_form_open = True

    @rx.event
    def open_edit(self, product_id: int) -> None:
        product = next((item for item in self.medicines if item["id"] == product_id), None)
        if product is None:
            self.error_message = "O medicamento selecionado não está mais disponível."
            return
        self.selected_id = product_id
        self.form_nome = product["nome"]
        self.form_descricao = product["descricao"]
        self.form_preco = f"{product['preco']:.2f}".replace(".", ",")
        self.form_estoque = str(product["quantidade"])
        self.form_categoria = product["categoria"]
        self.form_message = ""
        self.is_form_open = True

    @rx.event
    def close_form(self) -> None:
        self.is_form_open = False
        self.form_message = ""

    @rx.event
    def request_delete(self, product_id: int) -> None:
        self.selected_id = product_id
        self.is_delete_open = True

    @rx.event
    def close_delete(self) -> None:
        self.is_delete_open = False

    @rx.event
    async def save_product(self) -> None:
        try:
            price = float(self.form_preco.replace(".", "").replace(",", "."))
            stock = int(self.form_estoque)
            category_id = self.category_ids[self.form_categoria]
        except (ValueError, KeyError):
            self.form_message = "Informe preço, estoque e categoria válidos."
            return
        if not self.form_nome.strip() or price < 0 or stock < 0:
            self.form_message = "Preencha os campos obrigatórios com valores válidos."
            return
        self.is_saving = True
        self.form_message = ""
        try:
            if self.selected_id:
                await xano_client.update_product(
                    token=self.auth_token,
                    product_id=self.selected_id,
                    nome=self.form_nome,
                    descricao=self.form_descricao,
                    preco=price,
                    estoque=stock,
                    categoria_id=category_id,
                )
            else:
                await xano_client.create_product(
                    token=self.auth_token,
                    nome=self.form_nome,
                    descricao=self.form_descricao,
                    preco=price,
                    estoque=stock,
                    categoria_id=category_id,
                )
            self.is_form_open = False
            await self.load_inventory()
        except xano_client.XanoClientError as error:
            logger.warning("Product save failed: %s.", type(error).__name__)
            self.form_message = "Não foi possível salvar o medicamento."
        finally:
            self.is_saving = False

    @rx.event
    async def delete_product(self) -> None:
        self.is_saving = True
        try:
            product = next(item for item in self.medicines if item["id"] == self.selected_id)
            await xano_client.update_product(
                token=self.auth_token,
                product_id=self.selected_id,
                nome=product["nome"],
                descricao=product["descricao"],
                preco=product["preco"],
                estoque=product["quantidade"],
                categoria_id=product["categoria_id"],
                ativo=False,
            )
            self.is_delete_open = False
            await self.load_inventory()
        except (StopIteration, xano_client.XanoClientError) as error:
            logger.warning("Product deactivation failed: %s.", type(error).__name__)
            self.error_message = "Não foi possível excluir o medicamento."
        finally:
            self.is_saving = False

    @rx.event
    def set_search_term(self, value: str) -> None:
        self.search_term = value

    @rx.event
    def set_status_filter(self, value: str) -> None:
        self.status_filter = value

    @rx.event
    def set_category_filter(self, value: str) -> None:
        self.category_filter = value

    @rx.event
    def set_form_nome(self, value: str) -> None:
        self.form_nome = value

    @rx.event
    def set_form_descricao(self, value: str) -> None:
        self.form_descricao = value

    @rx.event
    def set_form_preco(self, value: str) -> None:
        self.form_preco = value

    @rx.event
    def set_form_estoque(self, value: str) -> None:
        self.form_estoque = value

    @rx.event
    def set_form_categoria(self, value: str) -> None:
        self.form_categoria = value

    @rx.event
    def set_is_form_open(self, value: bool) -> None:
        self.is_form_open = value

    @rx.event
    def set_is_delete_open(self, value: bool) -> None:
        self.is_delete_open = value
