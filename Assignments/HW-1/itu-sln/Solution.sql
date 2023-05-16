-- person(id, name, gender, ... )\
-- movie(id, title, year, ...)\
-- genre(genre, category)\
-- movie genre(movieId, genre)\
-- role(role)\
-- involved(movieId, personId, role)

-- Q1\

select count(*)
from person
where gender is not null;
-- 51052

select count(*) 
from person
where gender = 'f';
-- 17698

-- Q2

select count(*)
from (
	select movieId, avg(P.height)
	from Involved I
		join person P on I.personId = P.ID
	group by I.movieId
	having avg(P.height) < 165
) X;
-- 365

select count(*)
from (
	select movieId, avg(P.height)
	from Involved I
		join person P on I.personId = P.ID
	group by I.movieId
	having avg(P.height) > 190
) X;
-- 17

-- Q3

select max(count_genre)
from (
	select movieid, count(*) as count_genre from movie_genre
	group by movieid, genre
) X;

-- Q4

select count(distinct I1.personId)
from involved I1 
    join involved I2 on I1.movieId = I2.movieId
	join person P on I2.personId = P.id
where I1.role = 'actor'
  and I2.role = 'director'
  and P.name = 'Francis Ford Coppola';
-- 476

select count(distinct I1.personId)
from involved I1 
    join involved I2 on I1.movieId = I2.movieId
	join person P on I2.personId = P.id
where I1.role = 'actor'
  and I2.role = 'director'
  and P.name = 'Roger Spottiswoode';
-- 303

-- Q5

select count(*)
from movie M 
	left join involved I on M.id = I.movieId
where M.year = 2002
and I.movieID is null;
-- 12

select count(*)
from movie M
where M.year = 2002
  and M.id not in (
	select I.movieId
    from involved I
);
-- 12

select count(*)
from movie M 
	left join involved I on M.id = I.movieId
where M.year = 2011
and I.movieID is null;
-- 3

select count(*)
from movie M
where M.year = 2011
  and M.id not in (
	select I.movieId
    from involved I
);
-- 3

-- Q6

select count(*)
from (
	select I1.personId, count(*)
	from involved I1
		join involved I2 on I1.movieId = I2.movieId and I1.personId = I2.personId
	where I1.role = 'actor' 
		and I2.role = 'director'
	group by I1.personId
	having count(*) = 1
) X;
-- 603

select max(count_both_actdir)
from (
	select count(*) as count_both_actdir from involved I1
	join involved I2 on I1.movieid = I2.movieid and I1.personid = I2.personid
	where I1.role = 'actor' AND I2.role = 'director'
	group by I1.personid
) x;
-- 28

-- Q7

select count(*)
from (
	select M.id
	from movie M
		join involved I on M.id = I.movieId    
	where M.year = 2002
	group by M.id
	having count(distinct I.role) = (
		select count(*)
		from role R
	)
) X;
-- 282

select count(*)
from (
	select M.id
	from movie M
		join involved I on M.id = I.movieId    
	where M.year = 2011
	group by M.id
	having count(distinct I.role) = (
		select count(*)
		from role R
	)
) X;
-- 89

-- Q8 -- counting

select count(*)
from (
    select I.personId
	from involved I 
		join movie_genre MG on MG.movieId = I.movieId
		join genre G on MG.genre = G.genre
	where G.category  = 'Newsworthy'
	group by I.personId
	having count(distinct G.genre) = (
		select count(*)
		from genre
		where category = 'Newsworthy'
	)
) X;
-- 156

select count(*)
from (
	select I.personId
	from involved I 
		join movie_genre MG on MG.movieId = I.movieId
		join genre G on MG.genre = G.genre
	where G.category  = 'Popular'
	group by I.personId
	having count(distinct G.genre) = (
		select count(*)
		from genre
		where category = 'Popular'
	)
) X;
-- 9693


-- Q8 -- double negation\

select count(P.id)
from person P
where not exists(
    select *
    from genre G
    where G.category = 'Newsworthy'
      and not exists(
        select *
        from movie_genre MG
            join involved I on MG.movieid = I.movieid
       	where I.personid  = P.id
	  and G.genre = MG.genre
     )
);
-- 156


select count(P.id)\
from person P\
where not exists(\
    select *\
    from genre G\
    where G.category = 'Popular'\
      and not exists(\
        select *\
        from movie_genre MG\
            join involved I on MG.movieid = I.movieid\
        where I.personid  = P.id\
          and G.genre = MG.genre\
     )\
);\
-- 9693}