
--Assuming that the database 'chirp'
--and the schema 'dev'
--and the table 'names' exists,
--and that the database 'chirpcopy' does not,

--create the new database, (if not copying to same database)
CREATE DATABASE chirpcopy;
GO

--use it, (can't create the schema with the db prefix, need to be in it)
USE chirpcopy;
GO

--create the new target schema, (if not default dbo)
CREATE SCHEMA dev;
GO

--and then copy the table. 
--(not sure if this copies indexes, constraints, triggers, etc.)
SELECT * INTO chirpcopy.dev.names FROM chirp.dev.names


