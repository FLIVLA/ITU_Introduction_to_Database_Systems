-- Week 3: Advanced SQL
--         Examples of Actors

-- 95: ID and name of actors who have performed in movies based on all plays
-- First incorrect version!
select A.AID, A.aName
from Actors A
	join Roles R on A.AID = R.AID
	join Movies M on R.MID = M.MID
	join Plays P on M.PID = P.PID
group by A.AID, A.aName
having count(*) = (
	select count(*)
	from Plays
);

-- Correct version!
-- Note that a JOIN with Plays does not make it incorrect, 
-- only less efficient
-- The count(distinct M.PID) is the key to correctness, 
-- as many movies can be related to a single play

select A.AID, A.aName
from Actors A
	join Roles R on A.AID = R.AID
	join Movies M on R.MID = M.MID
group by A.AID, A.aName
having count(distinct M.PID) = (
	select count(*)
	from Plays
);

-- Of female actors …
-- Plays by Shakespeare
-- Movies produced in 2009
select A.AID, A.aName
from Actors A 
    join Roles R on R.AID = A.AID
    join Movies M on M.MID = R.MID
    join Plays P on M.PID = P.PID
where A.aGender = 'F'
  and P.pAuthor = 'Shakespeare'
  and M.mYear = 2009
group by A.AID, A.aName
having count(distinct M.PID) = (
    select count(*)
    from Plays P
    where P.pAuthor = 'Shakespeare' );

-- To see why it is necessary to have author condition on both sides, 
-- consider this query, which selects all actors who performed 
-- in all (both) plays by Shakespeare. If you remove either of 
-- the conditions, the result becomes incorrect
select A.AID, A.aName
from Actors A
	join Roles R on A.AID = R.AID
	join Movies M on R.MID = M.MID
	join Plays P on M.PID = P.PID
where P.pAuthor = 'Shakespeare'
group by A.AID, A.aName
having count(distinct M.PID) = (
	select count(*)
	from Plays P1
	where P1.pAuthor = 'Shakespeare'
);

-- 96: ID and name of actors who have performed in all plays
select A.AID, A.aName
from Actors A
where not exists (
	select *
	from Plays P
	where not exists (
		select *
		from Roles R join Movies M on R.MID = M.MID
		where R.AID = A.AID
		  and M.PID = P.PID));

-- Of female actors …
-- Produced in 2009
-- Plays by Shakespeare
select *
from Actors A
where A.aGender = 'F'
  and not exists (
    select *
    from Plays P
    where P.pAuthor = 'Shakespeare'
      and P.PID in (
        select M.PID 
        from Movies M 
        where M.mYear = 2009 )
      and not exists (	
        select *
        from Movies M join Roles R on M.MID = R.MID
        where R.AID = A.AID
          and M.PID = P.PID
          and M.mYear = 2009 ) );

-- 97: ID and name of all actors who have had a role in two movies
select A.AID, A.aName
from Actors A 
	join Roles R on A.AID = R.AID
group by A.AID, A.aName
having count(distinct R.MID) > 1;

-- Only the name, but with correct duplicates!
-- Incorrect version!
select A.aName
from Actors A 
	join Roles R on A.AID = R.AID
group by A.aName
having count(distinct R.MID) > 1;

-- Correct version!
select A1.aName 
from (
	select A.AID, A.aName
	from Actors A 
		join Roles R on A.AID = R.AID
	group by A.AID, A.aName
	having count(distinct R.MID) > 1
) A1;

-- 98: ID and name of actors who have had two roles in a movie at least twice

select A1.AID, A1.aName 
from (
	select A.AID, A.aName, R.MID
	from Actors A 
		join Roles R on A.AID = R.AID
	group by A.AID, A.aName, R.MID
	having count(*) > 1
) A1
group by A1.AID, A1.aName
having count(*) > 1;


