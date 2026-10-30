# Proposal

## Why

O link “Não tem uma conta? Cadastre-se” da tela de login leva a `/cadastro`, mas essa rota e a API atual exigem uma sessão existente, impedindo a criação da primeira conta pela própria interface. Esta mudança habilita o autocadastro público de funcionários, conforme a decisão de ativar imediatamente as novas contas.

## What Changes

- **BREAKING:** Tornar `/cadastro` acessível sem sessão e permitir que o formulário crie contas pelo endpoint público `POST /farmacia-final/funcionarios`.
- Ativar imediatamente cada conta criada, definindo `ativo` no backend e não aceitando que o visitante escolha esse estado.
- Preservar validação de nome, e-mail, senha, cargo e unicidade do e-mail; continuar armazenando senha de forma segura e nunca retornar senha ou hash.
- Aplicar à página de cadastro a identidade visual compartilhada com o login, incluindo cabeçalho, seletor PT-BR/English, campos com ícones e link de retorno para `/login`.
- Manter o cargo como informação descritiva, sem conceder permissões ou representar RBAC.
- Fora do escopo: aprovação/inativação inicial, convite por funcionário, verificação de e-mail, recuperação de senha e autorização baseada em cargo.

## Capabilities

### New Capabilities

- `cadastro-publico-funcionario`: Autocadastro público de funcionários, ativação imediata e interface Reflex para `/cadastro`.

### Modified Capabilities

- Nenhuma. A capability de autenticação de funcionários existe apenas como delta na Change 002 e ainda não está publicada em `openspec/specs/`.

## Impact

- Reflex: `farmaciaFinal/farmaciaFinal.py` e `farmaciaFinal/auth_state.py`.
- Cliente API: `farmaciaFinal/xano_client.py`, incluindo chamada pública sem credencial.
- Xano: `xano/api/farmacia/farmacia_final/funcionarios_POST.xs`; remover a exigência de autenticação e fixar a ativação no backend.
- Testes de contrato, navegação, validação e resposta segura; documentação de segurança e cadastro de funcionários.
- **Risco aceito nesta proposta:** qualquer visitante poderá criar uma conta ativa de funcionário. O contrato deve impedir controle público do campo `ativo`, manter validação de e-mail e não atribuir privilégios com base em `cargo`.
