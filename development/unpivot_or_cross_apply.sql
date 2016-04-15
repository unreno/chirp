
-- I seem to have lost my notes on why I chose what I chose
-- regarding UNPIVOT and CROSS APPLY.
-- I think that CROSS APPLY would return NULL for missing
-- values which UNPIVOT would ignore them completely.
-- I need to create a little demo to confirm.


DECLARE @t TABLE( id INT, a VARCHAR(255), b VARCHAR(255) )
INSERT INTO @t VALUES (1,'apple','banana'), (2,'orange',NULL)
SELECT * FROM @t

--CROSS APPLY will includes NULL values
SELECT id, fruit FROM @t
CROSS APPLY ( VALUES
	( a ), ( b ) ) v (fruit)

--While UNPIVOT will ignore
SELECT id, fruit FROM @t
UNPIVOT (
	fruit FOR ignore IN ( a, b )
) v

--Of course, if this is being wrapped in another SELECT or INSERT
--can simply add a WHERE to check that the results aren't NULL
SELECT id, fruit FROM @t
CROSS APPLY ( VALUES
	( a ), ( b ) ) v (fruit)
WHERE fruit IS NOT NULL

