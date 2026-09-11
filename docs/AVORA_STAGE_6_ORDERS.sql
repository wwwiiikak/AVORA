-- AVORA Tahap 6: pemesanan customer
-- Jalankan SATU KALI di Supabase SQL Editor.
-- Tidak menghapus tabel/kolom yang sudah ada.

alter table public.orders
  add column if not exists pickup_address text,
  add column if not exists destination_address text,
  add column if not exists package_type text default 'Paket',
  add column if not exists weight_kg numeric(10,2) default 1,
  add column if not exists vehicle_type text default 'motor',
  add column if not exists service_type text default 'regular',
  add column if not exists notes text,
  add column if not exists estimated_price integer default 0,
  add column if not exists resi text,
  add column if not exists status text default 'pending';

create unique index if not exists orders_resi_unique_idx
  on public.orders(resi)
  where resi is not null;

create index if not exists orders_customer_created_idx
  on public.orders(customer_id, created_at desc);

grant select, insert, update on public.orders to authenticated;
