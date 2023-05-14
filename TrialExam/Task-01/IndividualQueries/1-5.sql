SELECT MAX(subquery.group_count) AS min_group_count
FROM (
  SELECT COUNT(*) AS group_count
  FROM ACGROUP
  INNER JOIN AIRCRAFT ON ACGROUP.AG = AIRCRAFT.AG
  GROUP BY ACGROUP.AG
) AS subquery; 