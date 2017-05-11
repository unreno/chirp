
-- don't think this possible in SQL Server.
-- Trying explicit select into insert command.
-- Will need to CAST some variables as SQL Server won't do the obvious here.
-- Could do single insert command and simply select the VALUEs
-- Either way not perfect. Will require some manual meddling.
-- Will also have to list the field names if not doing all in proper order.


PRINT 'INSERT INTO observations VALUES '
SELECT 
'(' + CAST(id as VARCHAR(20)) + ',' + CAST(chirp_id AS VARCHAR(20))
+ '),'
FROM dbo.observations


SELECT 
'INSERT INTO observations VALUES (' +
CAST(id AS VARCHAR(10)) + ',' +
CAST(chirp_id AS VARCHAR(10)) + ',' +
'''' + concept + '''' +
');'
FROM dbo.observations
