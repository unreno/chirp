
IF OBJECT_ID ( 'dbo.import_into_data_warehouse_by_table_health_lab_newborn_screening', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.import_into_data_warehouse_by_table_health_lab_newborn_screening;
GO
CREATE PROCEDURE dbo.import_into_data_warehouse_by_table_health_lab_newborn_screening
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.observations
		(chirp_id, provider_id, location_id, started_at, value_type,
			concept, s_value, downloaded_from, downloaded_at)
		SELECT chirp_id, provider_id, location_id, started_at, value_type,
			concept, s_value, downloaded_from, downloaded_at
		FROM (
			SELECT i.chirp_id, n.date_of_birth AS started_at,
				'789' AS provider_id,
				'123' AS location_id,
				'S' AS value_type,


				'DEM:Other' AS concept,
				yadayada, blahblah,


				'Health Lab' AS downloaded_from,
				n.imported_at AS downloaded_at
			FROM health_lab.newborn_screening n
			JOIN private.identifiers i
				ON    i.source_id     = n.id
					AND i.source_column = 'id'
					AND i.source_table  = 'newborn_screening'
					AND i.source_schema = 'health_lab'
			WHERE n.imported_to_dw = 'FALSE'
		) arbitraryrequiredandignoredname
		UNPIVOT (


			s_value FOR ignoreconcept IN ( yadayada, blahblah )


		) AS anotherarbitraryrequiredname

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


IF OBJECT_ID ( 'dbo.import_into_data_warehouse_by_table_vital_records_birth', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.import_into_data_warehouse_by_table_vital_records_birth;
GO
CREATE PROCEDURE dbo.import_into_data_warehouse_by_table_vital_records_birth
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.observations
		(chirp_id, provider_id, location_id, started_at, value_type,
			concept, s_value, downloaded_from, downloaded_at)
		SELECT chirp_id, provider_id, location_id, started_at, value_type,
			concept, s_value, downloaded_from, downloaded_at
		FROM (
			SELECT i.chirp_id, b.date_of_birth AS started_at,
				'123' AS provider_id,
				'456' AS location_id,
				'S' AS value_type,
				CONVERT(VARCHAR(255), b.sex) AS [DEM:Sex],
				'The State' AS downloaded_from,
				b.imported_at AS downloaded_at
			FROM vital_records.birth b
			JOIN private.identifiers i
				ON i.source_id = b.state_file_number
				AND i.source_column = 'state_file_number'
				AND i.source_table = 'birth'
				AND i.source_schema = 'vital_records'
			WHERE b.imported_to_dw = 'FALSE'
		) arbitraryrequiredandignoredname
		UNPIVOT (
			s_value FOR concept IN ( [DEM:Sex] )
		) AS anotherarbitraryrequiredname

	INSERT INTO dbo.observations
		(chirp_id, provider_id, location_id, started_at, value_type,
			concept, t_value, downloaded_from, downloaded_at)
--			concept, s_value, downloaded_from, downloaded_at)
		SELECT chirp_id, provider_id, location_id, started_at, value_type,
			concept, t_value, downloaded_from, downloaded_at
--			concept, s_value, downloaded_from, downloaded_at
		FROM (
			SELECT i.chirp_id, b.date_of_birth AS started_at,
				'123' AS provider_id,
				'456' AS location_id,

				'T' AS value_type,
				b.date_of_birth AS [DEM:DOB],
--	If we drop the specific value types
--				'S' AS value_type,
--				CAST(b.date_of_birth AS VARCHAR(255)) AS [DEM:DOB],

				'The State' AS downloaded_from,
				b.imported_at AS downloaded_at
			FROM vital_records.birth b
			JOIN private.identifiers i
				ON i.source_id = b.state_file_number
				AND i.source_column = 'state_file_number'
				AND i.source_table = 'birth'
				AND i.source_schema = 'vital_records'
			WHERE b.imported_to_dw = 'FALSE'
		) arbitraryrequiredandignoredname
		UNPIVOT (
			t_value FOR concept IN ( [DEM:DOB] )
--			s_value FOR concept IN ( [DEM:DOB] )
		) AS anotherarbitraryrequiredname

--	INSERT INTO dbo.observations
--		(chirp_id, provider_id, location_id, started_at, value_type,
--			concept, n_value, downloaded_from, downloaded_at)
--		SELECT chirp_id, provider_id, location_id, started_at, value_type,
--			concept, n_value, downloaded_from, downloaded_at
--		FROM (
--			SELECT i.chirp_id, b.date_of_birth AS started_at,
--				'123' AS provider_id,
--				'456' AS location_id,
--				'N' AS value_type,
--				(CAST(b.birth_weight_lbs AS FLOAT) + (CAST(b.birth_weight_oz AS FLOAT)/16)) AS [DEM:Weight],
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
--			n_value FOR concept IN ( [DEM:Weight] )
--		) AS anotherarbitraryrequiredname


--	The UNPIVOT seems really unnecessary if only doing 1 column.
--	Particularly when it is unique (contains units)

-- ORDER MATTERS! SELECT ORDER MUST BE THE SAME AS INSERT ORDER!

	INSERT INTO dbo.observations
		(chirp_id, provider_id, location_id, started_at, value_type,
			concept, n_value, units, downloaded_from, downloaded_at)
--			concept, s_value, units, downloaded_from, downloaded_at)
		SELECT i.chirp_id,
			'123' AS provider_id,
			'456' AS location_id,
			b.date_of_birth AS started_at,

			'N' AS value_type,
			'DEM:Weight' AS concept,
			(CAST(b.birth_weight_lbs AS FLOAT) + (CAST(b.birth_weight_oz AS FLOAT)/16)) AS n_value,
--	If we drop the specific value types
--			'S' AS value_type,
--			CAST((CAST(b.birth_weight_lbs AS FLOAT) + (CAST(b.birth_weight_oz AS FLOAT)/16)) AS VARCHAR(255)) AS s_value,


			'lbs' AS units,
			'The State' AS downloaded_from,
			b.imported_at AS downloaded_at
		FROM vital_records.birth b
		JOIN private.identifiers i
			ON i.source_id = b.state_file_number
			AND i.source_column = 'state_file_number'
			AND i.source_table = 'birth'
			AND i.source_schema = 'vital_records'
		WHERE b.imported_to_dw = 'FALSE'
			AND b.birth_weight_lbs IS NOT NULL
			AND b.birth_weight_oz IS NOT NULL

--	UPDATE vital_records.birth
--		SET imported_to_dw = 'TRUE'
--		WHERE imported_to_dw = 'FALSE'

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

--	END
--	CLOSE schemas;
--	DEALLOCATE schemas;

END	--	dbo.import_into_data_warehouse
GO



