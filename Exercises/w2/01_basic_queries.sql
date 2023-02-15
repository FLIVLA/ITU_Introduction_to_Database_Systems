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
the decimal point.
This query requires a three-way JOIN, along with WHERE, GROUP BY and
HAVING. You can use the PostgreSQL-specific code to_char(S.record-
max(R.result), '0D99') to format the text. This query should return 7
rows. Why is it that, if you do no formatting, the difference has so many digits? */

-- SOLUTION:
SELECT people.id, people.name 
FROM people
INNER JOIN 