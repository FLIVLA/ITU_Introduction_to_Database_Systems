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
-- ADVANCED QUERIES                        
--------------------------------------------------------------------------------
/* 14. Show the ID, name, and height of athletes who have achieved the best result
in each sport, along with the result, the name of the sport, and a column
called ‘record?’ which contains 1 if the result is a record or 0 if the result is
not a record. Note that for each sport there may be many athletes who
share the best result, in this case all the rows should be in the result. If you
can print ‘yes’ and ‘no’ instead of 1 and 0, all the better.
This query can use the = (SELECT MAX ...) pattern from Week 1 (slide 64).
Note that this version of this query will (most likely) execute quite slowly,
while using an IN sub-query it will run much faster. Next week, you can test
both versions to make the performance comparison.
This query should return 39 rows, with 6 columns each. Two example rows:
204, Inge Jensen, 1.7, 6.78, Long Jump, Yes
221, Jan Hansen, 1.75, 25.2, Discus, No */

-- SOLUTION:
SELECT people.id, people.name, people.height, result.result
FROM people
INNER JOIN results
ON results.peopleid = people.id
INNER JOIN sports 
ON sports.id = 
GROUP BY dfgdg