# Design

## Context

O campo `funcionario.cargo` é atualmente texto livre, e o cadastro público não usa uma entidade de cargos. A interface Reflex já envia esse texto ao endpoint público `POST /farmacia-final/funcionarios`; o cliente Xano centraliza as requisições e a rota `/cadastro` não exige autenticação. Ver [proposal.md](./proposal.md) e [spec.md](./specs/cadastro-publico-funcionario/spec.md).

## Goals / Non-Goals

**Goals:**
- Oferecer opções de cargo mantidas no backend, publicamente consultáveis no fluxo de cadastro.
- Garantir que um cadastro só aceite cargo existente e ativo.
- Preservar o campo de texto atual em `funcionario` e a compatibilidade de funcionários existentes.

**Non-Goals:**
- Criar interface para administrar cargos.
- Converter `funcionario.cargo` em chave estrangeira ou alterar permissões/RBAC.
- Restringir ou alterar o fluxo público e a ativação imediata definidos pela Change de cadastro público.

## Decisions

### Tabela de cargos independente

Criar `farmacia_final_cargo` com `id` inteiro (PK, auto incremento), `nome` texto obrigatório e único, `ativo` booleano com padrão `true`, e `created_at` timestamp com padrão atual. Provisionar de forma idempotente os nomes Atendente, Farmacêutico, Gerente, Repositor, Caixa e Estagiário.

**Alternativas consideradas:** manter uma lista fixa no endpoint ou deduzir cargos distintos de funcionários existentes. Uma tabela dedicada permite ativar/desativar e manter opções sem depender de funcionários cadastrados, enquanto a manutenção inicial pelo Xano evita escopo de administração no frontend.

### Listagem pública somente de cargos ativos

Adicionar `GET /farmacia-final/cargos`, sem autenticação, que consulta apenas cargos ativos em ordem alfabética e responde com o envelope `{ "cargos": [{ "id": 1, "nome": "Atendente" }] }`. A resposta não inclui campos administrativos além do necessário para a seleção.

O endpoint precisa ter autenticação desabilitada no próprio objeto publicado do Xano, não apenas no script local, pois `/cadastro` é acessível sem sessão.

### Compatibilidade do cadastro de funcionário

Manter `funcionario.cargo` e o input textual `cargo` como estão. O endpoint `POST /farmacia-final/funcionarios` valida o nome recebido contra `farmacia_final_cargo.nome` com `ativo=true` antes de criar a conta. Isso impede payloads adulterados, sem migração de registros existentes nem alteração de resposta/login.

### Carregamento e seleção no Reflex

No carregamento da rota `/cadastro`, chamar o cliente Xano para obter os nomes disponíveis; armazená-los no estado da página e vinculá-los a `rx.select` com valor inicialmente vazio. Usar os nomes como valores do Select para preservar o contrato textual de cadastro existente. Enquanto a lista carrega, estiver vazia ou ocorrer erro, mostrar estado informativo e desabilitar o envio; falhas devem ser registradas de forma segura e não substituídas por uma lista hardcoded.

O handler de cadastro continua enviando o valor selecionado. O backend permanece a autoridade para validar o cargo, inclusive quando a requisição não vem da interface.

**Alternativas consideradas:** opções embutidas no componente ou enviadas pelo bundle não garantiriam sincronização com o backend; usar ID exigiria mudar o contrato e o modelo atual do funcionário.

## Risks / Trade-offs

- [A tabela pode estar vazia ou indisponível na implantação] → provisionar os seis cargos iniciais antes de publicar a interface e manter o cadastro bloqueado com mensagem amigável se a listagem falhar.
- [Um cargo pode ser desativado entre o carregamento do formulário e o envio] → validar novamente `ativo=true` dentro do endpoint de cadastro e retornar erro de validação.
- [Cadastro público continua aberto a qualquer visitante] → manter a decisão e o risco já documentados; esta mudança não adiciona aprovação nem transforma cargo em permissão.
- [Alteração parcial do endpoint pode gerar divergência entre script e Console] → validar o XanoScript e confirmar auth/publicação no endpoint exato antes da conclusão; os testes remotos seguem o processo de integração autorizado.

## Migration Plan

1. Criar a tabela e provisionar os seis nomes sem duplicar registros existentes.
2. Publicar e verificar `GET /farmacia-final/cargos` com autenticação desabilitada e resposta contendo apenas cargos ativos.
3. Atualizar o endpoint de cadastro para validar cargo ativo; funcionários já existentes permanecem inalterados.
4. Atualizar cliente/estado e página Reflex para consumir o GET e selecionar um cargo; então executar testes automatizados e compilação.
5. Se houver rollback, restaurar a página para o campo anterior e reverter a validação do endpoint; a tabela e os registros podem permanecer sem afetar funcionários existentes.

## Open Questions

Nenhuma.
