
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
