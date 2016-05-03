
IF OBJECT_ID ( 'dbo.destroy_schema', 'P' ) IS NOT NULL
	DROP PROCEDURE dbo.destroy_schema;
GO
CREATE PROCEDURE dbo.destroy_schema( @schema VARCHAR(255) )
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @type VARCHAR(255);
	DECLARE @name VARCHAR(255);
	DECLARE @prefix VARCHAR(255);
	DECLARE @sql VARCHAR(255);

	DECLARE objects CURSOR FOR SELECT o.type, o.name 
		FROM sys.objects o
			INNER JOIN sys.schemas s
			ON o.schema_id = s.schema_id
			where s.name = @schema;

	OPEN objects;
	WHILE(1=1)BEGIN
		FETCH objects INTO @type, @name;
		IF(@@FETCH_STATUS <> 0)
			BREAK
		SET @prefix = CASE @type
			WHEN 'U' THEN 'DROP TABLE '
			WHEN 'P' THEN 'DROP PROCEDURE '
			WHEN 'FN' THEN 'DROP FUNCTION '
			WHEN 'IF' THEN 'DROP FUNCTION '
			WHEN 'TF' THEN 'DROP FUNCTION '
			WHEN 'V' THEN 'DROP VIEW '
			WHEN 'TR' THEN 'DROP TRIGGER '
		END
		IF @prefix IS NOT NULL BEGIN
			SET @sql = @prefix + @schema + '.' + @name
			PRINT @sql
			EXEC(@sql)
		END ELSE
			PRINT @type
	END
	CLOSE objects;
	DEALLOCATE objects;

	SET @sql = 'DROP SCHEMA ' + @schema;
	EXEC( @sql );
END
