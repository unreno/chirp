

EXEC tSQLt.NewTestClass 'testChirp';
GO



CREATE PROCEDURE testChirp.[test that will only create 1 observation records for vr:birth dob]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @actual INT;
	DECLARE @expected INT = 0;
	EXEC tSQLt.FakeTable 'vital.birth', @Defaults = 'TRUE';
	
	INSERT INTO vital.birth 
		( birthid, state_file_number, date_of_birth )
		VALUES 
			( 1, CAST(RAND()*1e9 AS INT), dev.random_date() );
	SELECT @actual = COUNT(*) FROM vital.birth;
	SET @expected = 1;
	EXEC tSQLt.AssertEquals @expected, @actual;

	EXEC tSQLt.FakeTable 'private.identifiers';
	INSERT INTO private.identifiers
		( chirp_id, source_schema, source_table, source_column, source_id ) 
		SELECT private.create_unique_chirp_id(), 'vital', 'birth', 'state_file_number', 
			state_file_number from vital.birth b where b.imported_to_observations = 'FALSE';
	SELECT @actual = COUNT(*) FROM private.identifiers;
	EXEC tSQLt.AssertEquals @expected, @actual;

	EXEC tSQLt.FakeTable 'dbo.observations';
	EXEC bin.import_into_data_warehouse

	SELECT @actual = COUNT(*) FROM dbo.observations;
	SET @expected = 1;	--	DOB
	EXEC tSQLt.AssertEquals @expected, @actual;
END
GO

CREATE PROCEDURE testChirp.[test that will only create 1 observation records for vr:birth weight]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @actual INT;
	DECLARE @expected INT = 0;
	EXEC tSQLt.FakeTable 'vital.birth', @Defaults = 'TRUE';
	
	INSERT INTO vital.birth 
		( birthid, state_file_number, date_of_birth, birth_weight_lbs, birth_weight_oz )
		VALUES 
			( 1, CAST(RAND()*1e9 AS INT), dev.random_date(), 
				CAST(RAND()*5 AS INT)+5, CAST(RAND()*16 AS INT) );
	SELECT @actual = COUNT(*) FROM vital.birth;
	SET @expected = 1;
	EXEC tSQLt.AssertEquals @expected, @actual;

	EXEC tSQLt.FakeTable 'private.identifiers';
	INSERT INTO private.identifiers
		( chirp_id, source_schema, source_table, source_column, source_id ) 
		SELECT private.create_unique_chirp_id(), 'vital', 'birth', 'state_file_number', 
			state_file_number from vital.birth b where b.imported_to_observations = 'FALSE';
	SELECT @actual = COUNT(*) FROM private.identifiers;
	EXEC tSQLt.AssertEquals @expected, @actual;

	EXEC tSQLt.FakeTable 'dbo.observations';
	EXEC bin.import_into_data_warehouse

	SELECT @actual = COUNT(*) FROM dbo.observations;
	SET @expected = 2;	--	DOB, Weight
	EXEC tSQLt.AssertEquals @expected, @actual;
END
GO

CREATE PROCEDURE testChirp.[test that will only create 1 observation records for vr:birth sex]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @actual INT;
	DECLARE @expected INT = 0;
	EXEC tSQLt.FakeTable 'vital.birth', @Defaults = 'TRUE';

	INSERT INTO vital.birth 
		( birthid, state_file_number, date_of_birth, sex )
		VALUES 
			( 1, CAST(RAND()*1e9 AS INT), dev.random_date(), dev.random_sex() );
	SELECT @actual = COUNT(*) FROM vital.birth;
	SET @expected = 1;
	EXEC tSQLt.AssertEquals @expected, @actual;

	EXEC tSQLt.FakeTable 'private.identifiers';
	INSERT INTO private.identifiers
		( chirp_id, source_schema, source_table, source_column, source_id ) 
		SELECT private.create_unique_chirp_id(), 'vital', 'birth', 'state_file_number', 
			state_file_number from vital.birth b where b.imported_to_observations = 'FALSE';
	SELECT @actual = COUNT(*) FROM private.identifiers;
	EXEC tSQLt.AssertEquals @expected, @actual;

	EXEC tSQLt.FakeTable 'dbo.observations';
	EXEC bin.import_into_data_warehouse

	SELECT @actual = COUNT(*) FROM dbo.observations;
	SET @expected = 2;	--	DOB, Sex
	EXEC tSQLt.AssertEquals @expected, @actual;
END
GO

CREATE PROCEDURE testChirp.[test that will CURRENTLY create 3 observation records]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @actual INT;
	EXEC tSQLt.FakeTable 'vital.birth', @Defaults = 'TRUE';
	SELECT @actual = COUNT(*) FROM vital.birth;
	DECLARE @expected INT = 0;
	EXEC tSQLt.AssertEquals @expected, @actual;
	
	EXEC dev.create_random_vital 1
	SELECT @actual = COUNT(*) FROM vital.birth;
	SET @expected = 1;
	EXEC tSQLt.AssertEquals @expected, @actual;

	EXEC tSQLt.FakeTable 'private.identifiers';
	INSERT INTO private.identifiers
		( chirp_id, source_schema, source_table, source_column, source_id ) 
		SELECT private.create_unique_chirp_id(), 'vital', 'birth', 'state_file_number', 
			state_file_number from vital.birth b where b.imported_to_observations = 'FALSE';
	SELECT @actual = COUNT(*) FROM private.identifiers;
	EXEC tSQLt.AssertEquals @expected, @actual;

	EXEC tSQLt.FakeTable 'dbo.observations';
	EXEC bin.import_into_data_warehouse

	SELECT @actual = COUNT(*) FROM dbo.observations;
	SET @expected = 3;	--	Sex, DOB, Weight
	EXEC tSQLt.AssertEquals @expected, @actual;
END;
GO


CREATE PROCEDURE testChirp.[test that can create a single identifier record]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @actual INT;
	EXEC tSQLt.FakeTable 'vital.birth', @Defaults = 'TRUE';
	SELECT @actual = COUNT(*) FROM vital.birth;
	DECLARE @expected INT = 0;
	EXEC tSQLt.AssertEquals @expected, @actual;
	
	EXEC dev.create_random_vital 1
	SELECT @actual = COUNT(*) FROM vital.birth;
	SET @expected = 1;
	EXEC tSQLt.AssertEquals @expected, @actual;

	EXEC tSQLt.FakeTable 'private.identifiers';
	INSERT INTO private.identifiers
		( chirp_id, source_schema, source_table, source_column, source_id ) 
		SELECT private.create_unique_chirp_id(), 'vital', 'birth', 'state_file_number', 
			state_file_number from vital.birth b where b.imported_to_observations = 'FALSE';
	SELECT @actual = COUNT(*) FROM private.identifiers;
	EXEC tSQLt.AssertEquals @expected, @actual;
END;
GO


CREATE PROCEDURE testChirp.[test that can create a single vital records birth record]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @actual INT;
	EXEC tSQLt.FakeTable 'vital', 'birth', @Defaults = 'TRUE';
	SELECT @actual = COUNT(*) FROM vital.birth;
	DECLARE @expected INT = 0;
	EXEC tSQLt.AssertEquals @expected, @actual;
	
	EXEC dev.create_random_vital 1
	SELECT @actual = COUNT(*) FROM vital.birth;
	SET @expected = 1;
	EXEC tSQLt.AssertEquals @expected, @actual;
END;
GO


CREATE PROCEDURE testChirp.[test that fake observation table is created empty]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @actual INT;
	EXEC tSQLt.FakeTable 'dbo', 'observations';
	SELECT @actual = COUNT(*) FROM dbo.observations;
	DECLARE @expected INT = 0;
	EXEC tSQLt.AssertEquals @expected, @actual;
END;
GO


IF OBJECT_ID ( 'dbo.run_my_tests', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.run_my_tests;
GO
CREATE PROCEDURE dbo.run_my_tests
AS
BEGIN
	SET NOCOUNT ON;

	--SELECT name,value FROM sys.configurations C
	--WHERE name = 'clr enabled'
	--ORDER BY C.name

	--This must be run before INSTALLING AND before RUNNING tSQLt.
	EXEC sp_configure 'clr enabled', 1;
	RECONFIGURE;
	--SELECT name,value FROM sys.configurations C
	--WHERE name = 'clr enabled'
	--ORDER BY C.name

	--SELECT name, is_trustworthy_on FROM sys.databases
	--0=OFF or 1=ON
	--ALTER DATABASE chirp SET TRUSTWORTHY ON;	--This does not seem to actually matter?
	--SELECT name, is_trustworthy_on FROM sys.databases


	PRINT 'Running Tests.';
	EXEC tSQLt.RunAll
	PRINT 'Done Running Tests.';


	EXEC sp_configure 'clr enabled', 0;
	RECONFIGURE;
	--SELECT name,value FROM sys.configurations C
	--WHERE name = 'clr enabled'
	--ORDER BY C.name
	--ALTER DATABASE chirp SET TRUSTWORTHY OFF;
	--SELECT name, is_trustworthy_on FROM sys.databases

END
GO
