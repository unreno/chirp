#
#	So technically, you can't really rename a schema.
#	You have to create a new schema and move all of the tables.
#

#	The N'' apparently ensures unicode

SELECT t.name, s.name
  FROM sys.tables AS t
  INNER JOIN sys.schemas AS s
  ON t.[schema_id] = s.[schema_id]
  WHERE s.name = N'Medicare';



CREATE SCHEMA NewMedicare;
GO


SELECT 'ALTER SCHEMA NewMedicare TRANSFER [' + s.name + '].[' + o.name + '];'
FROM sys.objects o
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE s.name = 'Medicare';

-- Generates ..
--...
--ALTER SCHEMA NewMedicare TRANSFER [Medicare].[ASC_Quality_Facility];
--ALTER SCHEMA NewMedicare TRANSFER [Medicare].[ASC_Quality_National];
--ALTER SCHEMA NewMedicare TRANSFER [Medicare].[ASC_Quality_State];
--...


-- Could use sys.tables also but wouldn't include views, procedures, etc.
-- Could also wrap this in a CURSOR and perhaps create a procedure.
-- Or just copy and paste the output into query window and run.
-- Seriously, how often would this be done?


--AND (o.type IN ('U', 'P', 'V'))


