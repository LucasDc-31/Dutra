# Dutra Distribuidora — App de Gestão (PWA)

Aplicativo web instalável (PWA) para uso no celular: estoque, cadastro de produtos,
pesquisa e lançamento de pedidos com nota para o cliente. Os dados ficam no
[Supabase](https://supabase.com) (login por e-mail/senha).

> Site estático: sem build, sem dependências. Basta hospedar os arquivos com HTTPS.

## Estrutura

```
.
├── index.html        # App completo (HTML + CSS + JS)
├── config.js         # URL e chave anon do Supabase
├── manifest.json     # Configuração do PWA
├── sw.js             # Service worker mínimo (sem cache; habilita a instalação como app)
├── icons/            # Ícones do app (192px e 512px)
├── database/
│   └── schema.sql    # Tabelas e políticas (RLS) do Supabase
└── .nojekyll         # Evita processamento do Jekyll no GitHub Pages
```

## Configuração

1. **Banco de dados:** no Supabase, abra *SQL Editor → New query*, cole o conteúdo de
   `database/schema.sql` e clique em *Run* (só uma vez).
2. **Usuários:** crie os logins em *Authentication → Users*.
3. **Credenciais:** em `config.js`, preencha `SUPABASE_URL` e `SUPABASE_ANON_KEY`
   (*Project Settings → API*).

### Sobre a chave no repositório
A chave **anon** é pública por natureza (fica visível no navegador de qualquer forma) e o acesso
aos dados é protegido pelas políticas RLS do `schema.sql`, que só liberam usuários autenticados.
**Nunca** coloque a chave `service_role` neste repositório.

## Publicar no GitHub Pages

1. Suba o projeto para o GitHub.
2. Vá em *Settings → Pages*.
3. Em *Source*, escolha **Deploy from a branch**, branch `main`, pasta `/ (root)`.
4. Aguarde e acesse `https://SEU-USUARIO.github.io/NOME-DO-REPOSITORIO/`.

Alternativas: Netlify, Vercel ou qualquer servidor com HTTPS.

## Instalar no celular

- **Android (Chrome):** menu ⋮ → *Instalar app*.
- **iPhone (Safari):** *Compartilhar* → *Adicionar à Tela de Início*.

## Observações

- Precisa de internet e login; sem conexão o app exibe um aviso.
- O `sw.js` não guarda nada em cache; ele só habilita a instalação como app e apaga caches antigos.
- Se o celular instalou como atalho (ícone de página web), remova o ícone, limpe os dados do site
  no navegador e instale de novo.
