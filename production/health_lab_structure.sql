USE chirp
GO

IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='health_lab')
	EXEC('CREATE SCHEMA health_lab')
GO

IF OBJECT_ID('health_lab.newborn_screening', 'U') IS NOT NULL
	DROP TABLE health_lab.newborn_screening;
CREATE TABLE health_lab.newborn_screening (
	id INT IDENTITY(1,1) PRIMARY KEY,
	name_first VARCHAR(250),
	name_last VARCHAR(250),
	date_of_birth DATETIME,
	sex VARCHAR(1),
	blahblah VARCHAR(250),
	yadayada VARCHAR(250),
);
GO

EXEC dbo.add_imported_at_column_to_tables_by_schema 'health_lab';
EXEC dbo.add_imported_to_dw_column_to_tables_by_schema 'health_lab';
