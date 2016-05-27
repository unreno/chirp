


-- A Common Table Expression or CTE is kinda like a temp table or view
-- created from a query that you can reference once and then it is gone.
-- You could SELECT INTO a temp table or perhaps variable
-- but that copies the results. A CTE is more like a view.

WITH cte AS (
	SELECT * FROM private.identifiers
)
SELECT * FROM cte WHERE chirp_id = 1125770123
UNION
SELECT * FROM cte WHERE chirp_id = 1797035090



-- Seems like this could be useful when need to select from a selection without doing it twice.


WITH cte AS (
	SELECT * FROM private.identifiers
)
SELECT * FROM cte WHERE chirp_id IN (
	SELECT chirp_id FROM ( SELECT * from cte ) xyz
	GROUP BY chirp_id
	HAVING COUNT(1) = 1
) 




