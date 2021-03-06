
-- Object Types
--  U - User Table
--  P - Procedure
-- TR - Trigger
--  V - View?
-- IT - Internal Table
-- PK - Primary Key Constraint
-- SQ - Server Queue
--  D - Default Constraint
--  S - System Table
-- UQ - Unique Constraint
--  F - Foreign Key Constraint
--  C - CHECK constraint
-- FN - Normal function that returns something scalar
-- TF - returns a table variable filled by a selection
--
-- (Many more)



SELECT DISTINCT type, type_desc FROM sys.objects;


