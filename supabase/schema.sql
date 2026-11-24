-- Esquema mínimo requerido en Supabase / PostgreSQL para Herramientas de Texto

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username text,
  lastname text,
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
  on public.profiles
  for select
  using (auth.uid() = id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
  on public.profiles
  for insert
  with check (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
  on public.profiles
  for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

create table if not exists public.notes (
  id uuid primary key default gen_random_uuid(),
  id_notes_user uuid not null references auth.users (id) on delete cascade,
  title text not null,
  description text not null default '',
  create_at timestamptz not null default now(),
  update_at timestamptz
);

create index if not exists idx_notes_user_create_at
  on public.notes (id_notes_user, create_at desc);

alter table public.notes enable row level security;

drop policy if exists "notes_select_own" on public.notes;
create policy "notes_select_own"
  on public.notes
  for select
  using (auth.uid() = id_notes_user);

drop policy if exists "notes_insert_own" on public.notes;
create policy "notes_insert_own"
  on public.notes
  for insert
  with check (auth.uid() = id_notes_user);

drop policy if exists "notes_update_own" on public.notes;
create policy "notes_update_own"
  on public.notes
  for update
  using (auth.uid() = id_notes_user)
  with check (auth.uid() = id_notes_user);

drop policy if exists "notes_delete_own" on public.notes;
create policy "notes_delete_own"
  on public.notes
  for delete
  using (auth.uid() = id_notes_user);
