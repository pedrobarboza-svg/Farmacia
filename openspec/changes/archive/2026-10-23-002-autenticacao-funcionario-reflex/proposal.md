# Proposal

## Why

O projeto ainda não possui uma interface operacional: a aplicação Reflex contém apenas a página inicial de demonstração, enquanto o Xano já oferece login e provisionamento autenticado de funcionários. Esta mudança conecta essas partes para permitir que funcionários entrem no sistema e cadastrem novos colegas sem expor uma rota de criação anônima.

## What Changes

- Criar as páginas Reflex `/login` e `/cadastro`, com validação dos campos e mensagens de erro compreensíveis.
- Manter o JWT no estado de servidor por sessão Reflex e realizar as chamadas ao Xano no servidor.
- Redirecionar após login e proteger as rotas operacionais; sem autenticação, o usuário será enviado a `/login`.
- Usar `POST /farmacia-final/auth/login` para login e `POST /farmacia-final/funcionarios` para provisionamento autenticado.
- Estender o funcionário com um campo persistido `cargo` e atualizar a tabela e a API Xano de provisionamento; `cargo` será metadado e não concederá permissões.
- Preservar o bootstrap administrativo do primeiro funcionário e a exigência de autenticação para o cadastro de funcionários.
- Tratar erros HTTP 400 e 401 do Xano com feedback visual, sem expor detalhes internos ou credenciais.

## Capabilities

### New Capabilities

- `autenticacao-funcionarios`: Autenticação de funcionários, sessão Reflex, proteção de rotas e provisionamento autenticado com cargo.

### Modified Capabilities

- Nenhuma.

## Impact

- Frontend Reflex em `farmaciaFinal/farmaciaFinal.py`; configuração da URL do Xano e fluxo de estado.
- Xano: `farmacia_final_funcionario` e `POST /farmacia-final/funcionarios`, mantendo o login em `/farmacia-final/auth/login`.
- Documentação do modelo de domínio e testes de fluxo de autenticação/cadastro.
- Fora do escopo: signup público, autorização baseada em cargo, recuperação de senha, autenticação multifator e integração com gateway de pagamento real.
