CREATE PROCEDURE bin.testing
AS
BEGIN
	SET NOCOUNT ON;

	-- Char of

	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))))
	--	ISNULL(NULLIF(CHARINDEX('\', @rf )-1,-1),LEN(@rf))))
	-- '  The previous line mucks up syntax highlighting by escaping the quote, so added one here.

END	--	bin.testing
GO
