/*
██╗██████╗░██████╗░░██████╗░░░░░░░█████╗░░░███╗░░
██║██╔══██╗██╔══██╗██╔════╝░░░░░░██╔══██╗░████║░░
██║██║░░██║██████╦╝╚█████╗░█████╗██║░░██║██╔██║░░
██║██║░░██║██╔══██╗░╚═══██╗╚════╝██║░░██║╚═╝██║░░
██║██████╔╝██████╦╝██████╔╝░░░░░░╚█████╔╝███████╗
╚═╝╚═════╝░╚═════╝░╚═════╝░░░░░░░░╚════╝░╚══════╝
*/

-- SELECT ALL QUERY:
select count(*)
from (
    select ...
) tmp;
-----------------------------------------------------------------------------------------
/* (1) The person relation contains 51,052 entries with a registered gender. How many
records are there with gender ’f’ ? */

-- VERIFY COUNT:
SELECT * FROM person
WHERE gender IS NOT NULL --returns 51.052 rows

-- SOLUTION FOR (1)
SELECT * FROM person
WHERE gender IS NOT NULL
AND gender = 'f' -- returns 17.698 rows

-- SOLUTION FOR (1) - COUNT
SELECT COUNT(*) FROM person
WHERE gender = 'f' -- returns 17.698

-----------------------------------------------------------------------------------------
/* (2) In the database, there are 365 movies for which the average height of all the peo-
ple involved is less than 165 centimeters (ignoring people with unregistered height).
What is the number of movies for which the average height of all people involved is
greater than 195 centimeters? */

-- VERIFY STATEMENT:
SELECT COUNT(*)
FROM movie
WHERE id IN (
  SELECT movieid
  FROM involved
  JOIN person ON involved.personid = person.id
  GROUP BY movieid
  HAVING AVG(height) < 165
  ) -- returns INT 365

-- SOLUTION FOR (2)
SELECT COUNT(*)
FROM movie
WHERE id IN (
  SELECT movieid
  FROM involved
  JOIN person ON involved.personid = person.id
  GROUP BY movieid
  HAVING AVG(height) > 195) -- returns INT 17

-- POSSIBLE OPTIMIZATION
SELECT COUNT(*)
FROM movie
WHERE id IN (
  SELECT movieid
  FROM (
    SELECT movieid, AVG(height) AS avg_height
    FROM involved
    WHERE personid IN (
      SELECT id
      FROM person
      WHERE height IS NOT NULL
    )
    GROUP BY movieid
    HAVING avg_height > 195
  ) AS subquery
)

-----------------------------------------------------------------------------------------
/* (3) The movie genre relation does not have a primary key, which can lead to a movie
having more than one entry with the same genre. What is the highest number of
such duplicated entries in one movie? */

-- SOLUTION FOR (3)
SELECT COUNT(*) as cnt
FROM movie_genre
GROUP BY movieid
HAVING COUNT(*) = (
  SELECT MAX(cnt) FROM (
    SELECT COUNT(*) as cnt
    FROM movie_genre
    GROUP BY movieid
  ) as sub
)

-- ALTERNATIVE
SELECT COUNT(*) as cnt
FROM (
  SELECT COUNT(*) as cnt
  FROM movie_genre
  GROUP BY movieid
) 
HAVING COUNT(*) = (
  SELECT MAX(cnt) 
  FROM (
    SELECT COUNT(*) as cnt
    FROM movie_genre
    GROUP BY movieid
  )
)

-----------------------------------------------------------------------------------------
/* (4) According to the information in the database, 476 different people acted in movies
directed by ‘Francis Ford Coppola’. How many different people acted in movies
directed by ‘Roger Spottiswoode’ ? */

-- VERIFY STATEMENT:


-- SOLUTION FOR (4)


-----------------------------------------------------------------------------------------
/* (5) Of all the movies produced in 2002, there are 12 that have no registered entry in
involved. How many movies produced in 2011 have no registered entry in involved? */

-- VERIFY STATEMENT:
SELECT COUNT(*)
FROM movie
WHERE year = 2002 AND id NOT IN (SELECT movieId FROM involved)

-- SOLUTION FOR (5)
SELECT COUNT(*)
FROM movie
WHERE year = 2011 AND id NOT IN (SELECT movieId FROM involved)

-----------------------------------------------------------------------------------------
/* (6) In the database, the number of people who have acted in exactly one movie that they
have also self-directed is 603. What is the maximum number of times a single person
has both acted and directed in the same movie? */


-----------------------------------------------------------------------------------------
/* (7) Of all the movies produced in 2002, there are 282 that have entries registered in
involved for all roles defined in the roles relation. How many movies produced in
2011 have entries registered in involved for all roles defined in the roles relation?
Note: This is a relational division query which must work for any schema; you can not
use the fact that currently there are only 2 different roles to write a ‘magic number’. */


-----------------------------------------------------------------------------------------
/* (8) The number of people who have played a role in movies of all genres in the category
‘Newsworthy’ is 156. How many people have played a role in movies of all genres in
the category ‘Popular’ ? */