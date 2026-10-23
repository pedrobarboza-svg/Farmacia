import reflex as rx


class StockState(rx.State):
    search_term: str = ""
    status_filter: str = "Todos"
    category_filter: str = "Todas"
    status_options: list[str] = ["Todos", "Normal", "Baixo estoque"]
    category_options: list[str] = [
        "Todas",
        "Medicamentos",
        "Antibióticos",
        "Proteínas e Suplementos",
        "Primeiros Socorros",
    ]
    medicines: list[dict[str, str]] = [
        {
            "nome": "Paracetamol 750mg",
            "categoria": "Medicamentos",
            "quantidade": "120",
            "preco": "R$ 12,90",
            "status": "Normal",
        },
        {
            "nome": "Amoxicilina 500mg",
            "categoria": "Antibióticos",
            "quantidade": "18",
            "preco": "R$ 28,50",
            "status": "Baixo estoque",
        },
        {
            "nome": "Whey Protein 900g",
            "categoria": "Proteínas e Suplementos",
            "quantidade": "64",
            "preco": "R$ 119,90",
            "status": "Normal",
        },
        {
            "nome": "Kit Primeiros Socorros",
            "categoria": "Primeiros Socorros",
            "quantidade": "9",
            "preco": "R$ 45,00",
            "status": "Baixo estoque",
        },
    ]

    @rx.var
    def filtered_medicines(self) -> list[dict[str, str]]:
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
    def total_items(self) -> str:
        return str(sum(int(item["quantidade"]) for item in self.medicines))

    @rx.var
    def low_stock_count(self) -> str:
        return str(sum(item["status"] == "Baixo estoque" for item in self.medicines))

    @rx.var
    def total_stock_value(self) -> str:
        total = sum(
            int(item["quantidade"])
            * float(item["preco"].replace("R$ ", "").replace(".", "").replace(",", "."))
            for item in self.medicines
        )
        return f"R$ {total:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")

    @rx.event
    def set_search_term(self, value: str) -> None:
        self.search_term = value

    @rx.event
    def set_status_filter(self, value: str) -> None:
        self.status_filter = value

    @rx.event
    def set_category_filter(self, value: str) -> None:
        self.category_filter = value
