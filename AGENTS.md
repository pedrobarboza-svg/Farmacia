<!-- reflex managed begin (do not edit inside this block; add custom content outside the markers) -->
# Agents

This project uses the **Reflex agent skills** � up-to-date knowledge for building full-stack Python web apps with [Reflex](https://reflex.dev). Install them first, then use them as described below.

## Installing the Skills

Before working on this project, make sure the Reflex skills are available to you.

### Claude Code

If the skills are not already available, install them yourself by running these shell commands:

```bash
claude plugin marketplace add reflex-dev/agent-skills
claude plugin install reflex@reflex-agent-skills
```

Newly installed plugins load on the next session. After installing, tell the user to restart the session so the skills auto-load; until then, read the skill files directly from `~/.claude/plugins/` when you need them.

### Other agents (Cursor, OpenCode, Codex, Pi)

```
npx skills add reflex-dev/agent-skills
```

Or clone https://github.com/reflex-dev/agent-skills and copy the `skills/` folders into your agent's skill directory (see the repo README for paths).

### Verifying

Before writing or editing any Reflex code, confirm these three skills are available: `reflex-docs`, `setup-python-env`, and `reflex-process-management`. If they are not, STOP and run the install step above � do not proceed without them.

## Using the Skills

### Reflex documentation

For anything about Reflex APIs � components, state management, events, styling, database, routing, authentication � use the **reflex-docs** skill rather than relying on memory. It carries current, version-accurate docs.

### Initializing a new Reflex project

When starting a new Reflex project or setting up a development environment, you **must** follow the **setup-python-env** skill before doing anything else.

Do not skip any steps. Do not assume a virtual environment or Reflex is already available � always verify first by following the skill's instructions in order.

After the environment is ready and Reflex is installed, run:

```bash
reflex init
```

Then proceed with the user's request.

### Managing a Reflex process

When you need to compile, run, reload, or debug a Reflex application, follow the **reflex-process-management** skill for the correct sequence and error investigation steps.
<!-- reflex managed end -->

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

## Frontend

O frontend do projeto deve ser implementado exclusivamente com Reflex.

Utilize os mecanismos próprios do Reflex para componentes, estado, eventos, páginas e interação.

Não introduza outra tecnologia de frontend para substituir ou complementar o Reflex, salvo quando houver uma alteração arquitetural explicitamente aprovada.

