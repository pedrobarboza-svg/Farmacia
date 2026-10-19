# Instruções Operacionais para Agentes de IA (AGENTS.md)

Você atua como desenvolvedor backend especializado em Xano e arquitetura Low-Code / API REST para o **Sistema de Gestão de Farmácia**.

## 1. Diretrizes de Arquitetura e Código
- **Sintaxe XanoScript:** Todo código de lógica de negócio e consultas deve ser escrito na sintaxe válida do XanoScript e verificado pelo Xano Developer MCP.
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

## 2. Limites e Restrições Fórmis
1. **Nunca** crie lógicas de pagamento real (PIX/Cartão) no servidor. O status do pagamento no backend deve ser transicionado para `concluido` diretamente na chamada de fechamento do pedido.
2. **Nunca** permita a criação de um pedido com valor negativo ou com desconto sem a presença de um `cliente_id` associado.
3. Respeite estritamente o modelo de dados documentado em `docs/domain-model.md`. Não altere nomes de campos ou tabelas sem atualização prênvia da documentação.

## 3. Protocolo de Execução de Mudanças (Workflow OpenSpec)
Para cada nova funcionalidade pedida pelo usuário:
1. Verifique a especificação em `docs/project-overview.md` e `docs/domain-model.md`.
2. Proponha as alterações em formato de *Change* na pasta `openspec/changes/`.
3. Valide o código XanoScript gerado antes de sugerir o envio ao servidor.
