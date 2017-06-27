
-- SCHEMA, TABLE, GROUP and GROUPING are reserved words
IF OBJECT_ID('dbo.codes', 'U') IS NOT NULL
	DROP TABLE dbo.codes;
CREATE TABLE dbo.codes (
	_schema VARCHAR(50) NOT NULL,
	_table VARCHAR(50) NOT NULL,
	codeset VARCHAR(50) NOT NULL,
	code VARCHAR(100) NOT NULL,	-- Vaccination descriptions are 100 so ...
	value VARCHAR(255) NOT NULL,
	units VARCHAR(20),	--	testing using "individual" and "combination" for immunizations


--	Can't have this restraint, otherwise can't split immunizations. Problems elsewhere???
--	Temporarily remove and then put back???
--	CONSTRAINT codes_unique_schema_table_codeset_code
--		UNIQUE ( _schema, _table, codeset, code )


);
-- FYI The maximum key length is 900 bytes. For some combination of large values, the insert/update operation will fail.

IF OBJECT_ID ( 'dbo.bulk_insert_codes', 'V' ) IS NOT NULL
	DROP VIEW dbo.bulk_insert_codes;
GO
CREATE VIEW dbo.bulk_insert_codes AS SELECT code, value FROM dbo.codes;
GO

IF OBJECT_ID ( 'dbo.bulk_insert_codes_with_units', 'V' ) IS NOT NULL
	DROP VIEW dbo.bulk_insert_codes_with_units;
GO
CREATE VIEW dbo.bulk_insert_codes_with_units AS SELECT code, value, units FROM dbo.codes;
GO

