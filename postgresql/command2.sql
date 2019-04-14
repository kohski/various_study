create table users (
  id serial primary key,
  name varchar(255),
  score real,
  team varchar(255)
);

insert into users (name, score, team) values
('taguchi',5.5,'red'),
('fkoji',8.3,'blue'),
('dotinstall',2.2,'green'),
('sasaki',3.1,'blue'),
('sakai',5.0,'red'),
('hirako',4.6,'red'),
('ariyoshi',7.7,'green');