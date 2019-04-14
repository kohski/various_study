drop table if exists comments;

create table comments (
  id integer primary key,
  body text
);
insert into comments (body) values ('comment 1');
insert into comments (body) values ('comment 2');
insert into comments (body) values ('comment 3');