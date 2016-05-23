
-- The FOR XML clause is a nice way to convert the results of
-- a query into a single string.

-- Selecting just the field will result in a very xml output

SELECT code FROM dbo.codes c
WHERE c.codeset = 'standard_2yesno'
FOR XML PATH(''

-- <code>1</code><code>2</code><code>9</code>


-- However, manipulating the selection returns just a string

SELECT ';' + CAST(code AS VARCHAR) FROM dbo.codes c
WHERE c.codeset = 'standard_2yesno'
FOR XML PATH('')

-- ;1;2;9

-- Of course, you probably want to strip of the first divider.

STUFF((
	SELECT ';' + CAST(code AS VARCHAR) FROM dbo.codes c
	WHERE c.codeset = 'standard_2yesno'
	FOR XML PATH('')
FOR XML PATH('')
), 1, 1, '')

