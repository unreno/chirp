
SELECT DISTINCT vaccination_desc, c.code, c.value, c.units 
FROM webiz.immunizations i
LEFT JOIN dbo.dictionary d
	ON  d._schema = 'webiz'
	AND d._table = 'immunizations'
	AND d.field = 'vaccination_desc'
 LEFT JOIN dbo.codes c
	ON  c._schema = 'webiz'
	AND c._table = 'immunizations'
	AND d.codeset = c.codeset
	AND CAST(c.code AS VARCHAR(255)) = vaccination_desc
WHERE units IS NULL 

