
GO

CREATE VIEW random_view AS SELECT RAND() number
GO
DECLARE @rand DECIMAL(18,18)
SELECT @rand = number FROM random_view
PRINT @rand
DROP VIEW random_view

GO

CREATE PROCEDURE random_proc( @number DECIMAL(18,18) OUTPUT ) AS SET @number = RAND()
GO
DECLARE @rand DECIMAL(18,18)
EXEC random_proc @rand OUTPUT
PRINT @rand
DROP PROCEDURE random_proc

GO

