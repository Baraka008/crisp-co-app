-- Crisp & Co. Supabase schema
-- Run this file once in Supabase Dashboard -> SQL Editor.

create table if not exists public.menu_items (
  id text primary key,
  name text not null,
  description text not null default '',
  price numeric(10,2) not null check (price >= 0),
  category text not null default 'chicken',
  image text not null default '',
  tag text not null default '',
  available boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id text primary key,
  customer text not null,
  initials text not null default '',
  items text not null,
  total text not null,
  status text not null default 'new' check (status in ('new','progress','ready','cancelled')),
  time text not null default 'Just now',
  address text not null default '',
  currency text not null default 'USD',
  created_at timestamptz not null default now()
);

create table if not exists public.bookings (
  id text primary key,
  name text not null,
  initials text not null default '',
  date text not null,
  month text not null,
  time text not null,
  guests text not null,
  note text not null default '',
  status text not null default 'pending' check (status in ('pending','confirmed','declined')),
  created_at timestamptz not null default now()
);

alter table public.menu_items enable row level security;
alter table public.orders enable row level security;
alter table public.bookings enable row level security;

-- Seller data is private. Add trusted seller user IDs to this table from the
-- Supabase SQL editor after creating those users with Supabase Auth.
create table if not exists public.store_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.store_admins enable row level security;

create or replace function public.is_store_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.store_admins where user_id = auth.uid()
  );
$$;
revoke all on function public.is_store_admin() from public;
grant execute on function public.is_store_admin() to authenticated;

drop policy if exists "Public can read menu" on public.menu_items;
drop policy if exists "Public can manage menu" on public.menu_items;
drop policy if exists "Public can create orders" on public.orders;
drop policy if exists "Public can read orders" on public.orders;
drop policy if exists "Public can update orders" on public.orders;
drop policy if exists "Public can manage bookings" on public.bookings;
drop policy if exists "Admins can read own membership" on public.store_admins;
drop policy if exists "Public menu read" on public.menu_items;
drop policy if exists "Store admins manage menu" on public.menu_items;
drop policy if exists "Customers create orders" on public.orders;
drop policy if exists "Store admins read orders" on public.orders;
drop policy if exists "Store admins update orders" on public.orders;
drop policy if exists "Customers create bookings" on public.bookings;
drop policy if exists "Store admins read bookings" on public.bookings;
drop policy if exists "Store admins update bookings" on public.bookings;

create policy "Admins can read own membership"
  on public.store_admins for select to authenticated
  using (user_id = auth.uid());

create policy "Public menu read"
  on public.menu_items for select to anon, authenticated
  using (true);
create policy "Store admins manage menu"
  on public.menu_items for all to authenticated
  using (public.is_store_admin()) with check (public.is_store_admin());

create policy "Customers create orders"
  on public.orders for insert to anon, authenticated
  with check (true);
create policy "Store admins read orders"
  on public.orders for select to authenticated
  using (public.is_store_admin());
create policy "Store admins update orders"
  on public.orders for update to authenticated
  using (public.is_store_admin()) with check (public.is_store_admin());

create policy "Customers create bookings"
  on public.bookings for insert to anon, authenticated
  with check (true);
create policy "Store admins read bookings"
  on public.bookings for select to authenticated
  using (public.is_store_admin());
create policy "Store admins update bookings"
  on public.bookings for update to authenticated
  using (public.is_store_admin()) with check (public.is_store_admin());

-- Enable realtime for the cross-screen order and menu updates.
do $$
begin
  if not exists (select 1 from pg_publication_rel where pubname = 'supabase_realtime' and prrelid = 'public.menu_items'::regclass) then
    alter publication supabase_realtime add table public.menu_items;
  end if;
  if not exists (select 1 from pg_publication_rel where pubname = 'supabase_realtime' and prrelid = 'public.orders'::regclass) then
    alter publication supabase_realtime add table public.orders;
  end if;
  if not exists (select 1 from pg_publication_rel where pubname = 'supabase_realtime' and prrelid = 'public.bookings'::regclass) then
    alter publication supabase_realtime add table public.bookings;
  end if;
end $$;
