
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='vital_codes')
	EXEC('CREATE SCHEMA vital_codes')
GO

