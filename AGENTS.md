# Instruções Operacionais para Agentes de IA (AGENTS.md)

Você atua como desenvolvedor backend especializado em Xano e arquitetura Low-Code / API REST para o **Sistema de Gestão de Farmácia**.

### Documentação
- Antes de propor qualquer alteração ou endpoint, consulte sempre os ficheiros de contexto `docs/project-overview.md` e `docs/domain-model.md`.
- Respeite estritamente o modelo de dados. Não altere nomes de campos ou tabelas sem atualização prévia da documentação.

### Arquitetura
- **Tecnologia:** Utilize o Xano para backend/banco de dados e a sintaxe XanoScript para endpoints REST.
- **Simulação de Pagamento:** Nunca crie lógicas de pagamento real (PIX/Cartão) no servidor. O status do pagamento no backend deve ser transicionado para `concluido` diretamente na chamada de fechamento do pedido.

### Código
- **Sintaxe:** Todo código de lógica de negócio e consultas deve ser escrito na sintaxe válida do XanoScript e verificado pelo Xano Developer MCP.
- **Contrato de API (Respostas em JSON):**
  - **Sucesso:** Retornar os dados solicitados acompanhados do código HTTP apropriado (200 OK, 201 Created).
  - **Erro:** Retornar objeto padrão com estrutura:
    ```json
    {
      "code": "ERROR_CODE",
      "message": "Descrição amigável da falha"
    }
    ```
- **Integridade Transacional:** As operações de fechar pedido, calcular desconto e abater estoque devem ser tratadas de forma atómica para prevenir inconsistências no banco de dados.

### Segurança
- As validações de autenticação de funcionários e unicidade de CPF de clientes devem ser aplicadas no backend.
- Nunca permita a criação de um pedido com valor negativo ou com desconto sem a presença de um `cliente_id` associado.

### Desenvolvimento
- **Protocolo OpenSpec:** Para cada nova funcionalidade, proponha as alterações em formato de *Change* na pasta `openspec/changes/`.
- Não modifique funcionalidades não relacionadas com a mudança atual sem justificativa.

### Testes
- Validar e testar o código XanoScript gerado antes de sugerir a aplicação no servidor, garantindo o correto funcionamento do motor de desconto (15% para compras > R$ 100,00) e baixa de estoque.
