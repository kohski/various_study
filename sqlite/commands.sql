-- drop table if exists posts;
-- CREATE table posts (
--   id integer primary key,
--   title text,
--   body text
-- );
-- insert into posts (id, title, body) values (1, 't1', 'b1');
-- insert into posts (id, title, body) values (2, 't2', 'b2');

-- drop table if exists comments;
-- CREATE table comments (
--   id integer primary key,
--   post_id integer,
--   comment text
-- );

-- insert into comments (id, post_id, comment) values (1, 1, 'c1');
-- insert into comments (id, post_id, comment) values (2, 1, 'c2');

-- .headers on
-- .mode column

-- -- 内部結合によるデータの抽出
-- -- select * from posts inner join comments on posts.id = comments.post_id;
-- -- select posts.id, title, comment from posts inner join comments on posts.id = comments.post_id;

-- -- 外部結合
-- select * from posts left outer join comments on posts.id = comments.post_id;
-- select * from comments left outer join posts on posts.id = comments.post_id;

-- -- 交差結合
-- select * from posts cross join comments;

-- drop table if exists users;
-- create table if not exists users (
--   id integer primary key autoincrement,
--   name text
-- );
-- insert into users (name) values ('a');
-- insert into users (name) values ('b');
-- insert into users (name) values ('taguchi');

-- .headers on
-- .mode column

-- select rowid, * from users; -- primary keyを設定するとrowidを参照しにいく
-- delete from users where name = 'c';
-- insert into users (name) values ('d');
-- select rowid, * from users; 


-- .output sample.dump.sql
-- .dump users

drop table if exists users;

create table users (
  name text,
  score integer
);

insert into users (name, score) values ('aaa',10);
insert into users (name, score) values ('bbb',20);
insert into users (name, score) values ('ccc',30);

.mode csv
create table temp (
  name,
  score
);
.import source.csv temp

insert into users select name, score from temp;
drop table if exists temp;


.headers on
.mode column
select * from users;

.header off
.mode csv
.output users_data.csv
select * from users;
