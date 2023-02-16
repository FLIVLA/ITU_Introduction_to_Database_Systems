--------------------------------------------------------------------------------
-- INTRODUCTION TO DATABASE SYSTEMS
--                         __     ________  
--  __  _  __ ____   ____ |  | __ \_____  \ 
--  \ \/ \/ // __ \_/ __ \|  |/ /  /  ____/ 
--   \     /\  ___/\  ___/|    <  /       \ 
--    \/\_/  \___  >\___  >__|_ \ \_______ \
--               \/     \/     \/         \/
--
--------------------------------------------------------------------------------
-- BASIC QUERIES                        
--------------------------------------------------------------------------------
-- 1. The name and record of all sports sorted by name.

-- SOLUTION:
SELECT name, record 
FROM sports
ORDER BY name

--------------------------------------------------------------------------------
/* 2. The name of all sports with at least one result.
For this query, you need to join the Results table to ensure
existence of results, and the Sports table to retrieve the name
of the sport. On this database instance, all 7 sports are returned. */

-- SOLUTION:
SELECT DISTINCT sports.name
FROM sports
JOIN results 
ON results.sportid = sports.id
WHERE results.result > 0
ORDER BY sports.name

--------------------------------------------------------------------------------
/* 3. The number of athletes who have competed in at least one sport.
This query requires only one table since you don’t need any information about
the people. It should give the result 251. */

-- SOLUTION:
SELECT COUNT(DISTINCT peopleid) 
AS Number_Of_Athletes 
FROM RESULTS -- returns 251.

--------------------------------------------------------------------------------
/* 4. The ID and name of athletes who have at least twenty results.
This query requires to JOIN two tables, GROUP BY the athlete IDs and use
HAVING to check for number of rows. It should return 194 rows; */

-- SOLUTION:
SELECT people.id, people.name, COUNT(results) AS result_count
FROM people
INNER JOIN results
ON results.peopleid = people.id
GROUP BY people.id
HAVING COUNT(results) >= 20 -- returns 194 rows.

--------------------------------------------------------------------------------
/* 5. The ID, name and gender description of all athletes that currently hold a
record. This query requires joining four tables (People, Gender, Results, 
and Sports),as well as one WHERE condition. It should return 33 rows. */

-- SOLUTION:
SELECT DISTINCT(people.id), people.name, gender.description
FROM people
INNER JOIN gender
ON gender.gender = people.gender
INNER JOIN results
ON results.peopleid = people.id
INNER JOIN sports
ON sports.id = results.sportid
WHERE sports.record = results.result -- returns 33 rows

--------------------------------------------------------------------------------
/* 6. For each sport, where some athlete holds the record, the name of the sport
and the number of athletes that hold a record in that sport; the last column
should be named “numathletes”. This query only requires joining two tables
but adds a GROUP BY. The results are shown right. For example, Long Jump has 
a total of 22 people that have equaled the record, while one sport does not yield 
a result row. */

-- SOLUTION:
SELECT sports.name, COUNT(results) AS result_count
FROM sports 
INNER JOIN results
ON results.sportsid = sports.id
GROUP BY sports.name 
HAVING COUNT(results) >= 1 AND sports.record IS NOT NULL

/* Question: How can the total number of
people that have equaled a record in some
sport, which is 38, be larger than the 33 from the previous query? */

--------------------------------------------------------------------------------
/* 7. The ID and name of each athlete that has at least twenty results in the 
triple jump, their best result, along with the difference between the record and
their best result. The second-to-last column should be named “best” while
the last column should be named “difference”. The last column should
always contain non-negative values and should preferably be formatted to
show at least one digit before the decimal point and exactly two digits after
the decimal point. */

-- SOLUTION:
SELECT people.id, people.name 
FROM people
INNER JOIN 

--------------------------------------------------------------------------------
/* 8. The ID, name and gender description of all athletes who participated in the
competition held in Hvide Sande in 2009.
You will need to join four tables to find the result here. You can use the
PostgreSQL-specific code extract(year from C.held) to find the year. This
query should return 84 rows. */

-- SOLUTION:
SELECT DISTINCT(people.id), people.name, gender.description
FROM people
INNER JOIN gender 
ON gender.gender = people.gender
INNER JOIN results
ON results.peopleid = people.id
INNER JOIN competitions
ON competitions.id = results.competitionid
WHERE competitions.place = 'Hvide Sande'
AND EXTRACT(YEAR FROM competitions.held) = 2009 -- returns 84 rows.

-- NOTES:
-- "EXTRACT(YEAR FROM 'clm_name')" - postgreSQL specific syntax

--------------------------------------------------------------------------------
/* 9. The name and gender description of all people with a last name that starts
with a “J” and ends with a “sen” (e.g., Jensen, Jansen, Johansen).
This query should return 82 rows. */

-- SOLUTION:
SELECT people.name, gender.description
FROM people
INNER JOIN gender
ON gender.gender = people.gender
WHERE SPLIT_PART(people.name, ' ', 2) LIKE 'J%sen' -- returns 82 rows

/* NOTES:
 - "SPLIT_PART(clm_name, 'delimiter', item_position)" - SQL string split 
 - ILIKE can be used to make a case-sensitive comparison */

--------------------------------------------------------------------------------
/* 10. For each result, the name of the athlete, the name of the sport, and the
percentage of the record achieved by the result (a result that is a record
should therefore appear as 100; this column should be named
“percentage”). Preferably, format the last column to show only whole
numbers, as well as the % sign, you can use CASE to detect when the result
is NULL and when not. */

-- SOLUTION:
SELECT people.name, sports.name,
    CONCAT(
		CEILING((COALESCE(results.result, 0)/sports.record) * 100), '%'
	) AS percentage  
FROM results
INNER JOIN people
ON people.id = results.peopleid
INNER JOIN sports
ON sports.id = results.sportid

/* NOTES:
 - COALESCE can be used to replace all null values.
 - CEILING is used to roud up to nearest integer.
 - CONCAT is used to format the calculated column,
   in this case to place the '%' behind the percentage value. */  

--------------------------------------------------------------------------------
/* 11. The number of athletes with some incomplete result registrations.
This single-table query should return a single row with a single column: the
number 75. */

-- SOLUTION:
SELECT COUNT(DISTINCT people.id)
FROM people
INNER JOIN results
ON results.peopleid = people.id
WHERE results.result IS NULL

--------------------------------------------------------------------------------
/* 12. For each sport, show the ID and name of the sport and the best
performance over all athletes and competitions. This last column should be
called ‘maxres’ and should be formatted to show at least one digit before
the decimal point and exactly two digits after the decimal point. The query
result should be ordered by the sport ID. */

-- SOLUTION:
SELECT sports.id, sports.name, CAST(MAX(results.result) AS DECIMAL(10,2)) AS maxres
FROM sports
INNER JOIN results
ON results.sportid = sports.id
GROUP BY sports.id, sports.name
ORDER BY sports.id ASC

--------------------------------------------------------------------------------
/* 13. Show the ID and name of athletes who hold a record in at least two sports,
along with the total number of their record-setting or record-equaling
results.
This query requires joining three tables, along with WHERE, GROUP BY and
HAVING clauses. It should return a single row: (25, Jens Jansen, 21). */

-- SOLUTION:
SELECT people.id, people.name
FROM people
INNER JOIN results
ON results.peopleid = people.id
INNER JOIN sports
ON sports.id = results.sportid
WHERE results.result = sports.record
GROUP BY people.id
HAVING count(*) >= 2

-- THIS RETURNS 3 COLUMNS? 
-- ALSO CONFUSED ABOUT CLM3 VALUE?