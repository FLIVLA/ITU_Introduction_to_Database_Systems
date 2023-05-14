-- Week 3: Advanced SQL
--         Examples with Coffees

-- SLIDE 4
select * from Drinkers;
select * from Coffees;
select * from Coffeehouses;
select * from Sells;
select * from Likes;
select * from Frequents;

-- SLIDE 6
-- Names of coffeehouses that sell all coffees!
-- How many coffees?
select count(*) 
from Coffees;

-- Check Sells
select *
from Sells;

-- Make a GROUP BY
select S.coffeehouse, count(*)
from Sells S 
group by S.coffeehouse;

-- Only return coffeehouses with 2 coffees
select S.coffeehouse, count(*)
from Sells S 
group by S.coffeehouse
having count(coffee) = 2;

-- Run the full division
select S.coffeehouse 
from Sells S 
group by S.coffeehouse 
having count(coffee) = ( 
	select count(*) 
	from Coffees
); 

-- SLIDE 7
-- Names of drinkers who frequent all coffeehouses!
select F.drinker 
from Frequents F 
group by F.drinker 
having count(F.coffeehouse) = ( 
	select count(*) 
	from Coffeehouses
); 

-- SLIDE 8
-- Names of coffees that are sold at all coffeehouses!
select S.coffee
from Sells S 
group by S.coffee 
having count(coffeehouse) = ( 
	select count(*) 	
	from Coffeehouses
); 

-- SLIDES 9-10
-- See solution for E2

-- SLIDE 13
-- NATURAL JOIN
SELECT *
FROM Likes L NATURAL JOIN Frequents F;

-- Dangerous: What attributes are common?
SELECT *
FROM Drinkers D NATURAL JOIN Coffeehouses H;

-- CROSS JOIN
SELECT *
FROM Likes L CROSS JOIN Drinkers D;

-- CROSS JOIN simulation
SELECT *
FROM Likes L JOIN Drinkers D ON 1 = 1;

-- SLIDE 14: JOIN syntax
-- ANSI
SELECT *
FROM Likes L 
    JOIN Drinkers D
    ON L.drinker = D. name;

-- Old style
SELECT *
FROM Likes L, Drinkers D
WHERE L.drinker = D. name;

-- Forgetting JOIN conditions:
-- ANSI -- gives an error!
SELECT *
FROM Likes L 
    JOIN Drinkers D;

-- Old style -- gives a cross join!
SELECT *
FROM Likes L, Drinkers D;

-- SLIDE 16
-- From Coffees(name, manufacturer), find all pairs of coffees 
-- by the same manufacturer.

-- Step 1: Produce all the pairs
SELECT * 
FROM Coffees C1 CROSS JOIN Coffees C2;

-- Step 2: Make sure only coffees by the same manufacturer show up
SELECT * 
FROM Coffees C1 JOIN Coffees C2
ON C1.manufacturer = C2.manufacturer 

-- Step 3: Remove the self-pairings (here there are no other pairs)
SELECT C1.name, C2.name 
FROM Coffees C1 JOIN Coffees C2
ON C1.manufacturer = C2.manufacturer 
WHERE C1.name < C2.name;

-- Same thing, but within the JOIN condition 
SELECT C1.name, C2.name 
FROM Coffees C1 JOIN Coffees C2
ON C1.manufacturer = C2.manufacturer AND C1.name < C2.name;

-- SLIDE 17
-- Show all coffees that are more expensive than 
-- some other coffee sold at the same coffeehouse

-- Step 1: Show all pairs within the same coffeehouse
select *
from Sells S1 join Sells S2 on S1.coffeehouse = S2.coffeehouse;

-- Step 2: Remove the unwanted pairs
select *
from Sells S1 join Sells S2 on S1.coffeehouse = S2.coffeehouse
where S1.coffee <> S2.coffee and S1.price > S2.price;

-- Step 3: Show only the coffee name
select S1.coffee
from Sells S1 join Sells S2 on S1.coffeehouse = S2.coffeehouse
where S1.price > S2.price;

select *
from sells;

-- SLIDE 18
-- Add one record
INSERT INTO Sells( coffeehouse, coffee, price ) 
VALUES( 'Mocha', 'Kopi luwak', 400 );

-- Correction: Remove columns AND DUPLICATES!
select DISTINCT S1.coffee
from Sells S1 join Sells S2 on S1.coffeehouse = S2.coffeehouse
where S1.price > S2.price;

-- SLIDE 30
-- Show all drinkers and the coffees they like, 
-- but include drinkers that do not like any coffees
insert
into Drinkers (name, address, phone)
values ('Peter Sestoft', 'Amager', 55555555);

select *
from Drinkers D join Likes L on D.name = L.drinker;

select *
from Drinkers D left outer join Likes L on D.name = L.drinker;

select *
from Likes L right outer join Drinkers D on D.name = L.drinker;

-- SLIDE 31
-- Can you use OUTER JOIN to show only drinkers 
-- who do not like any coffees?
select D.name
from Drinkers D
left outer join Likes L on D.name = L.drinker
where L.coffee is null;

-- SLIDE 35
-- Show all drinkers that like “Kopi luwak” or live in “Amager”
select L.drinker
from Likes L
where L.coffee = 'Kopi Luwak'
union
select D.name
from Drinkers D
where D.address = 'Amager'

-- SLIDE 36
-- Show all coffees that are manufactured by “Marley Coffee” 
-- and sold at an unknown price
select C.name 
from Coffees C 
where C.manufacturer = 'Marley Coffee' 
intersect 
select S.coffee 
from Sells S 
where S.price is NULL;

-- SLIDE 37
-- Show all coffeehouses at ‘Amager’ 
-- that don‘t sell a coffee with an unknown price
select H.name 
from Coffeehouses H 
where H.address = 'Amager' 
except 
select S.coffeehouse 
from Sells S 
where S.price is null; 

-- SLIDE 43
-- Find the coffeehouses that serve some coffee 
-- for the same price Mocha charges for Blue Mountain
-- Two queries:
select price 
from Sells
where coffeehouse = 'Mocha' 
  and coffee = 'Blue Mountain';

select distinct coffeehouse
from Sells
where price =  300;

-- SLIDE 44
-- Find the coffeehouses that serve some coffee 
-- for the same price Mocha charges for Blue Mountain
-- One query:
select distinct coffeehouse
from Sells 
where price = ( 
  select price 
  from Sells
  where coffeehouse = 'Mocha' 
    and coffee = 'Blue Mountain'
); 

-- SLIDE 45
-- Find the coffeehouses (using JOIN) that serve 
-- some coffee for the same price Mocha charges for Blue Mountain
select distinct S1.coffeehouse 
from Sells S1, Sells S2 
where S1.price = S2.price 
  and S2.coffeehouse = 'Mocha' 
  and S2.coffee = 'Blue Mountain';   

-- SLIDE 48
-- Show the name of all coffeehouses that no-one frequents!
insert 
into Coffeehouses 
values ('Kaffitar', 'Stroget', 'No question');

select H.name
from Coffeehouses H 
where H.name not in (
    select S.coffeehouse
    from Sells S
);  

-- SLIDE 49
-- Show all drinkers that like “Kopi luwak” 
-- or live in “Amager”
select D.name
from Drinkers D
where D.address = 'Amager'
or D.name in (
  select L.drinker
  from Likes L
  where L.coffee = 'Kopi luwak'
);

-- SLIDE 50
-- Show all coffees that are manufactured by “Marley Coffee” 
-- and sold at an unknown price
select C.name 
from Coffees C 
where C.manufacturer = 'Marley Coffee' 
and C.name in (
  select S.coffee 
  from Sells S 
  where S.price is NULL
);

-- SLIDE 51
-- Show all coffeehouses at ‘Amager’ 
-- which don‘t sell a coffee with an unknown price
select H.name 
from Coffeehouses H 
where H.address = 'Amager'
and H.name not in (
    select S.coffeehouse 
    from Sells S 
    where S.price is null
); 

-- SLIDE 58
-- Using NOT EXISTS, show the name of all coffeehouses 
-- that no-one frequents!
select H.name 
from Coffeehouses H 
where not exists ( 
 	select * 
	from Sells S 
	where S.coffeehouse = H.name
);

-- SLIDE 64
-- Names of coffeehouses that sell all coffees!
-- This is division!
select H.name 
from Coffeehouses H 
where not exists (
 	select * 
	from Coffees C 
	where not exists ( 
		select * 
		from Sells S 
		where H.name = S.coffeehouse 
		  and C.name = S.coffee
	)
);

-- SLIDE 65
-- Names of drinkers who frequent all coffeehouses!
select D.name 
from Drinkers D 
where not exists ( 
	select * 
	from Coffeehouses H 
	where not exists ( 
		select * 
		from Frequents F 
		where D.name = F.drinker 
		  and H.name = F.coffeehouse
	)
);

-- SLIDE 66
-- Names of coffees that are sold at all coffeehouses!
select C.name
from Coffees C 
where not exists (
 	select *
	from Coffeehouses H
	where not exists (
		select *
		from Sells S
		where H.name = S.coffeehouse
		  and C.name = S.coffee
	)
);

-- SLIDE 66
-- Are they equivalent?
-- Run queries from 66 and 8, then delete below 
-- (or drop tables and recreate empty), then run queries again
delete from Sells;
delete from Frequents;
delete from Coffeehouses;

-- SLIDE 8 -- repeated for convenience!
select S.coffee 
from Sells S 
group by S.coffee 
having count(coffeehouse) = ( 
	select count(*) 	
	from Coffeehouses
);

-- SLIDE 69
-- For each coffeehouse, show all coffees that are 
-- more expensive than some other coffee sold at that bar!
select S.coffeehouse, S.coffee
from Sells S
where S.price > ANY (
	select S2.price
	from Sells S2
	where S.coffeehouse = S2.coffeehouse
	  and S.coffee <> S2.coffee
);

-- SLIDE 72
-- For each coffeehouse, show the most expensive coffee(s) 
-- sold at that coffeehouse!
select S.coffeehouse, S.coffee
from Sells S
where S.price >= ALL (
	select S2.price
	from Sells S2
	where S.coffeehouse = S2.coffeehouse
	  and S2.price is not null
);

