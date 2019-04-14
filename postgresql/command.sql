create table posts (
  id serial primary key,
  title varchar(255) not null,
  body text check(length(body) > 5),
  is_draft boolean default TRUE,
  created_at timestamp default 'now' 
);
