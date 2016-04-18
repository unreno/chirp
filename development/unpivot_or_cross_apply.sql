
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



DECLARE @t TABLE( id INT, a VARCHAR(255), b VARCHAR(255) )
INSERT INTO @t VALUES (1,'apple','banana'), (2,'orange',NULL)
SELECT * FROM @t
SELECT id, fruit FROM ( SELECT id FROM @t )
CROSS APPLY ( VALUES
	( a ), ( b ) ) v (fruit)

--SELECT id, fruit, RAND() AS random FROM @t
--CROSS APPLY ( VALUES
--	( a ), ( b ) ) v (fruit)
--
--SELECT id, fruit, RAND() AS random FROM @t
--UNPIVOT (
--	fruit FOR ignore IN ( a, b )
--) v

--RAND() is odd.  NEWID() is different.
--(SELECT RAND()) is same for all rows.
--(SELECT NEWID()) is same for each initial row.
--(SELECT ABS(CHECKSUM(NEWID()))) produces an integer. Not sure of range.
SELECT id, fruit, r2, r4
FROM ( 
	SELECT id, a, b, (SELECT RAND()) AS r2, (SELECT ABS(CHECKSUM(NEWID()))) AS r4 FROM @t 
) x
CROSS APPLY ( VALUES
  ( a ), ( b ) ) v (fruit)

--(SELECT RAND()) is same for all rows.
--(SELECT NEWID()) is same for each initial row.
SELECT id, fruit, r2, r4
FROM ( 
	SELECT id, a, b, (SELECT RAND()) AS r2, (SELECT ABS(CHECKSUM(NEWID()))) AS r4 FROM @t 
) x
UNPIVOT(
  fruit for ignore in ( a, b )
) v

--When used like this, however, r4 is different for all 4 rows?
SELECT id, a, b, (SELECT RAND()) AS r2, (SELECT ABS(CHECKSUM(NEWID()))) AS r4 FROM @t 
CROSS APPLY ( VALUES
  ( a ), ( b ) ) v (fruit)


--Adding DISTINCT to the internal SELECT and keeping the CROSS APPLY out does what I was looking for.




--Yes, double unpivots can be done.
--You'll need to be sneaky about 'column' names so can use a WHERE 
--clause to choose otherwise, the UNPIVOT is for all of them.
DECLARE @t TABLE( id INT, a VARCHAR(255), b VARCHAR(255), ax VARCHAR(255), bz VARCHAR(255) )
INSERT INTO @t VALUES (1,'apple','banana', 'red','yellow'), (2,'orange',NULL,'orange','black')

SELECT id, fruit, color FROM @t
UNPIVOT (
	fruit FOR ignore1 IN ( a, b )
) f
UNPIVOT (
	color FOR ignore2 IN ( ax, bz )
) c
WHERE LEFT(ignore1,1) = LEFT(ignore2,1)



--		SELECT
--			record_number, name_first, name_last, date_of_birth, sex, code, value, units, service_at
--		FROM (
--			SELECT 
--				dev.unique_fakedoc1_record_number() AS record_number,
--				name_first, name_last, date_of_birth, sex,
--				CAST(dev.random_weight() AS VARCHAR(255)) AS [DEM:Weight],
--				CAST(dev.random_height() AS VARCHAR(255)) AS [DEM:Height],
--				CAST('lbs' AS VARCHAR(255)) AS [DEM:WeightUNITS],
--				CAST('inches' AS VARCHAR(255)) AS [DEM:HeightUNITS],
--        dev.random_date() AS service_at
--      FROM vital_records.birth
--    ) ignored1
--    UNPIVOT (
--      value FOR code IN ( [DEM:Height], [DEM:Weight] )
--    ) AS ignored2
--    UNPIVOT (
--      units FOR codeunit IN ( [DEM:HeightUNITS], [DEM:WeightUNITS] )
--    ) AS ignored3
--    WHERE LEFT(code,5) = LEFT(codeunit,5) -- match DEM:H to DEM:H and DEM:W to DEM:W

