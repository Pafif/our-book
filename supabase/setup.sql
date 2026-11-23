-- Our Book: one-time setup for Supabase.
-- Paste this whole file into Supabase > SQL Editor > New query, change the two emails
-- in step 1 to yours, and press Run. Running it again is safe.

-- 1. Who may open the book. Only these two emails can read or write anything.
create table if not exists public.members (email text primary key);
insert into public.members (email) values
  ('sebastian.ritkav.007@gmail.com'),
  ('leafrniakova@gmail.com')
on conflict do nothing;

-- 2. The book: one row per entry (story, photo, note, place, wish, film), plus the settings row.
create table if not exists public.memories (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);
create table if not exists public.book (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

-- 3. Access rules: signed in AND on the members list. Nobody else sees or changes a thing.
create or replace function public.is_member() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.members m where lower(m.email) = lower(auth.jwt() ->> 'email'));
$$;

alter table public.members  enable row level security;
alter table public.memories enable row level security;
alter table public.book     enable row level security;

drop policy if exists "members only" on public.memories;
create policy "members only" on public.memories for all to authenticated
  using (public.is_member()) with check (public.is_member());
drop policy if exists "members only" on public.book;
create policy "members only" on public.book for all to authenticated
  using (public.is_member()) with check (public.is_member());
-- (members has no policy, so nobody can read or change it from the app)

-- 4. Private storage for photos.
insert into storage.buckets (id, name, public) values ('photos', 'photos', false)
on conflict (id) do nothing;
drop policy if exists "members read photos"   on storage.objects;
drop policy if exists "members add photos"    on storage.objects;
drop policy if exists "members remove photos" on storage.objects;
create policy "members read photos"   on storage.objects for select to authenticated using (bucket_id = 'photos' and public.is_member());
create policy "members add photos"    on storage.objects for insert to authenticated with check (bucket_id = 'photos' and public.is_member());
create policy "members remove photos" on storage.objects for delete to authenticated using (bucket_id = 'photos' and public.is_member());

-- 5. Live updates, so what one of you adds appears on the other's phone straight away.
do $$ begin
  begin alter publication supabase_realtime add table public.memories; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.book;     exception when duplicate_object then null; end;
end $$;

-- 6. Everything already in your book.
insert into public.book (id, data) values
  ('settings', '{"a": "Sebastian", "b": "Lea", "since": "2026-09-30", "title": "Constellations of love"}'::jsonb)
on conflict (id) do nothing;
insert into public.memories (id, data) values
  ('5ks1rac4zp3akkm7j3w8', '{"created": 1794892388103, "done": false, "from": "", "kind": "watch", "text": "", "title": "Pride and Prejudice"}'::jsonb),
  ('5p65kat1vp4b5yprjtn7', '{"created": 1794892532908, "done": false, "from": "", "kind": "watch", "text": "", "title": "I want to eat your pancreas"}'::jsonb),
  ('atqp97013s54jupd1y9e', '{"created": 1794892909070, "done": false, "kind": "wish", "title": "Match cosplays"}'::jsonb),
  ('b4w454bipdf27ffikjrg', '{"created": 1794892351660, "done": false, "from": "", "kind": "watch", "text": "", "title": "Poor Things"}'::jsonb),
  ('ejeffaot218o23s83bvv', '{"created": 1794892423527, "done": false, "from": "", "kind": "watch", "text": "", "title": "Pearl"}'::jsonb),
  ('fsbcu0ftb7k78xzmkydz', '{"created": 1794892684983, "done": true, "from": "", "kind": "watch", "text": "Film + series", "title": "Scott Pilgrim vs. the World"}'::jsonb),
  ('gf2u1s3j10qqeq9n9evy', '{"created": 1794892577673, "done": true, "from": "", "kind": "watch", "text": "", "title": "Cyberpunk season2"}'::jsonb),
  ('hleakljd6pl64tagsqrn', '{"created": 1794892334412, "done": false, "from": "", "kind": "watch", "text": "", "title": "Helluva Boss season3"}'::jsonb),
  ('hrquecvqrtc4191a4pot', '{"created": 1794892463702, "done": false, "from": "", "kind": "watch", "text": "", "title": "Saiiki K"}'::jsonb),
  ('lt0b15pvemun0ukmxvs2', '{"created": 1794892371957, "done": false, "from": "Lea", "kind": "watch", "text": "", "title": "Fleebag"}'::jsonb),
  ('lydm523s1opcr34gmlmm', '{"created": 1794892776787, "date": "2026-10-16", "kind": "place", "text": "", "title": "Bratislava"}'::jsonb),
  ('nanmlixhje93bsx3st2b', '{"created": 1794892549218, "done": false, "from": "Sebastian", "kind": "watch", "text": "", "title": "Eighty Six"}'::jsonb),
  ('q246am7j6dn1lk38e7rf', '{"created": 1794892445406, "done": false, "from": "", "kind": "watch", "text": "", "title": "Brooklyn 99"}'::jsonb),
  ('q7w4p5465kixmhfqeepm', '{"created": 1794892398063, "done": false, "from": "", "kind": "watch", "text": "", "title": "Nana"}'::jsonb),
  ('uef1omwsprdehhauenmh', '{"created": 1794892429927, "done": false, "from": "", "kind": "watch", "text": "", "title": "The office"}'::jsonb),
  ('ukks2n04yr7ix1t9d9wb', '{"created": 1794892519613, "done": false, "from": "", "kind": "watch", "text": "", "title": "Suzume"}'::jsonb),
  ('viln2kx3qnlljdf4o71m', '{"created": 1794811107147, "done": false, "from": "Sebastian", "kind": "watch", "text": "", "title": "Mushoku Tensei"}'::jsonb),
  ('xcsfipccekykz0cp7cvw', '{"created": 1794811136852, "done": false, "from": "Sebastian", "kind": "watch", "text": "", "title": "Sword Art Online"}'::jsonb)
on conflict (id) do nothing;
