
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


--infant_living is going to be inf_liv in real data.

EXEC dev.create_random_vital 1
SELECT * FROM vital.birth
SELECT * FROM vital.birth2
SELECT state_file_number, name_first, name_last, date_of_birth,
sex AS sex_code, bin.decode('vital','birth','sex',sex) AS sex,
infant_living AS infant_living_code, bin.decode('vital','birth','inf_liv',infant_living) AS infant_living,
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





SELECT COUNT(DISTINCT chirp_id) FROM dbo.observations


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
    ELSE ISNULL(value, 'Name If Null')
  END AS infant_living , COUNT(*) AS count
FROM dbo.observations
WHERE concept = 'infant_living'
GROUP BY value
WITH ROLLUP

SELECT value, COUNT(*) AS count, ( COUNT(*) * 100. / SUM(COUNT(*)) OVER()) AS [percent]
FROM dbo.observations
WHERE concept = 'infant_living'
GROUP BY value





SELECT 
  CASE WHEN (GROUPING(value) = 1) THEN 'ALL'
    ELSE ISNULL(value, 'Name If Null')
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




SELECT YEAR(value) AS yob, COUNT(*) AS count
FROM observations
WHERE concept = 'DEM:DOB' 
GROUP BY YEAR(value) 

SELECT MONTH(value) AS mob, COUNT(*) AS count
FROM observations
WHERE concept = 'DEM:DOB' 
GROUP BY MONTH(value) 

SELECT YEAR(value) AS year, MONTH(value) AS month, COUNT(*) AS count
FROM observations
where concept = 'DEM:DOB'
GROUP BY YEAR(value), MONTH(value)
ORDER BY year, month




-- GRAPHING
-- These BOTH need to be numbers. 2010/01 is not a number, so this doesn't work.
DECLARE @WKT AS VARCHAR(8000);
SET @WKT = STUFF(
	(SELECT ',' + mob + ' ' + CAST(count AS VARCHAR(5)) FROM (
		SELECT CAST(YEAR(value) AS VARCHAR(4)) + '/' + RIGHT('0' + CAST(MONTH(value) AS VARCHAR(2)),2) AS mob, COUNT(*) AS count
		FROM observations
		WHERE concept = 'DEM:DOB' 
		GROUP BY CAST(YEAR(value) AS VARCHAR(4)) + '/' + RIGHT('0' + CAST(MONTH(value) AS VARCHAR(2)),2)
	) subselect
	ORDER BY mob
	FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'LINESTRING(' + @WKT + ')', 0 );


-- This works, but leaves much to be desired.
DECLARE @WKT AS VARCHAR(8000);
SET @WKT = STUFF(
	(SELECT ',' + CAST(mob AS VARCHAR(2)) + ' ' + CAST(count AS VARCHAR(5)) FROM (
		SELECT MONTH(value) AS mob, COUNT(*) AS count
		FROM observations
		WHERE concept = 'DEM:DOB' 
		GROUP BY MONTH(value)
	) subselect
	ORDER BY mob
	FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'LINESTRING(' + @WKT + ')', 0 );

-- This works too, but leaves much to be desired.
DECLARE @WKT AS VARCHAR(8000);
SET @WKT = STUFF(
	(SELECT ',' + CAST(yob AS VARCHAR(4)) + ' ' + CAST(count AS VARCHAR(5)) FROM (
		SELECT YEAR(value) AS yob, COUNT(*) AS count
		FROM observations
		WHERE concept = 'DEM:DOB' 
		GROUP BY YEAR(value)
	) subselect
	ORDER BY yob
	FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'LINESTRING(' + @WKT + ')', 0 );

-- This is the meat X Y,X Y,X Y,X Y, ....
--SELECT geometry::STGeomFromText( 'LINESTRING( 2001 0.9,2002 2.1,2003 2.7,2004 3.1,2005 2.8,2006 3.4,2007 3.5,2008 2.5,2009 2.6 )', 0 );
-- This is still pretty weak. No real control over scaling or labeling.
-- The 1:1 ratio of the graph really makes this awful.

-- This bar graph also works, but still kinda sucks.
DECLARE @WKT AS VARCHAR(8000);
SET @WKT = STUFF(
	(SELECT ',((' + 
		-- 5 points to draw a bar border (first and last are the same)
		CAST(mob - 0.3 AS VARCHAR(10)) + ' 0,' +
		CAST(mob - 0.3 AS VARCHAR(10)) + ' ' + CAST(count AS VARCHAR(10)) + ',' +
		CAST(mob + 0.3 AS VARCHAR(10)) + ' ' + CAST(count AS VARCHAR(10)) + ',' +
		CAST(mob + 0.3 AS VARCHAR(10)) + ' 0,' +
		CAST(mob - 0.3 AS VARCHAR(10)) + ' 0))'
	FROM (
		SELECT MONTH(value) AS mob, COUNT(*) AS count
		FROM observations
		WHERE concept = 'DEM:DOB' 
		GROUP BY MONTH(value)
	) subselect
	ORDER BY mob
	FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'MULTIPOLYGON(' + @WKT + ')', 0 );

-- Bar Graph ish (basically draw little boxes)
-- SELECT geometry::STGeomFromText( 'MULTIPOLYGON(  ((9.7 0,9.7 82,10.3 82,10.3 0,9.7 0)),((19.7 0,19.7 61,20.3 61,20.3 0,19.7 0)),((29.7 0,29.7 71,30.3 71,30.3 0,29.7 0)),((39.7 0,39.7 75,40.3 75,40.3 0,39.7 0)),((49.7 0,49.7 76,50.3 76,50.3 0,49.7 0)),((59.7 0,59.7 86,60.3 86,60.3 0,59.7 0)),((69.7 0,69.7 109,70.3 109,70.3 0,69.7 0)),((79.7 0,79.7 98,80.3 98,80.3 0,79.7 0)),((89.7 0,89.7 87,90.3 87,90.3 0,89.7 0)),((99.7 0,99.7 82,100.3 82,100.3 0,99.7 0)),((109.7 0,109.7 81,110.3 81,110.3 0,109.7 0)),((119.7 0,119.7 92,120.3 92,120.3 0,119.7 0)) )' );





-- gestation_weeks metric

SELECT 
  CASE WHEN (GROUPING(value) = 1) THEN 'ALL'
    ELSE ISNULL(value, 'Name If Null')
  END AS weeks, COUNT(*) AS count
FROM dbo.observations
WHERE concept = 'gestation_weeks'
GROUP BY value
WITH ROLLUP
ORDER BY CAST(value AS INT)


-- APGAR 1 minute metric

SELECT 
  CASE WHEN (GROUPING(value) = 1) THEN 'ALL'
    ELSE ISNULL(value, 'Name If Null')
  END AS apgar1, COUNT(*) AS count
FROM dbo.observations
WHERE concept = 'APGAR1'
GROUP BY value
WITH ROLLUP
ORDER BY CAST(value AS INT)


-- APGAR 5 minute metric

SELECT 
  CASE WHEN (GROUPING(value) = 1) THEN 'ALL'
    ELSE ISNULL(value, 'Name If Null')
  END AS apgar5, COUNT(*) AS count
FROM dbo.observations
WHERE concept = 'APGAR5'
GROUP BY value
WITH ROLLUP
ORDER BY CAST(value AS INT)


-- APGAR 10 minute metric

SELECT 
  CASE WHEN (GROUPING(value) = 1) THEN 'ALL'
    ELSE ISNULL(value, 'Name If Null')
  END AS apgar10, COUNT(*) AS count
FROM dbo.observations
WHERE concept = 'APGAR10'
GROUP BY value
WITH ROLLUP
ORDER BY CAST(value AS INT)





-- Wait! If this is already calculated, why am I?
--
--   value bwt_grp
--     1 = 'Normal Birth Weight (>=2,500g, <=8,000g)'
--     2 = 'Low Birth Weight (>=1,500g, <2,500g)'
--     3 = 'Very Low Birth Weight (<1.500g)'
--     9 = 'Unknown'
--
-- 1500 = 3 5/16
-- 2500 = 5.5


--	Weight Group Metric

SELECT 
	CASE WHEN (GROUPING(WeightGroup) = 1) THEN 'ALL'
		ELSE ISNULL(WeightGroup, 'Name If Null')
	END AS WeightGroup, COUNT(*) AS count
FROM (
	SELECT CASE
		WHEN CAST(value AS FLOAT) > 5.5 THEN 'Normal'
		WHEN CAST(value AS FLOAT) < (3 + 5./16) THEN 'Very Low'	-- NEED that decimal point.
		ELSE 'Low'
	END AS WeightGroup
	FROM dbo.observations
	WHERE concept = 'DEM:Weight'
		AND source_schema = 'vital'
		AND source_table = 'birth'
) temp
GROUP BY WeightGroup
WITH ROLLUP


SELECT 
	WeightGroup, COUNT(*) AS count, ( COUNT(*) * 100. / SUM(COUNT(*)) OVER()) AS [percent]
FROM (
	SELECT CASE
		WHEN CAST(value AS FLOAT) > 5.5 THEN 'Normal'
		WHEN CAST(value AS FLOAT) < (3 + 5./16) THEN 'Very Low'	-- NEED that decimal point.
		ELSE 'Low'
	END AS WeightGroup
	FROM dbo.observations
	WHERE concept = 'DEM:Weight'
		AND source_schema = 'vital'
		AND source_table = 'birth'
) temp
GROUP BY WeightGroup







-- Birth Weight Distribution Numbers

SELECT 
	CASE WHEN (GROUPING(ounces) = 1) THEN 'ALL'
		ELSE ISNULL(ounces, 0)
	END AS ounces, COUNT(*) AS count
FROM (
	SELECT CAST(CAST(value AS FLOAT) * 16 AS INTEGER) AS ounces
	FROM dbo.observations
	WHERE concept = 'DEM:Weight'
		AND source_schema = 'vital'
		AND source_table = 'birth'
) temp
GROUP BY ounces


-- Birth Weight Distribution Graph

DECLARE @WKT AS VARCHAR(8000);
SET @WKT = STUFF(
	(SELECT ',((' + 
		-- 5 points to draw a bar border (first and last are the same)
		CAST(ounces - 0.3 AS VARCHAR(10)) + ' 0,' +
		CAST(ounces - 0.3 AS VARCHAR(10)) + ' ' + CAST(count AS VARCHAR(10)) + ',' +
		CAST(ounces + 0.3 AS VARCHAR(10)) + ' ' + CAST(count AS VARCHAR(10)) + ',' +
		CAST(ounces + 0.3 AS VARCHAR(10)) + ' 0,' +
		CAST(ounces - 0.3 AS VARCHAR(10)) + ' 0))'
	FROM (
		SELECT CAST(CAST(value AS FLOAT) * 16 AS INTEGER) AS ounces, COUNT(*) AS count
		FROM dbo.observations
		WHERE concept = 'DEM:Weight'
			AND source_schema = 'vital'
			AND source_table = 'birth'
		GROUP BY CAST(CAST(value AS FLOAT) * 16 AS INTEGER)
	) subselect
	ORDER BY ounces
	FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'MULTIPOLYGON(' + @WKT + ')', 0 );









-- BAD APGAR 10 Distribution Graph

DECLARE @WKT AS VARCHAR(8000);
SET @WKT = STUFF(
	(SELECT ',((' + 
		-- 5 points to draw a bar border (first and last are the same)
		CAST(apgar - 0.3 AS VARCHAR(10)) + ' 0,' +
		CAST(apgar - 0.3 AS VARCHAR(10)) + ' ' + CAST(count AS VARCHAR(10)) + ',' +
		CAST(apgar + 0.3 AS VARCHAR(10)) + ' ' + CAST(count AS VARCHAR(10)) + ',' +
		CAST(apgar + 0.3 AS VARCHAR(10)) + ' 0,' +
		CAST(apgar - 0.3 AS VARCHAR(10)) + ' 0))'
	FROM (
		SELECT CAST(value AS INTEGER) AS apgar, COUNT(*) AS count
		FROM dbo.observations
		WHERE concept = 'APGAR10'
		GROUP BY value
	) subselect
	ORDER BY apgar
	FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'MULTIPOLYGON(' + @WKT + ')', 0 );



-- BAD Gestation Graph

DECLARE @WKT AS VARCHAR(8000);
SET @WKT = STUFF(
	(SELECT ',((' + 
		-- 5 points to draw a bar border (first and last are the same)
		CAST(gest - 0.3 AS VARCHAR(10)) + ' 0,' +
		CAST(gest - 0.3 AS VARCHAR(10)) + ' ' + CAST(count AS VARCHAR(10)) + ',' +
		CAST(gest + 0.3 AS VARCHAR(10)) + ' ' + CAST(count AS VARCHAR(10)) + ',' +
		CAST(gest + 0.3 AS VARCHAR(10)) + ' 0,' +
		CAST(gest - 0.3 AS VARCHAR(10)) + ' 0))'
	FROM (
		SELECT CAST(value AS INTEGER) as gest, COUNT(*) AS count
		FROM dbo.observations
		WHERE concept = 'gestation_weeks'
		GROUP BY value
	) subselect
	ORDER BY gest
	FOR XML PATH('')), 1, 1, '');
PRINT @WKT
SELECT geometry::STGeomFromText( 'MULTIPOLYGON(' + @WKT + ')', 0 );





-- I am expecting that the data will be coming in a format very different than
-- previously expected. Many of these fields aren't in the PDF sent earlier.

--/*Used for the following variables: acn1 acn2 acn3 acn4 acn5 acn1_mf acn2_mf acn3_mf acn4_mf acn5_mf*/
--  value abnormal
--    0 = 'None'
--    1 = 'Anemia (<39/Hgb <13)'
--    2 = 'Birth Injury'
--    3 = 'Fetal Alcohol Syndrome'
--    4 = 'Hyaline Membrane Disease/Rds'
--    5 = 'Meconium Aspiration Syndrome'
--    6 = 'Assisted Ventilation < 30 Min'
--    7 = 'Assisted Ventilaion >= 30 Min'
--    8 = 'Seizures'
--    9 = 'Other'
--    99 = 'Unknown'

