
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='fakedoc1')
	EXEC('CREATE SCHEMA fakedoc1')
GO

IF OBJECT_ID('fakedoc1.emr', 'U') IS NOT NULL
	DROP TABLE fakedoc1.emr;
CREATE TABLE fakedoc1.emr (
	id INT IDENTITY(1,1) PRIMARY KEY,
	record_number INT,
	name_first VARCHAR(250),
	name_last VARCHAR(250),
	date_of_birth DATETIME,
	sex VARCHAR(1),
	code VARCHAR(250),
	value VARCHAR(250)
);
GO

EXEC dbo.add_imported_at_column_to_tables_by_schema 'fakedoc1';
EXEC dbo.add_imported_to_dw_column_to_tables_by_schema 'fakedoc1';
