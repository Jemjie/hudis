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
  service_id int not null references app_public.services,
  person_id int references app_public.people,
  real_name text,
  username text, 
  email text,
  avatar_url app_public.url,
  monthly_income int,
  total_income int,
  status app_public.profile_status,
  check(real_name is not null or username is not null)
);