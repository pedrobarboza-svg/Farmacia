# Design

## Context

O produto é persistido em `farmacia_final_produtos` e trafega pelas APIs Xano `/farmacia-final/produtos`. O frontend Reflex mantém um modelo `Product`, um estado de estoque e um formulário compartilhado para criação e edição. Atualmente nenhum desses pontos possui uma referência de imagem.

## Goals / Non-Goals

**Goals:**

- Persistir uma URL opcional de imagem no mesmo registro do produto.
- Propagar a URL de forma consistente em GET, POST e PATCH.
- Permitir informar e editar a URL abaixo do dropdown de categoria.
- Exibir uma prévia ou imagem associada na listagem sem quebrar produtos sem imagem.
- Validar que valores preenchidos são URLs HTTP/HTTPS utilizáveis.

**Non-Goals:**

- Upload de arquivos ou armazenamento binário.
- Download, redimensionamento, otimização ou proxy de imagens.
- Alterar regras de categoria, preço, estoque ou vendas.

## Decisions

1. **Armazenar a referência como texto opcional**
   - Adicionar `imagem_url` como campo `text?` em `farmacia_final_produtos`.
   - Enviar `null` ou campo vazio de forma normalizada quando o funcionário remover a imagem.
   - Alternativas rejeitadas: blob/base64, pois aumentariam o tamanho dos registros; tabela separada, pois cada produto terá no máximo uma imagem nesta change.

2. **Validar o formato no backend e no frontend**
   - O backend aceitará somente URLs absolutas `http://` ou `https://`, além de permitir ausência do valor.
   - O frontend fará validação antecipada para feedback imediato, mantendo o backend como autoridade.
   - A aplicação não fará requisição de teste à URL durante o cadastro, evitando lentidão e efeitos colaterais.

3. **Reutilizar o fluxo existente de criação e edição**
   - O campo será incluído no formulário logo depois do seletor de categoria.
   - O estado, o cliente HTTP e os métodos POST/PATCH carregarão o mesmo valor, evitando um fluxo paralelo.
   - A listagem usará a URL apenas quando presente e exibirá um placeholder quando ausente ou quando a imagem falhar.

4. **Preservar compatibilidade com registros existentes**
   - Produtos existentes terão `imagem_url` ausente/nulo e continuarão listáveis.
   - A leitura tratará a ausência como string vazia no estado visual, sem alterar os demais campos.

## Risks / Trade-offs

- **[URL externa indisponível ou bloqueada]** -> Mostrar placeholder e manter nome e dados do produto visíveis; não impedir a listagem.
- **[Conteúdo remoto inseguro ou inadequado]** -> Aceitar apenas HTTP/HTTPS e aplicar os atributos de carregamento seguro disponíveis no componente Reflex; não hospedar conteúdo no sistema.
- **[Registros antigos sem o campo]** -> Tornar o campo opcional e cobrir leitura de payload sem `imagem_url` nos testes.
- **[Erro de acentuação na URL/texto]** -> Garantir serialização UTF-8 no cliente e preservar o texto retornado pelo Xano.

## Migration Plan

1. Atualizar o schema da tabela e os endpoints Xano mantendo o campo opcional.
2. Atualizar cliente, estado, formulário e listagem Reflex.
3. Executar testes unitários, compilação Reflex e teste manual de cadastro/edição com URL e sem URL.
4. Em caso de rollback, remover o uso do campo no frontend e nas APIs; registros sem uso da nova funcionalidade permanecem compatíveis.
