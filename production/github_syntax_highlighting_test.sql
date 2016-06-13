

	-- -- ADD PARAMETERS. Year, Month,

IF OBJECT_ID ( 'bin.link_screening_records_to_birth_records', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.link_screening_records_to_birth_records;
GO
CREATE PROCEDURE bin.link_screening_records_to_birth_records( @year INT = 2015, @month INT = 7 )
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO private.identifiers (
		chirp_id, source_schema, source_table, source_column, source_id, match_method )
		SELECT * FROM #temp_identifiers_link WHERE accession_kit_number NOT IN (
			SELECT accession_kit_number FROM #temp_identifiers_link
				GROUP BY accession_kit_number HAVING COUNT(1) > 1
		);

	IF OBJECT_ID('tempdb..#temp_identifiers_link', 'U') IS NOT NULL
		DROP TABLE #temp_identifiers_link;

END	--	bin.link_screening_records_to_birth_records
GO

IF OBJECT_ID ( 'bin.import_birth_records', 'P' ) IS NOT NULL
	DROP PROCEDURE bin.import_birth_records;
GO
CREATE PROCEDURE bin.import_birth_records( @file_with_path VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	-- -- Something in the following section of code mucks up github syntax highlighting.
DECLARE @rf VARCHAR(255) = REVERSE( @file_with_path );
DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))));
	-- -- Using CHAR(92) instead of a \ which mucks up syntax highlighting as it "escapes" the closing quote
	-- -- DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
	-- --  ISNULL(NULLIF(CHARINDEX('\', @rf )-1,-1),LEN(@rf))))
	-- -- '  The previous line mucks up syntax highlighting by escaping the quote, so added one here.

	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT vital.bulk_insert_births ' +
		'FROM ''' + @file_with_path + ''' WITH ( ' +
			'ROWTERMINATOR = '''+CHAR(10)+''', ' +
			'FIRSTROW = 2, TABLOCK )';

	DBCC CHECKIDENT( 'vital.births_buffer', RESEED, 0);

	DECLARE @alter_cmd VARCHAR(1000) = 'ALTER TABLE vital.births_buffer ' +
		'ADD CONSTRAINT temp_source_filename ' +
		'DEFAULT ''' + @filename + ''' FOR source_filename';
	EXEC(@alter_cmd);
	EXEC(@bulk_cmd);
	ALTER TABLE vital.births_buffer DROP CONSTRAINT temp_source_filename;

END	--	bin.import_birth_records
GO
