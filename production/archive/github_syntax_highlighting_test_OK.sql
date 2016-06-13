CREATE PROCEDURE bin.testing
AS
BEGIN
	SET NOCOUNT ON;

	-- Char of

	-- Using CHAR(92) instead of a \ which mucks up syntax highlighting as it "escapes" the closing quote
	DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
		ISNULL(NULLIF(CHARINDEX(CHAR(92), @rf )-1,-1),LEN(@rf))))
	-- DECLARE @filename VARCHAR(255) = REVERSE( SUBSTRING( @rf, 1, 
	--	ISNULL(NULLIF(CHARINDEX('\', @rf )-1,-1),LEN(@rf))))
	-- '  The previous line mucks up syntax highlighting by escaping the quote, so added one here.

END	--	bin.testing
GO
