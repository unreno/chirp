/*

You can capture everything really, but you would need to define 
the OUTPUT clause to handle it and target table to store it.


DECLARE @ids table (id INT)

INSERT INTO private.identifiers 
(chirp_id,source_schema,source_table,source_column,source_id) 
OUTPUT inserted.id INTO @ids
VALUES (1234, 'schema','table','field','id7') 

INSERT INTO private.identifiers 
(chirp_id,source_schema,source_table,source_column,source_id) 
OUTPUT inserted.id INTO @ids
VALUES (1234, 'schema','table','field','id9') 

SELECT * from @ids;	-- this will contain both rows.

DECLARE @id INT;
SELECT TOP 1 @id = id from @ids;
PRINT @id;



*/
