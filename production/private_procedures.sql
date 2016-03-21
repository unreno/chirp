USE chirp
-- Sadly, TSQL scripts don't seem to crash
-- IF chirp doesn't exist, this script continues after the GO statement.
GO


IF OBJECT_ID ( 'dbo.create_unique_chirp_id', 'FN' ) IS NOT NULL
	DROP FUNCTION dbo.create_unique_chirp_id;
GO
CREATE FUNCTION dbo.create_unique_chirp_id()
	RETURNS INT
BEGIN
	DECLARE @minid INT = 1e9;
	DECLARE @maxid INT = POWER(2.,31)-1;
	DECLARE @tempid INT = 0;
	DECLARE @rand DECIMAL(18,18)

	WHILE ((@tempid = 0) OR
		EXISTS (SELECT * FROM private.identifiers WHERE chirp_id=@tempid))
	BEGIN
		SELECT @rand = number FROM rand_view
		-- By using a min of 1e9, no need for leading zeroes.
		SET @tempid = CAST(
			(@minid + (@rand * (@maxid-@minid)))
			AS INTEGER);
	END

	RETURN @tempid
END
GO
