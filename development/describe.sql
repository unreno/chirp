


IF OBJECT_ID ( 'dbo.describe', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.describe;
GO
CREATE PROCEDURE dbo.describe( @schema_and_table VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	SELECT c.name, t.name, c.max_length
		FROM sys.columns c
		JOIN sys.types t ON t.system_type_id = c.system_type_id
		WHERE [object_id] = OBJECT_ID( @schema_and_table );
  
END
GO


-- EXEC dbo.describe 'dbo.observations'


--The following is also quite informative.

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'observations'


