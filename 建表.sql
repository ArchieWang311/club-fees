-- club-ledger 專案：只有 ledger 這一張表
create table public.ledger (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  court integer not null check (court >= 0),
  shuttle integer not null check (shuttle >= 0),
  headcount integer not null check (headcount >= 1),
  per_person integer not null,
  last_person integer not null,
  created_by uuid default auth.uid(),
  created_by_email text default (auth.jwt() ->> 'email'),
  created_at timestamptz not null default now()
);

alter table public.ledger enable row level security;

revoke all on public.ledger from anon;
grant select, insert, update, delete on public.ledger to authenticated;

create policy "members read" on public.ledger
  for select to authenticated using (true);
create policy "members insert" on public.ledger
  for insert to authenticated with check (true);
create policy "members update" on public.ledger
  for update to authenticated using (true) with check (true);
create policy "members delete" on public.ledger
  for delete to authenticated using (true);
