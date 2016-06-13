CREATE PROCEDURE bin.testing
AS
BEGIN
	SET NOCOUNT ON;

	-- Char of

	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))))

END	--	bin.testing
GO
