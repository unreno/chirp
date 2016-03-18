
-- MS Sets these before every “CREATE TRIGGER”
-- Not sure if calling them once will suffice.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE master;
IF db_id('chirp') IS NOT NULL
	DROP DATABASE chirp;

-- "WITH TRUSTWORTHY ON" required for use of tSQLt Testing Framework.
--CREATE DATABASE chirp WITH TRUSTWORTHY ON;
CREATE DATABASE chirp;
GO
USE chirp;

--Database diagram support objects cannot be installed because this database does not have a valid owner. To continue, first use the Files page of the Database Properties dialog box or the ALTER AUTHORIZATION statement to set the database owner to a valid login, then add the database diagram support objects.
--Wanted to see these Database Diagrams and this seemed to work.
--This changes the database owner to [sa]. I'd prefer to keep it.
--ALTER AUTHORIZATION ON DATABASE::chirp TO [sa];

IF OBJECT_ID('dbo.debug_log', 'U') IS NOT NULL
	DROP TABLE dbo.debug_log;
CREATE TABLE dbo.debug_log ( message text, logged_at DATETIME DEFAULT CURRENT_TIMESTAMP );
GO
IF OBJECT_ID ( 'dbo.log', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.log;
GO
CREATE PROCEDURE dbo.log(@msg TEXT)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO dbo.debug_log ( message )
	VALUES ( @msg );
END
GO




IF OBJECT_ID('dbo.names', 'U') IS NOT NULL
	DROP TABLE dbo.names;
CREATE TABLE dbo.names ( name VARCHAR(255), type VARCHAR(255) );

IF OBJECT_ID ( 'dbo.newidd_view', 'V' ) IS NOT NULL
	DROP VIEW dbo.newid_view;
GO
CREATE VIEW dbo.newid_view AS SELECT NEWID() AS number
GO
--uniqueidentifier


IF OBJECT_ID ( 'dbo.random_name', 'FN' ) IS NOT NULL
	DROP FUNCTION dbo.random_name;
GO
CREATE FUNCTION dbo.random_name( @type VARCHAR(255) )
	RETURNS VARCHAR(255)
BEGIN
--	DECLARE @name VARCHAR(255)
--	SELECT TOP 1 @name = name FROM dbo.names 
--		WHERE type = @type 
--		ORDER BY ( SELECT number FROM dbo.newid_view )
--	RETURN @name
	RETURN ( SELECT TOP 1 name FROM dbo.names 
		WHERE type = @type 
		ORDER BY ( SELECT number FROM dbo.newid_view ) )
END
GO

IF OBJECT_ID ( 'dbo.random_female_name', 'FN' ) IS NOT NULL
	DROP FUNCTION dbo.random_female_name;
GO
CREATE FUNCTION dbo.random_female_name()
	RETURNS VARCHAR(255)
BEGIN
	RETURN dbo.random_name('female')
END
GO

IF OBJECT_ID ( 'dbo.random_male_name', 'FN' ) IS NOT NULL
	DROP FUNCTION dbo.random_male_name;
GO
CREATE FUNCTION dbo.random_male_name()
	RETURNS VARCHAR(255)
BEGIN
	RETURN dbo.random_name('male')
END
GO

IF OBJECT_ID ( 'dbo.random_last_name', 'FN' ) IS NOT NULL
	DROP FUNCTION dbo.random_last_name;
GO
CREATE FUNCTION dbo.random_last_name()
	RETURNS VARCHAR(255)
BEGIN
	RETURN dbo.random_name('last')
END
GO






--Can't use RAND() in function. This is a workaround.
--http://blog.sqlauthority.com/2012/11/20/sql-server-using-rand-in-user-defined-functions-udf/
IF OBJECT_ID ( 'dbo.rand_view', 'V' ) IS NOT NULL
	DROP VIEW dbo.rand_view;
GO
CREATE VIEW dbo.rand_view AS SELECT RAND() AS number
GO


IF OBJECT_ID ( 'dbo.random_sex', 'FN' ) IS NOT NULL
	DROP FUNCTION dbo.random_sex;
GO
CREATE FUNCTION dbo.random_sex()
	RETURNS VARCHAR(1)
BEGIN
	--some languages are so complicated!
	--['M','F'][random(2)]
	DECLARE @sexes TABLE ( id INT IDENTITY(1,1), sex VARCHAR(1) )
	INSERT INTO @sexes VALUES ('M'),('F')
  DECLARE @rand DECIMAL(18,18)
  SELECT @rand = number FROM dbo.rand_view
	DECLARE @sex VARCHAR(1)
	SELECT @sex = sex FROM @sexes WHERE id = CAST(2*@rand AS INT)+1;
	RETURN @sex
END
GO


IF OBJECT_ID ( 'dbo.random_date_in', 'FN' ) IS NOT NULL
	DROP FUNCTION dbo.random_date_in;
GO
CREATE FUNCTION dbo.random_date_in(
	@from_date DATE = '2010-01-01', 
	@to_date   DATE = '2015-12-31' )
	RETURNS DATE
BEGIN
	DECLARE @rand DECIMAL(18,18)
	SELECT @rand = number FROM dbo.rand_view
	RETURN DATEADD(day, 
		@rand*(1+DATEDIFF(DAY, @from_date, @to_date)), 
		@from_date)
END
GO
--NEED to pass 2 params. (default,default) uses the defaults. Duh!

--Create a different function that takes no params
--and have it call the other function with params
IF OBJECT_ID ( 'dbo.random_date', 'FN' ) IS NOT NULL
	DROP FUNCTION dbo.random_date;
GO
CREATE FUNCTION dbo.random_date()
	RETURNS DATE
BEGIN
	RETURN dbo.random_date_in(default,default);
END
GO



--http://stackoverflow.com/questions/9645348/how-to-insert-1000-random-dates-between-a-given-range
--IF OBJECT_ID ( 'dbo.create_a_random_date', 'P' ) IS NOT NULL
--	DROP PROCEDURE dbo.create_a_random_date;
--GO
--CREATE PROCEDURE dbo.create_a_random_date(
--	@random_date DATE OUTPUT,
--	@from_date DATE = '2010-01-01', 
--	@to_date   DATE = '2015-12-31' )
--AS
--BEGIN
--	SET NOCOUNT ON;
--
----	DECLARE @from_date DATE = '2010-01-01'
----	DECLARE @to_date DATE = '2015-12-31'
--
--	SELECT @random_date = DATEADD(day, 
--		RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @from_date, @to_date)), 
--		@from_date)
--
--END
--GO




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

	--Add column with constraint
	SELECT @cmd = 'ALTER TABLE [' + @schema + '].[' + @table + 
		'] ADD imported_at DATETIME CONSTRAINT '
		+ @cname + ' DEFAULT CURRENT_TIMESTAMP NOT NULL ;';
	PRINT @cmd
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

USE chirp;

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
