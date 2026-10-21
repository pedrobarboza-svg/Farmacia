# Proposal

## Why

O cadastro atual aceita cargo como texto livre, permitindo valores inconsistentes e erros de digitação. Uma lista mantida no Xano e carregada pela interface padroniza os cargos disponíveis sem transformar cargo em regra de autorização.

## What Changes

- Criar uma tabela Xano de cargos ativos e disponibilizar inicialmente Atendente, Farmacêutico, Gerente, Repositor, Caixa e Estagiário.
- Expor um endpoint público `GET /farmacia-final/cargos` que retorne os cargos ativos para o cadastro público.
- Substituir o campo de texto de cargo em `/cadastro` por um Select preenchido pela API, mantendo o cargo como texto no cadastro de funcionário para compatibilidade.
- Validar no backend que o cargo enviado no cadastro corresponde a um cargo ativo cadastrado; rejeitar valores ausentes ou adulterados.
- Apresentar estado vazio/erro de carregamento e impedir o envio do cadastro sem uma opção válida carregada.

Fora do escopo: gerenciamento de cargos pela interface, alteração de permissões/RBAC, autenticação do cadastro, e mudanças no login ou em regras de venda/pagamento.

## Capabilities

### New Capabilities

Nenhuma.

### Modified Capabilities

- `cadastro-publico-funcionario`: exigir que o cargo selecionado no cadastro público corresponda a uma opção ativa fornecida pelo backend e exibir essa lista em um Select dinâmico.

## Impact

- Xano: nova tabela `farmacia_final_cargo`, valores iniciais, endpoint público de listagem e validação de cargo no endpoint público de cadastro de funcionários.
- Reflex: cliente Xano, estado de autenticação/cadastro, carregamento da lista na abertura de `/cadastro` e componente Select.
- Testes: contratos de API, carregamento/erro de cargos, seleção e validação de cadastro.
- Dados existentes: `funcionario.cargo` permanece texto; cargos não concedem permissões.
