-- MyProgress Supabase schema. Run this in Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists profiles (id uuid primary key references auth.users(id) on delete cascade, display_name text, language text default 'lt', created_at timestamptz default now());
create table if not exists weights (id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, value numeric(6,2) not null, recorded_at date not null default current_date, created_at timestamptz default now());
create table if not exists measurements (id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, type text not null, value numeric(6,2) not null, recorded_at date not null default current_date, created_at timestamptz default now());
create table if not exists exercises (id uuid primary key default gen_random_uuid(), user_id uuid references auth.users(id) on delete cascade, name text not null, muscle text, image_url text, created_at timestamptz default now());
create table if not exists workouts (id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, name text not null, exercise_id uuid references exercises(id) on delete set null, sets int, reps int, weight numeric(7,2), notes text, recorded_at date not null default current_date, created_at timestamptz default now());
create table if not exists nutrition (id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, recorded_at date not null default current_date, calories int, protein numeric(7,2), carbs numeric(7,2), fat numeric(7,2));
create table if not exists goals (id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, goal_weight numeric(6,2), weekly_workouts int, calories int, protein numeric(7,2), carbs numeric(7,2), fat numeric(7,2), updated_at timestamptz default now());
create table if not exists progress_photos (id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, storage_path text not null, recorded_at date not null default current_date, created_at timestamptz default now());

alter table profiles enable row level security; alter table weights enable row level security; alter table measurements enable row level security; alter table exercises enable row level security; alter table workouts enable row level security; alter table nutrition enable row level security; alter table goals enable row level security; alter table progress_photos enable row level security;

create policy "own profiles" on profiles for all using (auth.uid()=id) with check (auth.uid()=id);
create policy "own weights" on weights for all using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "own measurements" on measurements for all using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "own exercises" on exercises for all using (auth.uid()=user_id or user_id is null) with check (auth.uid()=user_id or user_id is null);
create policy "own workouts" on workouts for all using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "own nutrition" on nutrition for all using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "own goals" on goals for all using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "own photos" on progress_photos for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

insert into storage.buckets (id,name,public) values ('progress-photos','progress-photos',false) on conflict (id) do nothing;
create policy "own photo objects" on storage.objects for all using (bucket_id='progress-photos' and (storage.foldername(name))[1]=auth.uid()::text) with check (bucket_id='progress-photos' and (storage.foldername(name))[1]=auth.uid()::text);
