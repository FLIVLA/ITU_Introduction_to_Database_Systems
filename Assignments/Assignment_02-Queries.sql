--(3)

/* (a) The empire ‘Danish Empire’ consists of 3 countries. How many countries does the
empire ‘Iberian’ consist of? */

SELECT COUNT(*) FROM empires 
INNER JOIN countries ON empires.CountryCode = countries.Code 
WHERE empires.Empire = 'Iberian';


/* (b) There are 4 countries that are present on more than one continent. How many of
these countries are partially in Europe? */

-- GETS THE COUNTRIES THAT ARE ON MORE THAN ONE CONTINENT
SELECT countries.code, 
countries.name, 
countries_continents.countrycode,
countries_continents.continent,
countries_continents.percentage
FROM countries_continents
INNER JOIN countries  
ON countries_continents.countrycode = countries.code
WHERE countries_continents.percentage < 100

-- GETS DISTINCT COUNTRY CODES OF COUNTRIES ON MORE THAN ONE CONTINENT
SELECT countries.code
FROM countries_continents
INNER JOIN countries  
ON countries_continents.countrycode = countries.code
GROUP BY countries.code
HAVING COUNT(DISTINCT countries_continents.continent) > 1;

-- 
SELECT COUNT(*) FROM (
  SELECT countries.code
  FROM countries_continents
  INNER JOIN countries  
  ON countries_continents.countrycode = countries.code
  GROUP BY countries.code
  HAVING COUNT(DISTINCT countries_continents.continent) > 1
) AS multi_continent_countries
INNER JOIN countries_continents
ON multi_continent_countries.code = countries_continents.countrycode
WHERE countries_continents.continent = 'Europe';


/* (c) In the countries of North America that have more than 1 million inhabitants, there
are a total of 164,688,674 people that speak Spanish, according to the statistics in
the database. What is the corresponding number for Europe? */

SELECT SUM(countries.population * countries_languages.percentage * 0.01)
FROM countries
INNER JOIN countries_languages
ON countries.code = countries_languages.countrycode
INNER JOIN countries_continents
ON countries.code = countries_continents.countrycode
WHERE countries.population > 1000000
AND countries_languages.language = 'Spanish'
AND countries_continents.continent = 'Europe';


/* (d) According to the database, one language is spoken in all countries of the ‘Danish
Empire’. How many languages are spoken in all countries of ‘Benelux’?
Note: This is a division query; points will only be awarded if division is attempted. */