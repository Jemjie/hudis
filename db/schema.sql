drop schema if exists app_public cascade;
create extension if not exists citext;
create schema app_public;

create domain app_public.url as text check (value ~ '^https?://[^/]+');

create type app_public.profile_status as enum (
  'CURRENT',
  'PAST',
  'POTENTIAL',
  'FOLLOWER',
  'NONE'
);

create table app_public.people (
  id serial primary key,
  nickname text not null check(length(nickname) > 0 and length(nickname) < 80),
  business_name text,
  business_url app_public.url,
  business_logo_url app_public.url
);

create table app_public.services (
  id serial primary key,
  name text not null,
  slug citext not null unique check(length(slug) < 40 and length(slug) > 0 and slug ~ '^[a-z][a-z0-9_]*$')
);

create table app_public.profiles (
  id serial primary key,
  person_id int references app_public.people,
  service_id int not null references app_public.services,
  real_name text,
  username text, 
  email text,
  avatar_url app_public.url,
  monthly_income int,
  total_income int,
  status app_public.profile_status,
  check(real_name is not null or username is not null),
  unique(service_id, username)
);

create table app_public.interactions (
  id serial primary key,
  profile_id int not null references app_public.profiles,
  date timestamptz not null default now(),
  description text not null, 
  requires_action boolean not null default false,
  note text not null default ''
);

-------------------------------------------------------------

insert into app_public.services (name, slug) values
  ('gitter', 'gitter'),
  ('twitter', 'twitter'),
  ('Patreon', 'patreon'),
  ('email', 'email'),
  ('GitHub', 'github'),
  ('Client', 'client'),
  ('Slack', 'slack'),
  ('Reddit', 'reddit'),
  ('Reactiflux', 'reactiflux');

insert into app_public.profiles (service_id, real_name, username) values
  (1, 'John Gitter', 'joner'),
  (2, 'Jack Twitter', 'jack'),
  (3, 'Princess Patreon', 'Princess'), 
  (5, 'Gerri Github', 'gerrigithub');
  

insert into app_public.people (nickname) values
  ('Ellie Client');

insert into app_public.profiles (person_id, service_id, real_name, username) values
  (1, 1, 'Ellie C', 'elliec'),
  (1, 3, 'Ellie Client', 'Ellie Client'),
  (1, 4, 'Ellie Client', 'Ellie C'),
  (1, 5, 'Ellie C', 'elliex111');

insert into app_public.interactions (profile_id, description) values
  (1, 'Lets work on postgraphile'),
  (2, 'Issue 345'),
  (3, 'Work on Lambda'),
  (3, 'Did you work on Lamba?'),
  (6, 'Can you work with me please?'),
  (7, 'OK here is my private issue');