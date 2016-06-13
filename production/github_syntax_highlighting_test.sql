

IF OBJECT_ID ( 'bin.import_birth_records', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_birth_records;
GO
CREATE PROCEDURE bin.import_birth_records( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	-- Something in the following section of code mucks up github syntax highlighting.
	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));
	-- Using CHAR(92) instead of a \ which mucks up syntax highlighting as it "escapes" the closing quote
	-- DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
	--	ISNULL(NULLIF(CHARINDEX('\', @rf )-1,-1),LEN(@rf))))
	-- '  The previous line mucks up syntax highlighting by escaping the quote, so added one here.

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT vital.bulk_insert_births
		FROM ''' + @file_with_path + '''
		WITH (
			ROWTERMINATOR = '''+CHAR(10)+''',
			FIRSTROW = 2,
			TABLOCK
		)';

	DBCC CHECKIDENT( 'vital.births_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE vital.births_buffer
		ADD CONSTRAINT temp_source_filename
		DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE vital.births_buffer DROP CONSTRAINT temp_source_filename;

END	--	bin.import_birth_records
GO


IF OBJECT_ID ( 'bin.import_newborn_screening_records_2015', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_newborn_screening_records_2015;
GO
CREATE PROCEDURE bin.import_newborn_screening_records_2015( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	-- Something in the following section of code mucks up github syntax highlighting.
	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));
	-- Using CHAR(92) instead of a \ which mucks up syntax highlighting as it "escapes" the closing quote
	-- DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
	--	ISNULL(NULLIF(CHARINDEX('\', @rf )-1,-1),LEN(@rf))))
	-- '  The previous line mucks up syntax highlighting by escaping the quote, so added one here.

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2015
		FROM ''' + @file_with_path + '''
		WITH (
			ROWTERMINATOR = '''+CHAR(10)+''',
			FIRSTROW = 2,
			TABLOCK
		)';

	DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE health_lab.newborn_screenings_buffer
		ADD CONSTRAINT temp_source_filename
		DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE health_lab.newborn_screenings_buffer
		DROP CONSTRAINT temp_source_filename;

END	--	bin.import_newborn_screening_records_2015
GO

-- Sadly, the format changed from 2015 to 2016

IF OBJECT_ID ( 'bin.import_newborn_screening_records_2016', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_newborn_screening_records_2016;
GO
CREATE PROCEDURE bin.import_newborn_screening_records_2016( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	-- Something in the following section of code mucks up github syntax highlighting.
	DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));
	-- Using CHAR(92) instead of a \ which mucks up syntax highlighting as it "escapes" the closing quote
	-- DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
	--	ISNULL(NULLIF(CHARINDEX('\', @rf )-1,-1),LEN(@rf))))
	-- '  The previous line mucks up syntax highlighting by escaping the quote, so added one here.

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT health_lab.bulk_insert_newborn_screenings_2016
		FROM ''' + @file_with_path + '''
		WITH (
			ROWTERMINATOR = '''+CHAR(10)+''',
			FIRSTROW = 2,
			TABLOCK
		)';

	DBCC CHECKIDENT( 'health_lab.newborn_screenings_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE health_lab.newborn_screenings_buffer
		ADD CONSTRAINT temp_source_filename
		DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE health_lab.newborn_screenings_buffer
		DROP CONSTRAINT temp_source_filename;

END	--	bin.import_newborn_screening_records_2016
GO

