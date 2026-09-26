# Dutra Odonto — Aplicativo de Gestão (PWA)

Aplicativo mobile no mesmo formato do SysCadeiras Mobile: um PWA de arquivo único
(`index.html`), instalável no celular, que funciona offline.

## Arquivos
- `index.html` — todo o app (HTML + CSS + JS)
- `manifest.json` — identidade do PWA (nome, cores, ícones)
- `sw.js` — service worker (abre offline depois da primeira visita)
- `icon-192.png` / `icon-512.png` — ícones do app

## Acesso de demonstração
- `admin` / `1234`
- `vendedor` / `1234`

## O que o app faz
- **Início**: pedidos do dia, faturamento do mês, valor em estoque, alerta de reposição
- **Pedidos**: busca de produto, carrinho com quantidade e preço editáveis, desconto,
  frete, condição de pagamento e baixa automática de estoque
- **Nota do pedido**: gera a nota do pedido e envia por WhatsApp, imprime/salva em PDF
  ou copia o texto
- **Estoque**: pesquisa, filtros (baixo, zerado, validade próxima), entrada/saída/ajuste
- **Cadastros**: produtos (código, marca, categoria, unidade, custo, venda, mínimo,
  lote, validade, ANVISA), categorias e clientes
- **Relatórios**: vendas por período/cliente, produtos mais vendidos, posição de estoque
- **Backup**: exportar/importar `.json` e editar os dados da distribuidora que saem na nota

## Onde os dados ficam
Por padrão, tudo em `localStorage`, no próprio aparelho — não precisa de servidor
nem internet, e continua funcionando 100% offline.

## Sincronização em nuvem (opcional)
Este app já vem com sincronização via Supabase pronta, desligada por padrão.
Para ligar (e sincronizar com o app desktop):
1. Crie um projeto gratuito em https://supabase.com.
2. No SQL Editor do projeto, rode o script `supabase-schema.sql` (nesta entrega).
3. Em Authentication > Users, crie um usuário (e-mail/senha) para o time usar.
4. No app (celular ou desktop), abra **🗄️ Backup > Sincronização em nuvem**,
   cole a **URL do projeto** e a **chave anon (public)** (em Project Settings > API),
   salve, depois entre com o e-mail/senha criado no passo 3.
5. Pronto: pedidos, estoque e cadastros passam a ficar iguais em todos os
   aparelhos conectados, quase em tempo real.

Sem configurar isso, o app funciona exatamente como antes (somente local).

## Como publicar
Suba os 5 arquivos em qualquer hospedagem estática (GitHub Pages, Netlify, Vercel).
No celular, abra o link e use "Adicionar à tela de início".

## Identidade visual
- Base "porcelana" (#EAF2F3) com cartões brancos — leitura clínica, clara por padrão;
  o modo escuro continua disponível no botão 🌙 da barra superior.
- Verde-água clínico (#0E8C84) como única cor de ação; âmbar e coral reservados
  exclusivamente para alerta de estoque e erro.
- Tipografia: Outfit (marca, títulos e números tabulares) + Inter (leitura).
- Marca própria: silhueta de dente em SVG no login, na barra superior e na nota —
  sem emojis fazendo papel de logotipo.
- Cada linha de produto/pedido tem uma faixa lateral colorida que codifica a situação
  (verde = ok, âmbar = estoque baixo, coral = zerado, azul = registro neutro).
