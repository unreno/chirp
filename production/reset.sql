


TRUNCATE TABLE private.identifiers;
TRUNCATE TABLE dbo.observations;

UPDATE x WITH (TABLOCK)
	SET imported_to_observations = 'FALSE'
	FROM vital.births x;

UPDATE x WITH (TABLOCK)
	SET imported_to_observations = 'FALSE'
	FROM webiz.immunizations x;






SELECT COUNT(1) AS identifiers_pre_count FROM private.identifiers
--  0

--  Create an identifier for each birth record (from zip codes in Washoe County)
INSERT INTO private.identifiers WITH (TABLOCK) 
	( chirp_id, source_schema, source_table, source_column, source_id, match_method )
  SELECT private.create_unique_chirp_id(), 'vital', 'births',
    'state_file_number', state_file_number, 'Initial assignment'
  FROM vital.births b WHERE b.imported_to_observations = 'FALSE'
    AND b.mother_res_zip IN ( '89402', '89405', '89412', '89424', '89431', '89432', '89433', '89434', '89435', '89436', '89439', '89441', '89442', '89450', '89451', '89452', '89501', '89502', '89503', '89504', '89505', '89506', '89507', '89509', '89510', '89511', '89512', '89513', '89515', '89519', '89520', '89521', '89523', '89533', '89555', '89557', '89570', '89595', '89599', '89704');

SELECT COUNT(1) AS identifiers_post_count FROM private.identifiers
--  38025
SELECT COUNT(1) AS observations_pre_count FROM dbo.observations
--  0








--  Import all data into observations table (takes about 40 seconds)
EXEC bin.import_into_data_warehouse
SELECT COUNT(1) AS observations_post_count FROM dbo.observations
--	10439060
--	10485466


INSERT INTO dev.counts WITH (TABLOCK) (name,count) SELECT 'obs_count', COUNT(1) FROM dbo.observations;





DECLARE @y INT = 2010;
DECLARE @m INT = 1;

WHILE @y < 2018
BEGIN
	SET @m = 1;
	WHILE @m < 13
	BEGIN

		EXEC bin.link_immunization_records_to_birth_records @y, @m;
		INSERT INTO dev.counts WITH (TABLOCK) (name,count)
			SELECT 'identifiers_count ' + CAST(@y AS VARCHAR(4)) + ' ' + CAST(@m AS VARCHAR(2)), COUNT(1)
			FROM private.identifiers;
		SELECT 'identifiers_count ' + CAST(@y AS VARCHAR) + ' ' + CAST(@m AS VARCHAR);

		SET @m = @m + 1;
	END
	SET @y = @y + 1;
END;


--	That will take quite a while.


EXEC bin.import_into_data_warehouse
INSERT INTO dev.counts WITH (TABLOCK) (name,count) SELECT 'obs_count', COUNT(1) FROM dbo.observations;


SELECT * FROM dev.counts



SELECT count, 100.0*sum/total AS percentage
FROM (
  SELECT count, COUNT(1) AS sum,
    (SELECT COUNT(1) FROM private.identifiers WHERE source_schema = 'vital') AS total
  FROM (
    SELECT chirp_id, COUNT(1) AS count
    FROM private.identifiers
    GROUP BY chirp_id
  ) x
  GROUP BY count
) y
ORDER BY count


--	count percentage
--	1 16.094674556213
--	2 74.774490466798
--	3 8.794214332675
--	4 0.336620644312


SELECT this.name, this.count, (this.count - prev.count) AS num,
  DATEDIFF(minute, prev.created_at, this.created_at) AS minutes
FROM dev.counts this
JOIN dev.counts prev ON this.id = prev.id + 1



SELECT COUNT(DISTINCT chirp_id) FROM private.identifiers i
WHERE i.source_schema = 'webiz'

SELECT COUNT(DISTINCT chirp_id) FROM private.identifiers i


