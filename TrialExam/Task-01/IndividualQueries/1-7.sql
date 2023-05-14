SELECT COUNT(*) AS CNT_airlines
FROM (
  SELECT AL AS airline, COUNT(DISTINCT DEP) AS CNT_departing_airports
  FROM flights
  WHERE DEP IN (SELECT airport FROM airport WHERE country = 'NL')
  GROUP BY AL
) AS SQ
WHERE CNT_departing_airports = (SELECT COUNT(*) FROM airport WHERE country = 'NL');