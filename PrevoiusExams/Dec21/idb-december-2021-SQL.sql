-- (a)

-- X chefs have created at least one recipe. How many have not?

select count(distinct R.created_by)
from recipes R;
-- 410

select count(*)
from chefs C left join recipes R on C.id = R.created_by
where R.created_by is null;
-- 6

-- (b)

select count(distinct M.recipe_id)
from chefs C 
	join master M on C.id = M.chef_id
	join use U on M.recipe_id = U.recipe_id
	join ingredients I on U.ingredient_id = I.id
where C.name = 'Foodalicious'
	and I.type = 'spice';
-- 56

select count(distinct M.recipe_id)
from chefs C 
	join master M on C.id = M.chef_id
	join use U on M.recipe_id = U.recipe_id
	join ingredients I on U.ingredient_id = I.id
where C.name = 'Spicemaster'
	and I.type = 'spice';
-- 57

-- (c)

select count(*)
from (
	select S.recipe_id
	from steps S
	group by S.recipe_id
	having count(distinct S.step) >= 10
) X;
-- 1257

select count(*)
from recipes
where id not in (
	select S.recipe_id
	from steps S
	group by S.recipe_id
	having count(distinct S.step) > 3
);
-- 1149 

-- (d)

select count(distinct R.id)
from recipes R
	join use U on R.id = U.recipe_id
	join belong_to B on B.ingredient_id = U.ingredient_id
where R.belong_to = B.cuisine_id;
-- 882

-- (e)

drop view if exists step_view;
create view step_view 
as
select S.recipe_id, count(distinct S.step) as cnt
from steps S
group by S.recipe_id;

select R.name
from step_view S
	join recipes R on S.recipe_id = R.id
where S.cnt = (select max(cnt) from step_view);
-- "Fresh Tomato Salsa Restaurant-Style"

drop view if exists ingr_view;
create view ingr_view 
as
select U.recipe_id, count(distinct U.ingredient_id) as cnt
from use U
group by U.recipe_id;

select R.name
from ingr_view S
	join recipes R on S.recipe_id = R.id
where S.cnt = (select max(cnt) from ingr_view);
-- "Dinengdeng"

-- (f)

drop view if exists spice_count;
create view spice_count
as
select CU.id, count(*) as spice_count
from cuisines CU
	join belong_to B on CU.id = B.cuisine_id
	join ingredients I on B.ingredient_id = I.id
where I.type = 'spice'
group by CU.id;

drop view if exists all_count;
create view all_count
as
select CU.id, count(*) as all_count, SC.spice_count, 1.0*SC.spice_count/count(*) as ratio
from cuisines CU
	join belong_to B on CU.id = B.cuisine_id
	join ingredients I on B.ingredient_id = I.id
	join spice_count SC on CU.id = SC.id
group by CU.id, SC.spice_count;

select count(*)
from all_count
where ratio = (select max(ratio) from all_count);
-- 8

select count(*)
from all_count
where ratio = (select min(ratio) from all_count);
-- 7

-- (g)

select count(*)
from (
	select U.recipe_id --, count(*), count(distinct I.type)
	from use U 
		join ingredients I on U.ingredient_id = I.id
	group by U.recipe_id
	having count(distinct I.type) = (
		select count(distinct type)
		from ingredients I
	) 
) X;
-- 4169

select count(distinct X.recipe_id)
from (
	select U.recipe_id, U.step, count(*), count(distinct I.type)
	from use U 
		join ingredients I on U.ingredient_id = I.id
	group by U.recipe_id, U.step
	having count(distinct I.type) = (
		select count(distinct type)
		from ingredients I
	) 
) X;
-- 2722

-- (h)

drop view if exists indian_chefs;
create view indian_chefs as
select C.id, C.name
from chefs C
     join recipes R on R.created_by = C.id
     join cuisines CU on CU.id = R.belong_to
where CU.name like '%Indian%';

select C.id, C.name, count(quantity)
from indian_chefs C
     join recipes R on R.created_by = C.id
     join use U on U.recipe_id = R.id --18m
     join belong_to B on B.ingredient_id = U.ingredient_id
     join cuisines CU on CU.id = B.cuisine_id
where CU.name like '%Thai%'
group by C.id, C.name
order by count(quantity) desc

-- 60	"Rocco DiSpirito"	12
-- 30	"Ettore Boiardi"	12
-- 175	"John Shields"	10
-- 140	"Raymond Oliver"	10
-- 122	"Cyril Lignac"	8
-- etc / 150 rows in total

