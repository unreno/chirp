
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name='private')
	EXEC('CREATE SCHEMA private')
GO
IF OBJECT_ID('private.identifiers', 'U') IS NOT NULL
	DROP TABLE private.identifiers;
CREATE TABLE private.identifiers (
	id INT IDENTITY(1,1),
	CONSTRAINT private_identifiers_id PRIMARY KEY CLUSTERED (id ASC),
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


--Can't use RAND() in function. This is a workaround.
--http://blog.sqlauthority.com/2012/11/20/sql-server-using-rand-in-user-defined-functions-udf/
IF OBJECT_ID ( 'private.rand_view', 'V' ) IS NOT NULL
	DROP VIEW private.rand_view;
GO
CREATE VIEW private.rand_view AS SELECT RAND() AS number
GO

IF OBJECT_ID ( 'private.create_unique_chirp_id', 'FN' ) IS NOT NULL
	DROP FUNCTION private.create_unique_chirp_id;
GO
CREATE FUNCTION private.create_unique_chirp_id()
	RETURNS INT
BEGIN
	DECLARE @minid INT = 1e9;
	DECLARE @maxid INT = POWER(2.,31)-1;
	DECLARE @tempid INT = 0;
	DECLARE @rand DECIMAL(18,18)

	WHILE ((@tempid = 0) OR
		EXISTS (SELECT * FROM private.identifiers WHERE chirp_id=@tempid))
	BEGIN
		SELECT @rand = number FROM private.rand_view
		-- By using a min of 1e9, no need for leading zeroes.
		SET @tempid = CAST(
			(@minid + (@rand * (@maxid-@minid)))
			AS INTEGER);
	END

	RETURN @tempid
END
GO

