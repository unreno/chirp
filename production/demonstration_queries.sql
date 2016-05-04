
DELETE FROM private.identifiers
DELETE FROM dbo.observations
DELETE FROM fakedoc1.emrs
DELETE FROM vital.birth
DELETE FROM vital.birth2
DELETE FROM health_lab.newborn_screening




PRINT 'DECODER TEST BEGIN'
PRINT bin.decode('vital','birth','sex',1)
PRINT bin.decode('vital','birth','sex',2)
PRINT bin.decode('vital','birth','sex',9)
PRINT bin.decode('vital','birth','sex',10)
PRINT bin.decode('a','b','c',10)
PRINT 'DECODER TEST END'



EXEC dev.create_random_vital 1
SELECT * FROM vital.birth
SELECT * FROM vital.birth2
SELECT state_file_number, name_first, name_last, date_of_birth,
sex AS sex_code, bin.decode('vital','birth','sex',sex) AS sex,
infant_living AS infant_living_code, bin.decode('vital','birth','standard2_yesno',infant_living) AS infant_living,
birth_weight_lbs, birth_weight_oz,
apgar_1, apgar_5, apgar_10
FROM vital.birth b
LEFT JOIN vital.birth2 b2
ON b.birth2id = b2.birth2id

INSERT INTO private.identifiers
	( chirp_id, source_schema, source_table, source_column, source_id ) 
	SELECT private.create_unique_chirp_id(), 'vital', 'birth', 'state_file_number', 
	state_file_number FROM vital.birth b WHERE b.imported_to_dw = 'FALSE';
SELECT * FROM private.identifiers

EXEC dev.create_FAKE_newborn_screening_for_each_birth_record
SELECT * FROM health_lab.newborn_screening

EXEC dev.link_FAKE_newborn_screening_to_births
SELECT * FROM private.identifiers

EXEC dev.create_FAKE_fakedoc1_emrs
SELECT * FROM fakedoc1.emrs

EXEC dev.link_FAKE_fakedoc1_emrs_to_births
SELECT * FROM private.identifiers

EXEC bin.import_into_data_warehouse
SELECT * FROM dbo.observations
ORDER BY started_at




DELETE FROM private.identifiers
DELETE FROM dbo.observations
DELETE FROM fakedoc1.emrs
DELETE FROM vital.birth
DELETE FROM vital.birth2
DELETE FROM health_lab.newborn_screening

EXEC dev.create_random_vital 1000
INSERT INTO private.identifiers
	( chirp_id, source_schema, source_table, source_column, source_id ) 
	SELECT private.create_unique_chirp_id(), 'vital', 'birth', 'state_file_number', 
	state_file_number FROM vital.birth b WHERE b.imported_to_dw = 'FALSE';
EXEC dev.create_FAKE_newborn_screening_for_each_birth_record
EXEC dev.link_FAKE_newborn_screening_to_births
EXEC dev.create_FAKE_fakedoc1_emrs
EXEC dev.link_FAKE_fakedoc1_emrs_to_births
EXEC bin.import_into_data_warehouse
SELECT * FROM private.identifiers
SELECT * FROM dbo.observations





SELECT
	CASE WHEN (GROUPING(infant_living) = 1) THEN 'ALL'
		ELSE ISNULL(infant_living, 'Name If Null')
	END AS infant_living, COUNT(*) AS count
FROM vital.birth2
GROUP BY infant_living
WITH ROLLUP


SELECT
  CASE WHEN (GROUPING(infant_living) = 1) THEN 'ALL'
    ELSE ISNULL(infant_living, 'Name If Null')
  END AS infant_living, COUNT(*) AS count
	FROM private.identifiers i
	JOIN vital.birth b
		ON i.source_schema = 'vital'
		AND i.source_table = 'birth'
		AND i.source_column = 'state_file_number'
		AND i.source_id = b.state_file_number
	JOIN vital.birth2 b2
		ON b.birth2id = b2.birth2id
	GROUP BY infant_living
	WITH ROLLUP


SELECT 
  CASE WHEN (GROUPING(value) = 1) THEN 'ALL'
    ELSE value
  END AS infant_living , COUNT(*) AS count
FROM dbo.observations
WHERE concept = 'InfantLiving'
GROUP BY value
WITH ROLLUP





SELECT 
  CASE WHEN (GROUPING(value) = 1) THEN 'ALL'
    ELSE value
  END AS sex , COUNT(*) AS count
FROM dbo.observations
WHERE concept = 'DEM:Sex'
GROUP BY value
WITH ROLLUP



-- Ordered weights of each child.
SELECT chirp_id, value AS weight, started_at
FROM dbo.observations
WHERE concept = 'DEM:Weight'
ORDER BY chirp_id, started_at ASC


-- The most recent weight for each child (nested select) 
-- This can return multiples as the join is not explicitly unique
-- Created randome datetime so very unlikely to duplicate started_at now.
-- Would be nice if could o1.id = o2.id, but can't do that.
SELECT o1.* FROM (
	SELECT chirp_id, concept, MAX(started_at) AS max_at
		FROM dbo.observations
		WHERE concept = 'DEM:Weight'
		GROUP BY chirp_id, concept
) o2
JOIN dbo.observations o1 
	ON o2.chirp_id = o1.chirp_id
	AND o2.concept = o1.concept
	AND o2.max_at = o1.started_at












SELECT COUNT(*) FROM dbo.observations
WHERE concept = 'DEM:DOB'
AND CAST(value AS DATE) BETWEEN '2013-06-01' AND '2013-06-30';

SELECT chirp_id, CAST(value AS DATE) FROM dbo.observations
WHERE concept = 'DEM:DOB'
AND CAST(value AS DATE) BETWEEN '2013-06-01' AND '2013-06-30'
ORDER BY CAST(value AS DATE) DESC;







DECLARE @c INT;

SELECT TOP 1 @c = chirp_id FROM private.identifiers ORDER BY NEWID();

SELECT * FROM private.identifiers WHERE chirp_id = @c;

SELECT * FROM dbo.observations WHERE chirp_id = @c ORDER BY started_at;

SELECT h.chirp_id, h.value AS height, w.value AS weight ,
  ( w.value * 703. / SQUARE(h.value) ) AS bmi
FROM dbo.observations h
JOIN (
  SELECT * FROM dbo.observations
  WHERE concept = 'DEM:Weight'
) w ON h.chirp_id = w.chirp_id  AND h.started_at = w.started_at
WHERE h.concept = 'DEM:Height' AND h.chirp_id = @c;



SELECT h.chirp_id, h.value AS height, w.value AS weight ,
  ( w.value * 703. / SQUARE(h.value) ) AS bmi
FROM dbo.observations h
JOIN (
  SELECT * FROM dbo.observations
  WHERE concept = 'DEM:Weight'
) w ON h.chirp_id = w.chirp_id  AND h.started_at = w.started_at
WHERE h.concept = 'DEM:Height'
ORDER BY ( w.value * 703. / SQUARE(h.value) ) DESC;



SELECT YEAR(value) AS year, MONTH(value) AS month, COUNT(*) AS count
FROM observations
where concept = 'DEM:DOB'
GROUP BY YEAR(value), MONTH(value)
ORDER BY year, month



-- These BOTH need to be numbers. 2010/01 is not a number, so this doesn't work.
DECLARE @WKT AS VARCHAR(8000);
SET @WKT = STUFF(
	(SELECT ',' + mob + ' ' + CAST(count AS VARCHAR(5)) FROM (
		SELECT CAST(YEAR(value) AS VARCHAR(4)) + '/' + RIGHT('0' + CAST(MONTH(value) AS VARCHAR(2)),2) AS mob, COUNT(*) AS count
		FROM observations
		WHERE concept = 'DEM:DOB' 
		GROUP BY CAST(YEAR(value) AS VARCHAR(4)) + '/' + RIGHT('0' + CAST(MONTH(value) AS VARCHAR(2)),2)
	) neededname
	ORDER BY mob
	FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'LINESTRING(' + @WKT + ')', 0 );







SELECT YEAR(value) AS yob, COUNT(*) AS count
FROM observations
WHERE concept = 'DEM:DOB' 
GROUP BY YEAR(value) 

SELECT MONTH(value) AS mob, COUNT(*) AS count
FROM observations
WHERE concept = 'DEM:DOB' 
GROUP BY MONTH(value) 


DECLARE @WKT AS VARCHAR(8000);
SET @WKT = STUFF(
	(SELECT ',' + CAST(mob AS VARCHAR(2)) + ' ' + CAST(count AS VARCHAR(5)) FROM (
		SELECT MONTH(value) AS mob, COUNT(*) AS count
		FROM observations
		WHERE concept = 'DEM:DOB' 
		GROUP BY MONTH(value)
	) neededname
	ORDER BY mob
	FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'LINESTRING(' + @WKT + ')', 0 );



DECLARE @WKT AS VARCHAR(8000);
SET @WKT = STUFF(
	(SELECT ',' + CAST(yob AS VARCHAR(4)) + ' ' + CAST(count AS VARCHAR(5)) FROM (
		SELECT YEAR(value) AS yob, COUNT(*) AS count
		FROM observations
		WHERE concept = 'DEM:DOB' 
		GROUP BY YEAR(value)
	) neededname
	ORDER BY yob
	FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'LINESTRING(' + @WKT + ')', 0 );

-- This is the meat X Y,X Y,X Y,X Y, ....
--SELECT geometry::STGeomFromText( 'LINESTRING( 2001 0.9,2002 2.1,2003 2.7,2004 3.1,2005 2.8,2006 3.4,2007 3.5,2008 2.5,2009 2.6 )', 0 );
-- This is still pretty weak. No real control over scaling or labeling.









DECLARE @WKT AS VARCHAR(8000);
SET @WKT =
  STUFF(
    (SELECT ',((' +
      CAST( FY - 0.3 AS VARCHAR(30) ) + ' 0,' +
      CAST( FY - 0.3 AS VARCHAR(30) ) + ' ' +
      CAST( Sales AS VARCHAR(30) ) + ',' +
      CAST( FY + 0.3 AS VARCHAR(30) ) + ' ' +
      CAST( Sales AS VARCHAR(30) ) + ',' +
      CAST( FY + 0.3 AS VARCHAR(30) ) + ' 0,' +
      CAST( FY - 0.3 AS VARCHAR(30) ) + ' 0))'
    FROM #Sales
    ORDER BY FY
    FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'MULTIPOLYGON(' + @WKT + ')', 0 );

-- Bar Graph ish (basically draw little boxes)
-- SELECT geometry::STGeomFromText( 'MULTIPOLYGON(  ((2000.7 0,2000.7 0.9,2001.3 0.9,2001.3 0,2000.7 0)),((2001.7 0,2001.7 2.1,2002.3 2.1,2002.3 0,2001.7 0)),((2002.7 0,2002.7 2.7,2003.3 2.7,2003.3 0,2002.7 0)),((2003.7 0,2003.7 3.1,2004.3 3.1,2004.3 0,2003.7 0)),((2004.7 0,2004.7 2.8,2005.3 2.8,2005.3 0,2004.7 0)),((2005.7 0,2005.7 3.4,2006.3 3.4,2006.3 0,2005.7 0)),((2006.7 0,2006.7 3.5,2007.3 3.5,2007.3 0,2006.7 0)),((2007.7 0,2007.7 2.5,2008.3 2.5,2008.3 0,2007.7 0)),((2008.7 0,2008.7 2.6,2009.3 2.6,2009.3 0,2008.7 0))  )' );

DECLARE @WKT AS VARCHAR(8000);
SET @WKT = STUFF(
	(SELECT ',((' + 
		-- 5 points to draw a bar border (first and last are the same)
		CAST(mob AS VARCHAR(10)) + ' ' + 
		CAST(count AS VARCHAR(10)) + 
		'))'
		FROM (
		SELECT MONTH(value) AS mob, COUNT(*) AS count
		FROM observations
		WHERE concept = 'DEM:DOB' 
		GROUP BY MONTH(value)
	) neededname
	ORDER BY mob
	FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'MULTIPOLYGON(' + @WKT + ')', 0 );









