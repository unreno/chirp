
IF OBJECT_ID('dbo.dictionary', 'U') IS NOT NULL
	DROP TABLE dbo.dictionary;
CREATE TABLE dbo.dictionary (
	_schema VARCHAR(50) NOT NULL,
	_table VARCHAR(50) NOT NULL,
	field VARCHAR(50) NOT NULL,
	codeset VARCHAR(50),
--	concept VARCHAR(255),	-- add concept?
	label VARCHAR(255),
--	definition VARCHAR(255),
	description VARCHAR(MAX),	-- very verbose
	CONSTRAINT dictionary_unique_schema_table_field
		UNIQUE ( _schema, _table, field ),
	CONSTRAINT dictionary_unique_schema_table_field_codeset
		UNIQUE ( _schema, _table, field, codeset )
);

-- These files were created from a Windows file and hence had hidden CRLFs!
-- Had to "sed 's/^M//' birth_dictionary.csv" them to correct.

--BEGIN TRY
--		FIELDTERMINATOR = '','',
	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT dbo.dictionary
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\birth_dictionary.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
--END TRY BEGIN CATCH
--	PRINT ERROR_MESSAGE()
--END CATCH
GO

--BEGIN TRY
--		FIELDTERMINATOR = '','',
	DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT dbo.dictionary
	FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\vital\death_dictionary.tsv''
	WITH (
		ROWTERMINATOR = '''+CHAR(10)+''',
		FIRSTROW = 2,
		TABLOCK
	)';
	EXEC(@bulk_cmd);
--END TRY BEGIN CATCH
--	PRINT ERROR_MESSAGE()
--END CATCH
GO


DECLARE @bulk_cmd VARCHAR(1000) = 'BULK INSERT dbo.dictionary
FROM ''Z:\Renown Project\CHIRP\Personal folders\Jake\chirp\production\content\webiz\immunization_dictionary.tsv''
WITH (
	ROWTERMINATOR = '''+CHAR(10)+''',
	FIRSTROW = 2,
	TABLOCK
)';
EXEC(@bulk_cmd);
GO

