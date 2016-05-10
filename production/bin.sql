
-- MS Sets these before every “CREATE TRIGGER”
-- Not sure if calling them once will suffice.
-- Deeded?
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='bin')
	EXEC('CREATE SCHEMA bin')
GO


--Database diagram support objects cannot be installed because this database does not have a valid owner. To continue, first use the Files page of the Database Properties dialog box or the ALTER AUTHORIZATION statement to set the database owner to a valid login, then add the database diagram support objects.
--Wanted to see these Database Diagrams and this seemed to work.
--This changes the database owner to [sa]. I'd prefer to keep it.
--ALTER AUTHORIZATION ON DATABASE::chirp TO [sa];





IF OBJECT_ID ( 'bin.add_imported_at_column_to_table', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.add_imported_at_column_to_table;
GO
CREATE PROCEDURE bin.add_imported_at_column_to_table(@schema VARCHAR(255),@table VARCHAR(255))
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @cmd VARCHAR(255);
	DECLARE @cname VARCHAR(255);

	SELECT @cname = @schema + '_' + @table + '_imported_at_default';

/*
	--Remove constraint if exists
	SELECT @cmd = 'IF OBJECT_ID(''[' + @schema + '].[' + @cname + ']'') IS NOT NULL ' +
		'ALTER TABLE ' + @schema + '.[' + @table +'] DROP CONSTRAINT ' + @cname + ';'
	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!

	--Remove column if exists
	SELECT @cmd = 'IF COL_LENGTH(''[' + @schema + '].[' + @table + 
		']'',''imported_at'') IS NOT NULL '+
		'ALTER TABLE ' + @schema + '.[' + @table + '] DROP COLUMN imported_at;'
	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!
*/

	--Add column with constraint
	SELECT @cmd = 'ALTER TABLE [' + @schema + '].[' + @table + 
		'] ADD imported_at DATETIME CONSTRAINT '
		+ @cname + ' DEFAULT CURRENT_TIMESTAMP NOT NULL ;';
--	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!

END
GO


IF OBJECT_ID ( 'bin.add_imported_at_column_to_tables_by_schema', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.add_imported_at_column_to_tables_by_schema;
GO
CREATE PROCEDURE bin.add_imported_at_column_to_tables_by_schema(@schema VARCHAR(255))
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @table VARCHAR(255);

	DECLARE tables CURSOR FOR SELECT t.name 
		FROM sys.tables AS t
		INNER JOIN sys.schemas AS s
		ON t.schema_id = s.schema_id
		WHERE s.name = @schema;

	OPEN tables;
	WHILE(1=1)BEGIN
		FETCH tables INTO @table;
		IF(@@FETCH_STATUS <> 0) BREAK
--		PRINT @table
		EXEC bin.add_imported_at_column_to_table @schema, @table
	END
	CLOSE tables;
	DEALLOCATE tables;
END
GO


IF OBJECT_ID ( 'bin.add_imported_to_dw_column_to_table', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.add_imported_to_dw_column_to_table;
GO
CREATE PROCEDURE bin.add_imported_to_dw_column_to_table(@schema VARCHAR(255),@table VARCHAR(255))
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @cmd VARCHAR(255);
	DECLARE @cname VARCHAR(255);

	SELECT @cname = @schema + '_' + @table + '_imported_to_dw_default';

/*
	--Remove constraint if exists
	SELECT @cmd = 'IF OBJECT_ID(''[' + @schema + '].[' + @cname + ']'') IS NOT NULL ' +
		'ALTER TABLE ' + @schema + '.[' + @table +'] DROP CONSTRAINT ' + @cname + ';'
	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!

	--Remove column if exists
	SELECT @cmd = 'IF COL_LENGTH(''[' + @schema + '].[' + @table + 
		']'',''imported_to_dw'') IS NOT NULL '+
		'ALTER TABLE ' + @schema + '.[' + @table + '] DROP COLUMN imported_to_dw;'
	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!
*/
	--Add column with constraint
	SELECT @cmd = 'ALTER TABLE [' + @schema + '].[' + @table + 
		'] ADD imported_to_dw BIT CONSTRAINT '
		+ @cname + ' DEFAULT ''FALSE'' NOT NULL ;';
--	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!

END
GO


IF OBJECT_ID ( 'bin.add_imported_to_dw_column_to_tables_by_schema', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.add_imported_to_dw_column_to_tables_by_schema;
GO
CREATE PROCEDURE bin.add_imported_to_dw_column_to_tables_by_schema(@schema VARCHAR(255))
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @table VARCHAR(255);

	DECLARE tables CURSOR FOR SELECT t.name 
		FROM sys.tables AS t
		INNER JOIN sys.schemas AS s
		ON t.schema_id = s.schema_id
		WHERE s.name = @schema;

	OPEN tables;
	WHILE(1=1)BEGIN
		FETCH tables INTO @table;
		IF(@@FETCH_STATUS <> 0)
			BREAK
--		PRINT @table
		EXEC bin.add_imported_to_dw_column_to_table @schema, @table
	END
	CLOSE tables;
	DEALLOCATE tables;

END
GO










--Give the constraint a predictable name so that can be removed if needed.
--(Otherwise name is arbitrary DF__birth__importe_____ADF4456 or similar.)
--FYI (NOT NULL is not a "constraint", but DEFAULT is so it must be adjacent to the name.)
--CONSTRAINT -NAME- DEFAULT 0 NOT NULL - works
--CONSTRAINT -NAME- NOT NULL DEFAULT - DOES NOT work (arbitrarily named)


--INSERT INTO vital.birth (birthid,imported_to_dw) VALUES (1,'true');  -- 'true'=1
--INSERT INTO vital.birth (birthid,imported_to_dw) VALUES (1,'false'); -- 'false'=0
--INSERT INTO vital.birth (birthid,imported_to_dw) VALUES (1,'blahblahblah');
--INSERT INTO vital.birth (birthid) values (1);
--Conversion failed when converting the varchar value 'blahblahblah' to data type bit







/*

SELECT * FROM vital.birth b
	JOIN private.identifiers p 
	ON p.source_id = b.state_file_number 
	AND p.source_name = 'birth_sfn'
	WHERE b.imported_to_dw = 'FALSE'


SELECT * FROM sys.columns  c
	INNER JOIN sys.tables t 
	ON c.object_id = t.object_id
	INNER JOIN sys.schemas s
	ON t.schema_id = s.schema_id
	WHERE s.name = 'vital' AND t.name = 'birth'


SELECT * FROM sys.columns  c
	INNER JOIN sys.tables t 
	ON c.object_id = t.object_id
	INNER JOIN sys.schemas s
	ON t.schema_id = s.schema_id
	JOIN concepts cc 
	ON cc.code = s.name + ':' + t.name + ':' + c.name 
	WHERE s.name = 'vital' AND t.name = 'birth' AND cc.id IS NOT NULL

*/


IF OBJECT_ID ( 'bin.import_into_data_warehouse_by_table_fakedoc1_emrs', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_into_data_warehouse_by_table_fakedoc1_emrs;
GO
CREATE PROCEDURE bin.import_into_data_warehouse_by_table_fakedoc1_emrs
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.observations
		(chirp_id, provider_id, started_at,
			concept, value, units, source_schema, source_table, downloaded_at)
		SELECT i.chirp_id, 
			8675309 AS provider_id,
			n.service_at AS started_at,
			code AS concept,
			value AS value,
			units AS units,
			'fakedoc1' AS source_schema,
			'emrs' AS source_table,
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

END	--	CREATE PROCEDURE bin.import_into_data_warehouse_by_table_fakedoc1_emrs
GO


IF OBJECT_ID ( 'bin.import_into_data_warehouse_by_table_health_lab_newborn_screening', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_into_data_warehouse_by_table_health_lab_newborn_screening;
GO
CREATE PROCEDURE bin.import_into_data_warehouse_by_table_health_lab_newborn_screening
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.observations
		(chirp_id, provider_id, started_at,
			concept, value, units, source_schema, source_table, downloaded_at)
		SELECT chirp_id, provider_id, started_at,
			cav.concept, cav.value, cav.units, source_schema, source_table, downloaded_at
		FROM (
			SELECT i.chirp_id, n.date_of_birth AS started_at,
				'789' AS provider_id,
				testresults1, testresults2, testresults3, testresults4, testresults5,
				'health_lab' AS source_schema,
				'newborn_screening' AS source_table,
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

END	--	CREATE PROCEDURE bin.import_into_data_warehouse_by_table_health_lab_newborn_screening
GO



IF OBJECT_ID ( 'bin.weight_from_lbs_and_oz', 'FN' ) IS NOT NULL
	DROP FUNCTION bin.weight_from_lbs_and_oz;
GO
CREATE FUNCTION bin.weight_from_lbs_and_oz( @lbs INT, @oz INT )
	RETURNS FLOAT
BEGIN
	DECLARE @w FLOAT;
	IF @lbs IS NOT NULL AND @oz IS NOT NULL
		SET @w = CAST(@lbs AS FLOAT) + CAST(@oz AS FLOAT)/16
	RETURN @w
END
GO



IF OBJECT_ID ( 'bin.import_into_data_warehouse_by_table_vital_birth', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_into_data_warehouse_by_table_vital_birth;
GO
CREATE PROCEDURE bin.import_into_data_warehouse_by_table_vital_birth
AS
BEGIN
	SET NOCOUNT ON;


--	Will the birth2 table include the unique identifer? (state_file_number in my demo)
--	If so, separate instead of join? Faster? Cleaner? Clearer?


	INSERT INTO dbo.observations
		(chirp_id, provider_id, started_at,
			concept, value, units, source_schema, source_table, downloaded_at)
		SELECT chirp_id, provider_id, started_at,
			cav.concept, cav.value, cav.units, source_schema, source_table, downloaded_at
		FROM (
			SELECT i.chirp_id, date_of_birth AS started_at,
				0 AS provider_id,
				'vital' AS source_schema,
				'birth' AS source_table,
				date_of_birth, birth_weight_lbs, birth_weight_oz,
				sex, apgar_1, apgar_5, apgar_10,
				gestation_weeks,
				b2.infant_living,
				b.imported_at AS downloaded_at
			FROM vital.birth b
			LEFT JOIN vital.birth2 b2 	--need left join as in real life, all may not have?
				ON b.birth2id = b2.birth2id
			JOIN private.identifiers i
				ON i.source_id = b.state_file_number
				AND i.source_column = 'state_file_number'
				AND i.source_table = 'birth'
				AND i.source_schema = 'vital'
			WHERE b.imported_to_dw = 'FALSE'
		) unimported_birth_record_data
		CROSS APPLY ( VALUES
			( 'DEM:DOB', CAST(CAST(date_of_birth AS DATE) AS VARCHAR(255)), NULL ),
			( 'DEM:Weight', CAST(
				bin.weight_from_lbs_and_oz( birth_weight_lbs, birth_weight_oz ) AS VARCHAR(255)), 'lbs'),
			( 'DEM:Sex', bin.decode('vital','birth','sex',sex), NULL ),
--			( 'infant_living', bin.decode('vital','birth','standard2_yesno',infant_living), NULL ),
-- infant_living is going to be inf_liv in real data, I think.
			( 'infant_living', bin.decode('vital','birth','inf_liv',infant_living), NULL ),
			( 'gestation_weeks', CAST(gestation_weeks AS VARCHAR(255)), NULL ),
			( 'APGAR1', CAST(apgar_1 AS VARCHAR(255)), NULL ),
			( 'APGAR5', CAST(apgar_5 AS VARCHAR(255)), NULL ),
			( 'APGAR10', CAST(apgar_10 AS VARCHAR(255)), NULL )
		) cav ( concept, value, units )
		WHERE cav.value IS NOT NULL
--			( 'DEM:Sex', sex, NULL ),
--			( 'infant_living', infant_living, NULL ),

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
--			concept, value, source_schema, source_table, downloaded_at)
--		SELECT chirp_id, provider_id, started_at,
--			concept, value, source_schema, source_table, downloaded_at
--		FROM (
--			SELECT i.chirp_id, b.date_of_birth AS started_at,
--				'123' AS provider_id,
--				CAST(b.sex AS VARCHAR(255)) AS [DEM:Sex],
--				CAST(b.apgar_1 AS VARCHAR(255)) AS [APGAR1],
--				CAST(b.apgar_5 AS VARCHAR(255)) AS [APGAR5],
--				CAST(b.apgar_10 AS VARCHAR(255)) AS [APGAR10],
--				'vital' AS source_schema,
--				'birth' AS source_table,
--				b.imported_at AS downloaded_at
--			FROM vital.birth b
--			JOIN private.identifiers i
--				ON i.source_id = b.state_file_number
--				AND i.source_column = 'state_file_number'
--				AND i.source_table = 'birth'
--				AND i.source_schema = 'vital'
--			WHERE b.imported_to_dw = 'FALSE'
--		) unimported_birth_record_data
--		UNPIVOT (
--			value FOR concept IN ( [DEM:Sex], [APGAR1], [APGAR5], [APGAR10] )
--		) AS anotherarbitraryrequiredname
--
--	INSERT INTO dbo.observations
--		(chirp_id, provider_id, started_at,
--			concept, value, source_schema, source_table, downloaded_at)
--		SELECT chirp_id, provider_id, started_at,
--			concept, value, source_schema, source_table, downloaded_at
--		FROM (
--			SELECT i.chirp_id, b.date_of_birth AS started_at,
--				'123' AS provider_id,
--				CAST(b.date_of_birth AS VARCHAR(255)) AS [DEM:DOB],
--				'vital' AS source_schema,
--				'birth' AS source_table,
--				b.imported_at AS downloaded_at
--			FROM vital.birth b
--			JOIN private.identifiers i
--				ON i.source_id = b.state_file_number
--				AND i.source_column = 'state_file_number'
--				AND i.source_table = 'birth'
--				AND i.source_schema = 'vital'
--			WHERE b.imported_to_dw = 'FALSE'
--		) arbitraryrequiredandignoredname
--		UNPIVOT (
--			value FOR concept IN ( [DEM:DOB] )
--		) AS anotherarbitraryrequiredname
--
-- ORDER MATTERS! SELECT ORDER MUST BE THE SAME AS INSERT ORDER!

--	INSERT INTO dbo.observations
--		(chirp_id, provider_id, started_at,
--			concept, value, units, source_schema, source_table, downloaded_at)
--		SELECT i.chirp_id,
--			'123' AS provider_id,
--			b.date_of_birth AS started_at,
--			'DEM:Weight' AS concept,
--			CAST(
--				(CAST(b.birth_weight_lbs AS FLOAT) + (CAST(b.birth_weight_oz AS FLOAT)/16)) AS VARCHAR(255)
--			) AS value,
--			'lbs' AS units,
--			'vital' AS source_schema,
--			'birth' AS source_table,
--			b.imported_at AS downloaded_at
--		FROM vital.birth b
--		JOIN private.identifiers i
--			ON i.source_id = b.state_file_number
--			AND i.source_column = 'state_file_number'
--			AND i.source_table = 'birth'
--			AND i.source_schema = 'vital'
--		WHERE b.imported_to_dw = 'FALSE'
--			AND b.birth_weight_lbs IS NOT NULL
--			AND b.birth_weight_oz IS NOT NULL

	UPDATE b
		SET imported_to_dw = 'TRUE'
		FROM vital.birth b
		JOIN private.identifiers i
			ON  i.source_id     = b.state_file_number
			AND i.source_column = 'state_file_number'
			AND i.source_table  = 'birth'
			AND i.source_schema = 'vital'
		WHERE imported_to_dw = 'FALSE'
			AND i.id IS NOT NULL

	UPDATE b2
		SET imported_to_dw = 'TRUE'
		FROM vital.birth2 b2
		JOIN vital.birth b
			ON b.birth2id = b2.birth2id
		JOIN private.identifiers i
			ON  i.source_id     = b.state_file_number
			AND i.source_column = 'state_file_number'
			AND i.source_table  = 'birth'
			AND i.source_schema = 'vital'
		WHERE b.imported_to_dw = 'FALSE'
			AND i.id IS NOT NULL

END -- CREATE PROCEDURE bin.import_into_data_warehouse_by_table_vital_birth
GO


IF OBJECT_ID ( 'bin.import_into_data_warehouse_by_schema', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_into_data_warehouse_by_schema;
GO
CREATE PROCEDURE bin.import_into_data_warehouse_by_schema( @schema VARCHAR(50) )
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

		SET @proc = 'bin.import_into_data_warehouse_by_table_' + @schema + '_' + @table

		IF OBJECT_ID ( @proc, 'P' ) IS NOT NULL
		BEGIN
--			PRINT 'Importing select fields from ' + @schema + '.' + @table
			EXEC @proc
		END
--		ELSE
--			PRINT 'Ignoring table ' + @schema + '.' + @table

	END
	CLOSE tables;
	DEALLOCATE tables;

END	--	bin.import_into_data_warehouse_by_schema
GO

IF OBJECT_ID ( 'bin.import_into_data_warehouse', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_into_data_warehouse;
GO
CREATE PROCEDURE bin.import_into_data_warehouse
AS
BEGIN
	SET NOCOUNT ON;

--	DECLARE @schemas TABLE ( name VARCHAR(50) )
--	INSERT INTO @schemas VALUES ( 'vital' )	
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
--		EXEC bin.import_into_data_warehouse_by_schema @schema

		--Until there are more than a dozen, this above is a bit excessive!
		EXEC bin.import_into_data_warehouse_by_schema 'vital'
		EXEC bin.import_into_data_warehouse_by_schema 'health_lab'
		EXEC bin.import_into_data_warehouse_by_schema 'fakedoc1'

--	END
--	CLOSE schemas;
--	DEALLOCATE schemas;

END	--	bin.import_into_data_warehouse
GO









-- syntax highlighting shows "decode" as blue. Reserved?

IF OBJECT_ID ( 'bin.decode', 'FN' ) IS NOT NULL
	DROP FUNCTION bin.decode;
GO
CREATE FUNCTION bin.decode( @source VARCHAR(50), @gang VARCHAR(50), @trait VARCHAR(50), @code INT )
	RETURNS VARCHAR(255)
BEGIN
	DECLARE @value VARCHAR(255);
	-- Don't put functions in WHERE clause. Performance issues.
	-- Something about being called for every row. Unless you need that.
	-- We don't need that here.
	DECLARE @tmp VARCHAR(255) = bin.decoder(@source,@gang,@trait);
	SELECT @value = value FROM dbo.codes
		WHERE source = @source 
			AND gang = @gang 
			AND trait = @tmp
			AND code = @code
	RETURN ISNULL(@value, @code)
END
GO

IF OBJECT_ID ( 'bin.decoder', 'FN' ) IS NOT NULL
	DROP FUNCTION bin.decoder;
GO
CREATE FUNCTION bin.decoder( @source VARCHAR(50), @gang VARCHAR(50), @trait VARCHAR(50) )
	RETURNS VARCHAR(255)
BEGIN
	DECLARE @codeset VARCHAR(255);
	SELECT @codeset = codeset FROM dbo.decoders
		WHERE source = @source 
			AND gang = @gang 
			AND trait = @trait 
	RETURN ISNULL(@codeset, @trait)
END
GO




--	DROP TYPE bin.NamesTableType;	-- Can't be dropped if being referenced.
CREATE TYPE bin.NamesTableType AS TABLE ( name VARCHAR(255) )
GO


IF OBJECT_ID ( 'bin.group_by_each_where', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.group_by_each_where;
GO

CREATE PROCEDURE bin.group_by_each_where( @schema VARCHAR(255), @table VARCHAR(255),
	@exclude bin.NamesTableType READONLY, @condition VARCHAR(255) = '1=1' )
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SQL NVARCHAR(MAX) = '';
	-- I could add the prefix WHERE to @condition if not blank, but '1=1' works.
	SELECT @SQL = (
		SELECT 'SELECT CASE WHEN (GROUPING(' + QUOTENAME(name) + ') = 1) THEN ''Total'' ELSE CAST(' + 
			QUOTENAME(name) + ' AS VARCHAR) END AS ' + QUOTENAME(name) + ', COUNT(*) AS [count], ' +
      '( 2 * COUNT(*) * 100. / SUM(COUNT(*)) OVER()) AS [percent] FROM ' +
      QUOTENAME(@schema) + '.' + QUOTENAME(@table) + 
			' WHERE ' + @condition + ' GROUP BY ' + QUOTENAME(name) + 
			' WITH ROLLUP ORDER BY ' + QUOTENAME(name) + ';'
		FROM   sys.columns
		WHERE  object_id = OBJECT_ID(@schema + '.' + @table)
		AND name NOT IN (SELECT name FROM @exclude)
	-- concatenate result strings with FOR XML PATH
	FOR XML PATH (''));
	EXECUTE sp_executesql @SQL;
END
GO

IF OBJECT_ID ( 'bin.group_by_each', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.group_by_each;
GO

CREATE PROCEDURE bin.group_by_each( @schema VARCHAR(255), @table VARCHAR(255),
	@exclude bin.NamesTableType READONLY )
AS
BEGIN
	SET NOCOUNT ON;
	EXEC bin.group_by_each_where @schema, @table, @exclude, default
END
GO


-- This does work, but not helpful
--DECLARE @exclude bin.NamesTableType;
--INSERT INTO @exclude VALUES ('id'),('chirp_id'),('provider_id'),('concept'),('started_at'),('downloaded_at');
--EXEC bin.group_by_each_where 'dbo','observations',@exclude,'concept = ''infant_living'''
-- So does this! 'default' uses a blank table. Also not helpful. Nice to know though.
--EXEC bin.group_by_each_where 'dbo','observations',default,'concept = ''infant_living'''






IF OBJECT_ID ( 'bin.distinct_value_counts_where', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.distinct_value_counts_where;
GO

CREATE PROCEDURE bin.distinct_value_counts_where( @schema VARCHAR(255), @table VARCHAR(255),
	@exclude bin.NamesTableType READONLY, @condition VARCHAR(255) = '1=1' )
AS
BEGIN
	SET NOCOUNT ON;
	CREATE TABLE #out ( name VARCHAR(255), count INT );
	DECLARE @SQL NVARCHAR(MAX) = '';
	-- I could add the prefix WHERE to @condition if not blank, but '1=1' works.
	SELECT @SQL = (
		SELECT 'INSERT INTO #out(name,count) SELECT ''' + name + 
			''' AS name, COUNT(DISTINCT ' + 
			QUOTENAME(name) + ') AS [count] ' +
			' FROM ' + QUOTENAME(@schema) + '.' + QUOTENAME(@table) + 
			' WHERE ' + @condition + ';'
		FROM   sys.columns
		WHERE  object_id = OBJECT_ID(@schema + '.' + @table)
		AND name NOT IN (SELECT name FROM @exclude)
	-- concatenate result strings with FOR XML PATH
	FOR XML PATH (''));
	EXECUTE sp_executesql @SQL;
	SELECT * FROM #out
END
GO

IF OBJECT_ID ( 'bin.distinct_value_counts', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.distinct_value_counts;
GO

CREATE PROCEDURE bin.distinct_value_counts( @schema VARCHAR(255), @table VARCHAR(255),
	@exclude bin.NamesTableType READONLY )
AS
BEGIN
	SET NOCOUNT ON;
	EXEC  bin.distinct_value_counts_where @schema, @table, @exclude, default
END
GO

--EXEC bin.distinct_value_counts 'vital', 'birth', default
