
-- MS Sets these before every “CREATE TRIGGER”
-- Not sure if calling them once will suffice.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Database diagram support objects cannot be installed because this database does not have a valid owner. To continue, first use the Files page of the Database Properties dialog box or the ALTER AUTHORIZATION statement to set the database owner to a valid login, then add the database diagram support objects.
--Wanted to see these Database Diagrams and this seemed to work.
--This changes the database owner to [sa]. I'd prefer to keep it.
--ALTER AUTHORIZATION ON DATABASE::chirp TO [sa];





IF OBJECT_ID ( 'dbo.add_imported_at_column_to_table', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.add_imported_at_column_to_table;
GO
CREATE PROCEDURE dbo.add_imported_at_column_to_table(@schema VARCHAR(255),@table VARCHAR(255))
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


IF OBJECT_ID ( 'dbo.add_imported_at_column_to_tables_by_schema', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.add_imported_at_column_to_tables_by_schema;
GO
CREATE PROCEDURE dbo.add_imported_at_column_to_tables_by_schema(@schema VARCHAR(255))
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
		PRINT @table
		EXEC dbo.add_imported_at_column_to_table @schema, @table
	END
	CLOSE tables;
	DEALLOCATE tables;
END
GO


IF OBJECT_ID ( 'dbo.add_imported_to_dw_column_to_table', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.add_imported_to_dw_column_to_table;
GO
CREATE PROCEDURE dbo.add_imported_to_dw_column_to_table(@schema VARCHAR(255),@table VARCHAR(255))
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
	PRINT @cmd
	EXEC (@cmd);	--	Parenthese required here!

END
GO


IF OBJECT_ID ( 'dbo.add_imported_to_dw_column_to_tables_by_schema', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.add_imported_to_dw_column_to_tables_by_schema;
GO
CREATE PROCEDURE dbo.add_imported_to_dw_column_to_tables_by_schema(@schema VARCHAR(255))
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
		PRINT @table
		EXEC dbo.add_imported_to_dw_column_to_table @schema, @table
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


--INSERT INTO vital_records.birth (birthid,imported_to_dw) VALUES (1,'true');  -- 'true'=1
--INSERT INTO vital_records.birth (birthid,imported_to_dw) VALUES (1,'false'); -- 'false'=0
--INSERT INTO vital_records.birth (birthid,imported_to_dw) VALUES (1,'blahblahblah');
--INSERT INTO vital_records.birth (birthid) values (1);
--Conversion failed when converting the varchar value 'blahblahblah' to data type bit







/*

SELECT * FROM vital_records.birth b
	JOIN private.identifiers p 
	ON p.source_id = b.state_file_number 
	AND p.source_name = 'birth_sfn'
	WHERE b.imported_to_dw = 'FALSE'


SELECT * FROM sys.columns  c
	INNER JOIN sys.tables t 
	ON c.object_id = t.object_id
	INNER JOIN sys.schemas s
	ON t.schema_id = s.schema_id
	WHERE s.name = 'vital_records' AND t.name = 'birth'


SELECT * FROM sys.columns  c
	INNER JOIN sys.tables t 
	ON c.object_id = t.object_id
	INNER JOIN sys.schemas s
	ON t.schema_id = s.schema_id
	JOIN concepts cc 
	ON cc.code = s.name + ':' + t.name + ':' + c.name 
	WHERE s.name = 'vital_records' AND t.name = 'birth' AND cc.id IS NOT NULL

*/
