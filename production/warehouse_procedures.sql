

IF OBJECT_ID ( 'dbo.import_into_data_warehouse_by_table_fakedoc1_emrs', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.import_into_data_warehouse_by_table_fakedoc1_emrs;
GO
CREATE PROCEDURE dbo.import_into_data_warehouse_by_table_fakedoc1_emrs
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.observations
		(chirp_id, provider_id, started_at,
			concept, value, units, downloaded_from, downloaded_at)
		SELECT i.chirp_id, 
			8675309 AS provider_id,
			n.service_at AS started_at,
			code AS concept,
			value AS value,
			units AS units,
			'Fake Doctor 1' AS downloaded_from,
			n.imported_at AS downloaded_at
		FROM fakedoc1.emrs n
		JOIN private.identifiers i
			ON    i.source_id     = n.record_number
				AND i.source_column = 'record_number'
				AND i.source_table  = 'emrs'
				AND i.source_schema = 'fakedoc1'
		WHERE n.imported_to_dw = 'FALSE'

	UPDATE n
		SET imported_to_dw = 'TRUE'
		FROM fakedoc1.emrs n
		JOIN private.identifiers i
			ON  i.source_id     = n.record_number
			AND i.source_column = 'record_number'
			AND i.source_table  = 'emrs'
			AND i.source_schema = 'fakedoc1'
		WHERE imported_to_dw = 'FALSE'
			AND i.id IS NOT NULL

END	--	CREATE PROCEDURE dbo.import_into_data_warehouse_by_table_fakedoc1_emrs
GO


IF OBJECT_ID ( 'dbo.import_into_data_warehouse_by_table_health_lab_newborn_screening', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.import_into_data_warehouse_by_table_health_lab_newborn_screening;
GO
CREATE PROCEDURE dbo.import_into_data_warehouse_by_table_health_lab_newborn_screening
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.observations
		(chirp_id, provider_id, started_at,
			concept, value, units, downloaded_from, downloaded_at)
		SELECT chirp_id, provider_id, started_at,
			cav.concept, cav.value, cav.units, downloaded_from, downloaded_at
		FROM (
			SELECT i.chirp_id, n.date_of_birth AS started_at,
				'789' AS provider_id,
				testresults1, testresults2, testresults3, testresults4, testresults5,
				'Health Lab' AS downloaded_from,
				n.imported_at AS downloaded_at
			FROM health_lab.newborn_screening n
			JOIN private.identifiers i
				ON    i.source_id     = n.id
					AND i.source_column = 'id'
					AND i.source_table  = 'newborn_screening'
					AND i.source_schema = 'health_lab'
			WHERE n.imported_to_dw = 'FALSE'
		) unimported_newborn_screening_data
		CROSS APPLY ( VALUES
			( 'TR1', testresults1, 'cm' ),
			( 'TR2', testresults2, 'in' ),
			( 'TR3', testresults3, 'Degrees' ),
			( 'TR4', testresults4, 'mm Hg' ),
			( 'TR5', testresults5, '%' )
		) cav ( concept, value, units )
		WHERE cav.value IS NOT NULL

	UPDATE n
		SET imported_to_dw = 'TRUE'
		FROM health_lab.newborn_screening n
		JOIN private.identifiers i
			ON  i.source_id     = n.id
			AND i.source_column = 'id'
			AND i.source_table  = 'newborn_screening'
			AND i.source_schema = 'health_lab'
		WHERE imported_to_dw = 'FALSE'
			AND i.id IS NOT NULL

END	--	CREATE PROCEDURE dbo.import_into_data_warehouse_by_table_health_lab_newborn_screening
GO



IF OBJECT_ID ( 'dbo.weight_from_lbs_and_oz', 'FN' ) IS NOT NULL
	DROP FUNCTION dbo.weight_from_lbs_and_oz;
GO
CREATE FUNCTION dbo.weight_from_lbs_and_oz( @lbs INT, @oz INT )
	RETURNS FLOAT
BEGIN
	DECLARE @w FLOAT;
	IF @lbs IS NOT NULL AND @oz IS NOT NULL
		SET @w = CAST(@lbs AS FLOAT) + CAST(@oz AS FLOAT)/16
	RETURN @w
END
GO



IF OBJECT_ID ( 'dbo.import_into_data_warehouse_by_table_vital_records_birth', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.import_into_data_warehouse_by_table_vital_records_birth;
GO
CREATE PROCEDURE dbo.import_into_data_warehouse_by_table_vital_records_birth
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.observations
		(chirp_id, provider_id, started_at,
			concept, value, units, downloaded_from, downloaded_at)
		SELECT chirp_id, provider_id, started_at,
			cav.concept, cav.value, cav.units, downloaded_from, downloaded_at
		FROM (
			SELECT i.chirp_id, date_of_birth AS started_at,
				'123' AS provider_id,
				'The State' AS downloaded_from,
				date_of_birth, birth_weight_lbs, birth_weight_oz,
				sex, apgar_1, apgar_5, apgar_10,
				imported_at AS downloaded_at
			FROM vital_records.birth b
			JOIN private.identifiers i
				ON i.source_id = b.state_file_number
				AND i.source_column = 'state_file_number'
				AND i.source_table = 'birth'
				AND i.source_schema = 'vital_records'
			WHERE imported_to_dw = 'FALSE'
		) unimported_birth_record_data
		CROSS APPLY ( VALUES
			( 'DEM:DOB', CAST(CAST(date_of_birth AS DATE) AS VARCHAR(255)), NULL ),
			( 'DEM:Weight', CAST(
				dbo.weight_from_lbs_and_oz( birth_weight_lbs, birth_weight_oz ) AS VARCHAR(255)), 'lbs'),
			( 'DEM:Sex', sex, NULL ),
			(  'APGAR1', apgar_1, NULL ),
			(  'APGAR5', apgar_5, NULL ),
			( 'APGAR10', apgar_10, NULL )
		) cav ( concept, value, units )
		WHERE cav.value IS NOT NULL

-- Now that I have a better understanding of CAV, merged all below.

--				CAST(b.date_of_birth AS VARCHAR(255)) AS [DEM:DOB],
--				CAST(b.sex AS VARCHAR(255)) AS [DEM:Sex],
--				CAST(b.apgar_1 AS VARCHAR(255)) AS [APGAR1],
--				CAST(b.apgar_5 AS VARCHAR(255)) AS [APGAR5],
--				CAST(b.apgar_10 AS VARCHAR(255)) AS [APGAR10],
--		UNPIVOT (
--			value FOR concept IN ( [DEM:DOB], [DEM:Sex], [APGAR1], [APGAR5], [APGAR10] )
--		) AS anotherarbitraryrequiredname

--	INSERT INTO dbo.observations
--		(chirp_id, provider_id, started_at,
--			concept, value, downloaded_from, downloaded_at)
--		SELECT chirp_id, provider_id, started_at,
--			concept, value, downloaded_from, downloaded_at
--		FROM (
--			SELECT i.chirp_id, b.date_of_birth AS started_at,
--				'123' AS provider_id,
--				CAST(b.sex AS VARCHAR(255)) AS [DEM:Sex],
--				CAST(b.apgar_1 AS VARCHAR(255)) AS [APGAR1],
--				CAST(b.apgar_5 AS VARCHAR(255)) AS [APGAR5],
--				CAST(b.apgar_10 AS VARCHAR(255)) AS [APGAR10],
--				'The State' AS downloaded_from,
--				b.imported_at AS downloaded_at
--			FROM vital_records.birth b
--			JOIN private.identifiers i
--				ON i.source_id = b.state_file_number
--				AND i.source_column = 'state_file_number'
--				AND i.source_table = 'birth'
--				AND i.source_schema = 'vital_records'
--			WHERE b.imported_to_dw = 'FALSE'
--		) unimported_birth_record_data
--		UNPIVOT (
--			value FOR concept IN ( [DEM:Sex], [APGAR1], [APGAR5], [APGAR10] )
--		) AS anotherarbitraryrequiredname
--
--	INSERT INTO dbo.observations
--		(chirp_id, provider_id, started_at,
--			concept, value, downloaded_from, downloaded_at)
--		SELECT chirp_id, provider_id, started_at,
--			concept, value, downloaded_from, downloaded_at
--		FROM (
--			SELECT i.chirp_id, b.date_of_birth AS started_at,
--				'123' AS provider_id,
--				CAST(b.date_of_birth AS VARCHAR(255)) AS [DEM:DOB],
--				'The State' AS downloaded_from,
--				b.imported_at AS downloaded_at
--			FROM vital_records.birth b
--			JOIN private.identifiers i
--				ON i.source_id = b.state_file_number
--				AND i.source_column = 'state_file_number'
--				AND i.source_table = 'birth'
--				AND i.source_schema = 'vital_records'
--			WHERE b.imported_to_dw = 'FALSE'
--		) arbitraryrequiredandignoredname
--		UNPIVOT (
--			value FOR concept IN ( [DEM:DOB] )
--		) AS anotherarbitraryrequiredname
--
-- ORDER MATTERS! SELECT ORDER MUST BE THE SAME AS INSERT ORDER!

--	INSERT INTO dbo.observations
--		(chirp_id, provider_id, started_at,
--			concept, value, units, downloaded_from, downloaded_at)
--		SELECT i.chirp_id,
--			'123' AS provider_id,
--			b.date_of_birth AS started_at,
--			'DEM:Weight' AS concept,
--			CAST(
--				(CAST(b.birth_weight_lbs AS FLOAT) + (CAST(b.birth_weight_oz AS FLOAT)/16)) AS VARCHAR(255)
--			) AS value,
--			'lbs' AS units,
--			'The State' AS downloaded_from,
--			b.imported_at AS downloaded_at
--		FROM vital_records.birth b
--		JOIN private.identifiers i
--			ON i.source_id = b.state_file_number
--			AND i.source_column = 'state_file_number'
--			AND i.source_table = 'birth'
--			AND i.source_schema = 'vital_records'
--		WHERE b.imported_to_dw = 'FALSE'
--			AND b.birth_weight_lbs IS NOT NULL
--			AND b.birth_weight_oz IS NOT NULL

	UPDATE n
		SET imported_to_dw = 'TRUE'
		FROM vital_records.birth n
		JOIN private.identifiers i
			ON  i.source_id     = n.state_file_number
			AND i.source_column = 'state_file_number'
			AND i.source_table  = 'birth'
			AND i.source_schema = 'vital_records'
		WHERE imported_to_dw = 'FALSE'
			AND i.id IS NOT NULL

END -- CREATE PROCEDURE dbo.import_into_data_warehouse_by_table_vital_records_birth
GO


IF OBJECT_ID ( 'dbo.import_into_data_warehouse_by_schema', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.import_into_data_warehouse_by_schema;
GO
CREATE PROCEDURE dbo.import_into_data_warehouse_by_schema( @schema VARCHAR(50) )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @table VARCHAR(250)
	DECLARE @proc VARCHAR(250)

	DECLARE tables CURSOR FOR SELECT t.name
		FROM sys.tables AS t
		INNER JOIN sys.schemas AS s
		ON t.schema_id = s.schema_id
		WHERE s.name = @schema;

	OPEN tables
	WHILE(1=1)BEGIN
		FETCH tables INTO @table;
		IF(@@FETCH_STATUS <> 0) BREAK

		SET @proc = 'dbo.import_into_data_warehouse_by_table_' + @schema + '_' + @table

		IF OBJECT_ID ( @proc, 'P' ) IS NOT NULL
		BEGIN
			PRINT 'Importing select fields from ' + @schema + '.' + @table
			EXEC @proc
		END
		ELSE
			PRINT 'Ignoring table ' + @schema + '.' + @table

	END
	CLOSE tables;
	DEALLOCATE tables;

END	--	dbo.import_into_data_warehouse_by_schema
GO

IF OBJECT_ID ( 'dbo.import_into_data_warehouse', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.import_into_data_warehouse;
GO
CREATE PROCEDURE dbo.import_into_data_warehouse
AS
BEGIN
	SET NOCOUNT ON;

--	DECLARE @schemas TABLE ( name VARCHAR(50) )
--	INSERT INTO @schemas VALUES ( 'vital_records' )	
--
--	DECLARE schemas CURSOR FOR SELECT s.name FROM @schemas s
--
--	DECLARE @schema VARCHAR(50)
--
--	OPEN schemas
--	WHILE(1=1)BEGIN
--		FETCH schemas INTO @schema;
--		IF(@@FETCH_STATUS <> 0) BREAK
--		PRINT @schema
--		EXEC dbo.import_into_data_warehouse_by_schema @schema

		--Until there are more than a dozen, this above is a bit excessive!
		EXEC dbo.import_into_data_warehouse_by_schema 'vital_records'
		EXEC dbo.import_into_data_warehouse_by_schema 'health_lab'
		EXEC dbo.import_into_data_warehouse_by_schema 'fakedoc1'

--	END
--	CLOSE schemas;
--	DEALLOCATE schemas;

END	--	dbo.import_into_data_warehouse
GO



