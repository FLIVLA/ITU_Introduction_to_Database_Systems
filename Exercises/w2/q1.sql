
--------------------------------------------------------------------------------
-- INTRODUCTION TO DATABASE SYSTEMS
-- EXERCISES w.2

--------------------------------------------------------------------------------
-- BASIC QUERIES                        
--------------------------------------------------------------------------------
-- 1. The name and record of all sports sorted by name.

SELECT name, record 
FROM sports
ORDER BY name

--------------------------------------------------------------------------------
/* 2. The name of all sports with at least one result.
For this query, you need to join the Results table to ensure
existence of results, and the Sports table to retrieve the name
of the sport. On this database instance, all 7 sports are returned. */

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

SELECT COUNT(DISTINCT peopleid) 
AS Number_Of_Athletes 
FROM RESULTS -- returns 251.

--------------------------------------------------------------------------------
/* 4. The ID and name of athletes who have at least twenty results.
This query requires to JOIN two tables, GROUP BY the athlete IDs and use
HAVING to check for number of rows. It should return 194 rows; */

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

SELECT people.id, people.name, gender.description
FROM people
INNER JOIN gender
ON gender.gender = people.gender
INNER JOIN results
ON results.peopleid = people.id
GROUP BY people.id
