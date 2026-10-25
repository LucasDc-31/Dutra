-- ============================================================
-- Dutra Distribuidora — esquema Supabase para sincronização
-- ============================================================
-- Uma tabela por tipo de dado (produtos, categorias, clientes,
-- pedidos, movimentações, config) — cada REGISTRO é uma linha,
-- não um bloco único. Isso é o que faz dois aparelhos poderem
-- salvar coisas diferentes ao mesmo tempo sem um apagar a
-- alteração do outro: cada gravação mexe só na própria linha.
--
-- O conteúdo de cada registro continua em JSON (coluna "dados"),
-- então o formato interno do produto/cliente/pedido pode mudar
-- no app sem precisar alterar esta tabela depois.
--
-- Como rodar:
--   1. Abra seu projeto em https://supabase.com
--   2. Vá em "SQL Editor" > "New query"
--   3. Cole este arquivo inteiro e clique em "Run"
-- ============================================================

create table if not exists public.produtos (
  id text primary key,
  dados jsonb not null,
  atualizado_em timestamptz not null default now(),
  atualizado_por text
);

create table if not exists public.categorias (
  id text primary key,
  dados jsonb not null,
  atualizado_em timestamptz not null default now(),
  atualizado_por text
);

create table if not exists public.clientes (
  id text primary key,
  dados jsonb not null,
  atualizado_em timestamptz not null default now(),
  atualizado_por text
);

create table if not exists public.pedidos (
  id text primary key,
  dados jsonb not null,
  atualizado_em timestamptz not null default now(),
  atualizado_por text
);

create table if not exists public.movimentacoes (
  id text primary key,
  dados jsonb not null,
  atualizado_em timestamptz not null default now(),
  atualizado_por text
);

-- Dados da distribuidora (nome, telefone, e-mail...) continuam em
-- uma única linha, já que é uma configuração só, sem risco real
-- de duas pessoas editarem ao mesmo tempo.
create table if not exists public.config (
  id text primary key default 'dutra',
  dados jsonb not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now(),
  atualizado_por text
);

comment on table public.produtos is 'Um produto por linha — permite que vários aparelhos editem produtos diferentes ao mesmo tempo sem conflito.';
comment on table public.pedidos is 'Um pedido por linha — cada venda lançada é independente das outras.';

-- ------------------------------------------------------------
-- Segurança: só usuários autenticados (login feito no app) podem
-- ler e gravar. Ninguém de fora, sem login, acessa os dados.
-- ------------------------------------------------------------
alter table public.produtos enable row level security;
alter table public.categorias enable row level security;
alter table public.clientes enable row level security;
alter table public.pedidos enable row level security;
alter table public.movimentacoes enable row level security;
alter table public.config enable row level security;

do $$
declare
  t text;
begin
  foreach t in array array['produtos', 'categorias', 'clientes', 'pedidos', 'movimentacoes', 'config']
  loop
    execute format('drop policy if exists "%1$s_select_autenticado" on public.%1$s', t);
    execute format('create policy "%1$s_select_autenticado" on public.%1$s for select to authenticated using (true)', t);

    execute format('drop policy if exists "%1$s_insert_autenticado" on public.%1$s', t);
    execute format('create policy "%1$s_insert_autenticado" on public.%1$s for insert to authenticated with check (true)', t);

    execute format('drop policy if exists "%1$s_update_autenticado" on public.%1$s', t);
    execute format('create policy "%1$s_update_autenticado" on public.%1$s for update to authenticated using (true) with check (true)', t);

    execute format('drop policy if exists "%1$s_delete_autenticado" on public.%1$s', t);
    execute format('create policy "%1$s_delete_autenticado" on public.%1$s for delete to authenticated using (true)', t);
  end loop;
end $$;

-- ------------------------------------------------------------
-- Tempo real: quando um aparelho grava ou apaga, os outros
-- recebem o aviso e se atualizam sozinhos.
-- ------------------------------------------------------------
alter publication supabase_realtime add table public.produtos;
alter publication supabase_realtime add table public.categorias;
alter publication supabase_realtime add table public.clientes;
alter publication supabase_realtime add table public.pedidos;
alter publication supabase_realtime add table public.movimentacoes;
alter publication supabase_realtime add table public.config;

-- ------------------------------------------------------------
-- Número do pedido: sequência do próprio banco, que NUNCA repete,
-- mesmo com dois aparelhos lançando pedidos no mesmo segundo.
-- (Um contador guardado no app não consegue garantir isso.)
-- A função também se "auto-corrige": se já existirem pedidos com
-- números maiores (ex.: migração de uma versão anterior), continua
-- a partir do maior número existente.
-- ------------------------------------------------------------
create sequence if not exists public.pedido_numero_seq start 1;

create or replace function public.proximo_numero_pedido()
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare
  maior bigint;
  atual bigint;
begin
  select coalesce(max((dados->>'numero')::bigint), 0) into maior
    from public.pedidos
   where dados->>'numero' ~ '^[0-9]+$';

  select last_value into atual from public.pedido_numero_seq;
  if atual < maior then
    perform setval('public.pedido_numero_seq', maior);
  end if;

  return nextval('public.pedido_numero_seq');
end;
$$;

revoke all on function public.proximo_numero_pedido() from public, anon;
grant execute on function public.proximo_numero_pedido() to authenticated;

-- ------------------------------------------------------------
-- Migrando de uma versão anterior (tabela única "app_dados")?
-- Depois de confirmar que os dados já estão nas tabelas novas,
-- pode apagar a antiga com:
--   drop table if exists public.app_dados;
-- ------------------------------------------------------------
