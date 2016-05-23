
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='fakedoc1')
	EXEC('CREATE SCHEMA fakedoc1')
GO

IF OBJECT_ID('fakedoc1.emrs', 'U') IS NOT NULL
	DROP TABLE fakedoc1.emrs;
CREATE TABLE fakedoc1.emrs (
	id INT IDENTITY(1,1),
	CONSTRAINT fakedoc1_emr_id PRIMARY KEY CLUSTERED (id ASC),
	record_number VARCHAR(255),
	name_first VARCHAR(250),
	name_last VARCHAR(250),
	date_of_birth DATETIME,
	sex VARCHAR(1),
	code VARCHAR(255),
	value VARCHAR(255),
	units VARCHAR(255),
	service_at DATETIME
);
GO

EXEC bin.add_imported_at_column_to_tables_by_schema 'fakedoc1';
EXEC bin.add_imported_to_dw_column_to_tables_by_schema 'fakedoc1';
