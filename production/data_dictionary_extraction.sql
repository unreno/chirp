
SELECT field, label, definition, d.codeset, code, value
FROM dbo.dictionary d
LEFT JOIN dbo.codes c
ON d._table = c._table
AND d.codeset = c.codeset
WHERE d._table = 'births'
ORDER BY d.field, CAST(c.code AS INT)

