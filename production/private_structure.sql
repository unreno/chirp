
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='private')
	EXEC('CREATE SCHEMA private')
GO
IF OBJECT_ID('private.identifiers', 'U') IS NOT NULL
	DROP TABLE private.identifiers;
CREATE TABLE private.identifiers (
	id int IDENTITY(1,1) PRIMARY KEY,
	chirp_id      INT NOT NULL,
	source_schema VARCHAR(50) NOT NULL,
	source_table  VARCHAR(50) NOT NULL,
	source_column VARCHAR(50) NOT NULL,
	source_id     VARCHAR(255) NOT NULL,
	created_at    DATETIME 
		CONSTRAINT private_identifiers_created_at_default 
		DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT unique_source_identifiers
		UNIQUE (source_schema,source_table,source_column,source_id)
);
GO
--4*255=1020. Its unlikely that any of these will be 255 chars. Shrinking.
--Warning! The maximum key length is 900 bytes. The index 'unique_source_identifiers' has maximum length of 1020 bytes. For some combination of large values, the insert/update operation will fail.


