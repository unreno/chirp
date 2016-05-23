
-- Simple (field, label, description, description, codeset, [if codeset, valid codes and values]).
-- No groupings. No counts.


-- This will create a row for every field and code (5241), so No.
SELECT * 
FROM dbo.dictionary d
LEFT JOIN dbo.codes c on d.codeset = c.codeset


-- It would be nice to be able to join the code/value with a carriage return.

-- Tried to use CHAR(13), but gets encoded by FOR XML
-- Tried to change it back with REPLACE, but function limited to 8000 bytes.
-- My mistake
-- REPLACE( long_string, '&#x0D;', CHAR(13)) 
-- Still didn't work. Just replaced it with white space.


--SELECT _schema, _table, field, label, definition, codeset,
SELECT field, label, definition, codeset,
	CASE WHEN codeset IS NOT NULL THEN (
		STUFF( ( 
			SELECT ', ' + CAST(code AS VARCHAR) + ' = ' + value 
			FROM dbo.codes c
			WHERE c.codeset = d.codeset
			FOR XML PATH('') 
		), 1, 2, '')
	)
	ELSE NULL END AS codes
FROM dbo.dictionary d
WHERE _table = 'births'

