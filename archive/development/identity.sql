

-- BY DEFAULT the IDENTITY field IS NOT UNIQUE

-- Does it have to be INT?
-- What are the 1,1 for?

-- id INT IDENTITY(1,1),

-- By itself, this just makes it autoincrement, apparently.

-- Create an index to make it be unique

-- CONSTRAINT vital_births_id PRIMARY KEY CLUSTERED (id ASC),


CREATE TABLE #tmp(ID INT IDENTITY(1,1), Name nvarchar(100))
DBCC CHECKIDENT( #tmp, NORESEED )

-- Be sure to include the NORESEED
-- Apparently without it, the function can do something

-- By default, apparently it is null
--Checking identity information: current identity value 'NULL', current column value 'NULL'.
--DBCC execution completed. If DBCC printed error messages, contact your system administrator.

-- You can reset it to anything, but not NULL, apparently.

DBCC CHECKIDENT( #tmp, RESEED, 0)



-- This could be useful in temp table. BULK INSERT data to set the record number in file,
-- then move to permanent table, reset id field to 0 for next file.




