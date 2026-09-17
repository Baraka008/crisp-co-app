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

-- These policies support the current demo without login. Add Supabase Auth
-- and replace them with user/store policies before accepting real payments.
drop policy if exists "Public can read menu" on public.menu_items;
create policy "Public can read menu" on public.menu_items for select using (true);
drop policy if exists "Public can manage menu" on public.menu_items;
create policy "Public can manage menu" on public.menu_items for all using (true) with check (true);

drop policy if exists "Public can create orders" on public.orders;
create policy "Public can create orders" on public.orders for insert with check (true);
drop policy if exists "Public can read orders" on public.orders;
create policy "Public can read orders" on public.orders for select using (true);
drop policy if exists "Public can update orders" on public.orders;
create policy "Public can update orders" on public.orders for update using (true) with check (true);

drop policy if exists "Public can manage bookings" on public.bookings;
create policy "Public can manage bookings" on public.bookings for all using (true) with check (true);

alter table public.menu_items replica identity full;
alter table public.orders replica identity full;
alter table public.bookings replica identity full;

-- Enable realtime for the cross-screen order and menu updates.
alter publication supabase_realtime add table public.menu_items;
alter publication supabase_realtime add table public.orders;
alter publication supabase_realtime add table public.bookings;
