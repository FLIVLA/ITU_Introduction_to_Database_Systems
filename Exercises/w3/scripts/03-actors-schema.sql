-- Sample actors database
-- (c) Eleni Tzirita Zacharatou, 2022
-- based on material from Bjorn Thor Jonsson, 2016-2022
-- Introduction to Database Systems @ ITU


drop table if exists Roles;
drop table if exists Movies;
drop table if exists Plays;
drop table if exists Actors;


create table Actors(
  AID integer primary key,
  aName varchar(50), 
  aGender char(1)
);

create table Plays(
  PID integer primary key,
  pName varchar(50), 
  pAuthor varchar(50)
);

create table Movies(
  MID integer primary key,
  PID integer references Plays,
  mYear integer
);

create table Roles(
  RID integer primary key,
  MID integer references Movies,
  AID integer references Actors,
  rName varchar(50), 
  salary integer
);

insert into Actors values (1, 'Harrison Ford', 'M');
insert into Actors values (2, 'Geena Davis', 'F');
insert into Actors values (3, 'Tom Hanks', 'M');
insert into Actors values (4, 'Meryl Streep', 'F');

insert into Plays values (1, 'Hamlet', 'Shakespeare');
insert into Plays values (2, 'Of Mice and Men', 'Steinbeck');
insert into Plays values (3, 'Romeo and Juliet', 'Shakespeare');
insert into Plays values (4, 'Whom the Bell Tolls', 'Hemingway');

insert into Movies values (1, 1, 2009);
insert into Movies values (2, 1, 2016);
insert into Movies values (3, 2, 2015);
insert into Movies values (4, 3, 2009);
insert into Movies values (5, 3, 2001);
insert into Movies values (6, 4, 2001);

insert into Roles values (1, 4, 1, 'Romeo', 20000);
insert into Roles values (2, 4, 2, 'Juliet', 30000);
insert into Roles values (3, 5, 3, 'Romeo', 1000);
insert into Roles values (4, 5, 4, 'Juliet', 100000);

insert into Roles values (5, 1, 1, 'Hamlet', 10000);
insert into Roles values (6, 1, 2, 'Hamlet''s mother', 30000);

insert into Roles values (7, 3, 1, 'Bill', 1000);
insert into Roles values (8, 3, 1, 'Ted', 1000);

insert into Roles values (9, 6, 1, 'Gustavo', 1000);
insert into Roles values (10, 6, 1, 'Alonso', 1000);
 