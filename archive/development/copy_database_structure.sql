
-- How to copy an entire database structure without the data?

-- This will copy a table.
SELECT * INTO testing FROM modifier_dimension WHERE 0=1;

-- Triggers?
-- Procedures?
-- Other objects?




It would seem that the simplest way to do this would be to 
back it up, restore it and then delete the data.
If there is a lot of data, this may take a while.




http://stackoverflow.com/questions/2043726/best-way-to-copy-a-database-sql-server-2008

Easiest way is actually a script.
Run this on production:
USE MASTER;

BACKUP DATABASE [MyDatabase]
TO DISK = 'C:\temp\MyDatabase1.bak' -- some writeable folder. 
WITH COPY_ONLY
This one command makes a complete backup copy of the database onto a single file, without interfering with production availability or backup schedule, etc.
To restore, just run this on your dev or test SQL Server:
USE MASTER;

RESTORE DATABASE [MyDatabase]
FROM DISK = 'C:\temp\MyDatabase1.bak'
WITH
MOVE 'MyDatabase'   TO 'C:\Sql\MyDatabase.mdf', -- or wherever these live on target
MOVE 'MyDatabase_log'   TO 'C:\Sql\MyDatabase_log.ldf',
REPLACE, RECOVERY
Then save these scripts on production, test and dev. One-click convenience.
Edit:
if you get an error when restoring that the logical names don't match, you can get them like this:
RESTORE FILELISTONLY
FROM disk = 'C:\temp\MyDatabaseName1.bak'
If you use SQL Server logins (not windows authentication) you can run this after restoring each time (on the dev/test machine):
use MyDatabaseName;
sp_change_users_login 'Auto_Fix', 'userloginname', null, 'userpassword';


(The WITH COPY_ONLY probably isn’t necessary but seems like a good idea.)
(I don’t think that the RESTORE WITH and MOVE lines are necessary.)
Then TRUNCATE TABLE [table name];
Don't use Truncate here -- it won't work if you have foreign keys????? (may depend on order)
Truncate the pointers before the targets.








Just stumbled on this ....
Not sure exactly how it could be implemented, but there it is.


http://mangalpardeshi.blogspot.com/2009/03/script-all-store-procedures-in-database.html

In Sql Server 2005 and 2008 you can script the stored procedure in Management Studio by right clicking on Store Procedure name and clicking on “Script Store Procedure as” and then “Create To”.

But if you want to script all the Stored Procedures in the database programmatically, then here is the simple T-SQL query for it -

To script All the Stored Procedures in the Database :

SELECT    O.Name as ProcName
        ,M.Definition as CreateScript
        ,O.Create_Date
        ,O.Modify_Date
FROM sys.sql_modules as M INNER JOIN sys.objects as O
ON M.object_id = O.object_id
WHERE O.type = 'P'

If the Stored Procedure is created with ENCRYPTION option then you will get the NULL in the definition column.

Similarly,

To script All the Views in the Database :

SELECT    O.Name as ProcName
        ,M.Definition as CreateScript
        ,O.Create_Date
        ,O.Modify_Date
FROM sys.sql_modules as M INNER JOIN sys.objects as O
ON M.object_id = O.object_id
WHERE O.type = 'V'

To script All the Functions in the Database :

SELECT    O.Name as ProcName
        ,M.Definition as CreateScript
        ,O.Create_Date
        ,O.Modify_Date
FROM sys.sql_modules as M INNER JOIN sys.objects as O
ON M.object_id = O.object_id
WHERE O.type = 'FN'

For scripting all Triggers small modification is required, instead of sys.objects I joined the sys.triggers with sys.sql_modules.

To script All the Triggers in the Database :

SELECT    O.Name as ProcName
        ,M.Definition as CreateScript
        ,O.Create_Date
        ,O.Modify_Date
FROM sys.sql_modules as M INNER JOIN sys.triggers as O
ON M.object_id = O.object_id

Mangal Pardeshi
SQL MVP







OR

EXEC sp_helptext 'linkrenowns'








OR

declare @sql varchar(8000)

select @sql = object_definition(object_id) 
from sys.triggers
where name = 'testtrigger'

EXEC @sql







All that said, there may be issues with long lines, triggers or procedures being line wrapper or truncated.



